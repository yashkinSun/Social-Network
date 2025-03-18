package MiniNewsNet::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

__PACKAGE__->config(namespace => '');

sub auto :Private {
    my ($self, $c) = @_;
    # Можно добавить проверку сессии или другие действия до каждого запроса
    return 1;
}
sub index : Path : Args(0) {
    my ($self, $c) = @_;

    # Диагностика пути
    my $path = $c->path_to('root','templates','index.tt');
    warn "Path to index.tt => $path";

    # Добавим проверку -e (существование файла)
    if (-e $path) {
        $c->log->debug("Perl sees index.tt ( -e => TRUE )");
    } else {
        $c->log->debug("Perl does NOT see index.tt ( -e => FALSE )");
    }
    
    if (-r $path) {
        $c->log->debug("Index.tt is readable ( -r => TRUE )");
    } else {
        $c->log->debug("Index.tt is NOT readable ( -r => FALSE )");
    }

    # ...
    $c->stash(template => 'index.tt');
}
# Страница ошибки 404
sub default :Path {
    my ($self, $c) = @_;
    $c->response->body('Страница не найдена (404).');
    $c->response->status(404);
}

# Конец запроса
sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
