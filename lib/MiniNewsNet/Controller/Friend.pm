package MiniNewsNet::Controller::Friend;
use Moose;
use namespace::autoclean;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

# Отправка заявки в друзья
sub request_friend : Path('/friend/request') : Args(0) {
    my ($self, $c) = @_;
    $c->detach('/user/require_login') unless $c->user_exists;

    if ($c->request->method eq 'POST') {
        my $friend_id = $c->request->params->{friend_id};
        if ($friend_id && $friend_id != $c->user->id) {
            # Проверить, нет ли уже заявки
            my $exists = $c->model('DB::Friend')->find({
                user_id   => $c->user->id,
                friend_id => $friend_id,
            });

            unless ($exists) {
                $c->model('DB::Friend')->create({
                    user_id   => $c->user->id,
                    friend_id => $friend_id,
                    status    => 'pending',
                    created_at=> DateTime->now,
                });
            }
            $c->stash->{message} = "Заявка отправлена";
        }
    }
    $c->response->redirect($c->uri_for('/'));
}

# Принятие/отклонение заявки
sub respond : Path('/friend/respond') : Args(0) {
    my ($self, $c) = @_;
    $c->detach('/user/require_login') unless $c->user_exists;

    if ($c->request->method eq 'POST') {
        my $friend_request_id = $c->request->params->{request_id};
        my $action = $c->request->params->{action}; # 'accept' или 'reject'

        my $fr = $c->model('DB::Friend')->find($friend_request_id);
        if ($fr && $fr->friend_id == $c->user->id && $fr->status eq 'pending') {
            if ($action eq 'accept') {
                $fr->update({ status => 'accepted' });
                # Можно создать обратную запись (user_id/ friend_id поменять) если нужно
            } elsif ($action eq 'reject') {
                $fr->update({ status => 'rejected' });
            }
        }
    }
    $c->response->redirect($c->uri_for('/friend/list'));
}

# Список друзей
sub list : Path('/friend/list') : Args(0) {
    my ($self, $c) = @_;
    $c->detach('/user/require_login') unless $c->user_exists;

    my $requests = $c->model('DB::Friend')->search({
        friend_id => $c->user->id,
        status    => 'pending',
    });

    my $friends = $c->model('DB::Friend')->search({
        -or => [
            { user_id => $c->user->id },
            { friend_id => $c->user->id },
        ],
        status => 'accepted',
    });

    $c->stash(
        template => 'friend/list.tt',
        requests => $requests,
        friends  => $friends,
    );
}

__PACKAGE__->meta->make_immutable;
1;
