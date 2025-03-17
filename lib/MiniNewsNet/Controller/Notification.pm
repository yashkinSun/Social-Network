package MiniNewsNet::Controller::Notification;
use Moose;
use namespace::autoclean;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

# Получение новых уведомлений (JSON)
sub get : Path('/notification/get') : Args(0) {
    my ($self, $c) = @_;
    $c->stash->{current_view} = 'JSON';
    $c->detach('/user/require_login') unless $c->user_exists;

    my @notifs = $c->model('DB::Notification')->search({
        user_id => $c->user->id,
        is_read => 0,
    },
    {
        order_by => { -desc => 'created_at' },
    });

    my @data;
    for my $n (@notifs) {
        push @data, {
            id      => $n->id,
            type    => $n->type,
            content => $n->content,
            link    => $n->link,
        };
    }

    $c->stash->{json_data} = \@data;
}

# Пометить уведомление как прочитанное
sub read : Path('/notification/read') : Args(0) {
    my ($self, $c) = @_;
    $c->stash->{current_view} = 'JSON';
    $c->detach('/user/require_login') unless $c->user_exists;

    if ($c->request->method eq 'POST') {
        my $notif_id = $c->request->params->{notif_id};
        if ($notif_id) {
            my $notif = $c->model('DB::Notification')->find($notif_id);
            if ($notif && $notif->user_id == $c->user->id) {
                $notif->update({ is_read => 1 });
            }
        }
    }
    $c->stash->{json_data} = { status => 'ok' };
}

__PACKAGE__->meta->make_immutable;
1;
