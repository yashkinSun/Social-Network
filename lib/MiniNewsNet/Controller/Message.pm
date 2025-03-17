package MiniNewsNet::Controller::Message;
use Moose;
use namespace::autoclean;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

# Список диалогов
sub inbox : Path('/message/inbox') : Args(0) {
    my ($self, $c) = @_;
    $c->detach('/user/require_login') unless $c->user_exists;

    # Упрощённый список последних сообщений
    my $msgs = $c->model('DB::Message')->search(
        {
            -or => [
                sender_id   => $c->user->id,
                receiver_id => $c->user->id,
            ],
        },
        { order_by => { -desc => 'created_at' } }
    );
    $c->stash(
        msgs     => $msgs,
        template => 'message/inbox.tt',
    );
}

# Отправка личного сообщения (GET/POST)
sub send : Path('/message/send') : Args(0) {
    my ($self, $c) = @_;
    $c->detach('/user/require_login') unless $c->user_exists;

    if ($c->request->method eq 'POST') {
        my $to   = $c->request->params->{receiver_id};
        my $text = $c->request->params->{content} || '';
        if ($to && $text) {
            $c->model('DB::Message')->create({
                sender_id   => $c->user->id,
                receiver_id => $to,
                content     => $text,
                created_at  => DateTime->now,
                read_status => 0,
            });
            $c->stash->{message} = "Сообщение отправлено";
        }
    }
    $c->response->redirect($c->uri_for('/message/inbox'));
}

__PACKAGE__->meta->make_immutable;
1;
