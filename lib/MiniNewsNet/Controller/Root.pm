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

# Главная страница - лента постов
sub index :Path :Args(0) {
    my ($self, $c) = @_;
    # Получаем посты из БД (упрощённая выборка)
    my $posts = $c->model('DB::Post')->search(
        {},
        { order_by => { -desc => 'created_at' } }
    );

    $c->stash(
        template => 'index.tt',
        posts    => $posts,
    );
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
