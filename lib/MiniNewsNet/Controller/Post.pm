package MiniNewsNet::Controller::Post;
use Moose;
use namespace::autoclean;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

# Просмотр конкретного поста
sub view : Path('/post/view') : Args(1) {
    my ($self, $c, $post_id) = @_;
    my $post = $c->model('DB::Post')->find($post_id);
    if (!$post) {
        $c->stash->{error_msg} = "Пост не найден";
        $c->response->redirect($c->uri_for('/'));
        return;
    }
    $c->stash(
        post     => $post,
        template => 'post/view.tt',
    );
}

# Создание поста (GET/POST)
sub create : Path('/post/create') : Args(0) {
    my ($self, $c) = @_;

    # Проверка аутентификации
    $c->detach('/user/require_login') unless $c->user_exists;

    if ($c->request->method eq 'POST') {
        my $title   = $c->request->params->{title}   || '';
        my $content = $c->request->params->{content} || '';
        my $media   = $c->request->params->{media_url} || '';

        my $post = $c->model('DB::Post')->create({
            user_id    => $c->user->id,
            title      => $title,
            content    => $content,
            media_url  => $media,
            created_at => DateTime->now,
        });
        $c->response->redirect($c->uri_for('/post/view', $post->id));
        return;
    }

    $c->stash(template => 'post/create.tt');
}

# Редактирование поста
sub edit : Path('/post/edit') : Args(1) {
    my ($self, $c, $post_id) = @_;
    my $post = $c->model('DB::Post')->find($post_id);
    unless ($post) {
        $c->stash->{error_msg} = "Пост не найден";
        $c->response->redirect($c->uri_for('/'));
        return;
    }

    # Проверка: автор ли текущий пользователь
    if (!$c->user_exists || $post->user_id != $c->user->id) {
        $c->stash->{error_msg} = "Нет прав для редактирования";
        $c->response->redirect($c->uri_for('/'));
        return;
    }

    if ($c->request->method eq 'POST') {
        $post->update({
            title      => $c->request->params->{title} || $post->title,
            content    => $c->request->params->{content} || $post->content,
            media_url  => $c->request->params->{media_url} || $post->media_url,
            updated_at => DateTime->now,
        });
        $c->response->redirect($c->uri_for('/post/view', $post_id));
        return;
    }

    $c->stash(
        post     => $post,
        template => 'post/edit.tt',
    );
}

# Удаление поста
sub delete : Path('/post/delete') : Args(1) {
    my ($self, $c, $post_id) = @_;
    my $post = $c->model('DB::Post')->find($post_id);
    if ($post && $c->user_exists && $post->user_id == $c->user->id) {
        $post->delete;
    }
    $c->response->redirect($c->uri_for('/'));
}

# AJAX-запрос для обновления ленты (пример)
sub ajax_feed : Path('/post/ajax_feed') : Args(0) {
    my ($self, $c) = @_;
    $c->stash->{current_view} = 'JSON';

    # Упрощённая выборка последних постов
    my @posts = $c->model('DB::Post')->search(
        {},
        { order_by => { -desc => 'created_at' }, rows => 10 }
    );

    my @data;
    foreach my $p (@posts) {
        push @data, {
            id       => $p->id,
            title    => $p->title,
            content  => $p->content,
            user_id  => $p->user_id,
            username => $p->user->username,
        };
    }

    $c->stash->{json_data} = \@data;
}

__PACKAGE__->meta->make_immutable;
1;
