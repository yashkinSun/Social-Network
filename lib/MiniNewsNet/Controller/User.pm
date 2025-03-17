package MiniNewsNet::Controller::User;
use Moose;
use namespace::autoclean;
use Digest::SHA qw(sha1_hex);
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

sub register : Path('/user/register') : Args(0) {
    my ($self, $c) = @_;

    if ($c->request->method eq 'POST') {
        my $username = $c->request->params->{username} || '';
        my $email    = $c->request->params->{email}    || '';
        my $password = $c->request->params->{password} || '';

        # Минимальная проверка
        if ($username && $email && $password) {
            my $check_user = $c->model('DB::User')->find({username => $username});
            if ($check_user) {
                $c->stash->{error_msg} = "Имя пользователя уже занято";
            } else {
                my $user = $c->model('DB::User')->create({
                    username   => $username,
                    email      => $email,
                    password   => sha1_hex($password),
                    created_at => DateTime->now,
                });
                $c->stash->{message} = "Регистрация успешна. Теперь вы можете войти.";
                $c->response->redirect($c->uri_for('/user/login'));
                return;
            }
        } else {
            $c->stash->{error_msg} = "Заполните все поля";
        }
    }

    $c->stash(template => 'user/register.tt');
}

sub login : Path('/user/login') : Args(0) {
    my ($self, $c) = @_;

    if ($c->request->method eq 'POST') {
        my $username = $c->request->params->{username} || '';
        my $password = $c->request->params->{password} || '';

        if ($username && $password) {
            if ($c->authenticate({ username => $username, password => sha1_hex($password) })) {
                $c->response->redirect($c->uri_for('/'));
                return;
            } else {
                $c->stash->{error_msg} = "Неверные имя пользователя или пароль";
            }
        } else {
            $c->stash->{error_msg} = "Введите имя пользователя и пароль";
        }
    }

    $c->stash(template => 'user/login.tt');
}

sub logout : Path('/user/logout') : Args(0) {
    my ($self, $c) = @_;
    $c->logout if $c->user_exists;
    $c->response->redirect($c->uri_for('/'));
}

# Пример "требования" логина перед доступом к маршрутам
sub require_login :Private {
    my ($self, $c) = @_;
    unless ($c->user_exists) {
        $c->stash->{error_msg} = "Требуется авторизация";
        $c->response->redirect($c->uri_for('/user/login'));
        $c->detach;
    }
    return 1;
}

# Редактирование профиля
sub edit : Path('/user/edit') : Args(0) {
    my ($self, $c) = @_;
    $c->detach('/user/require_login') unless $c->user_exists;

    my $user = $c->user->obj;
    if ($c->request->method eq 'POST') {
        my $bio   = $c->request->params->{bio}   || '';
        my $email = $c->request->params->{email} || $user->email;
        # Пример загрузки аватара — для упрощения не реализуем полноценно
        # ...

        $user->update({
            bio        => $bio,
            email      => $email,
            updated_at => DateTime->now,
        });
        $c->stash->{message} = "Профиль обновлён";
    }

    $c->stash(
        user     => $user,
        template => 'user/edit.tt',
    );
}

# Публичный профиль
sub profile : Path('/user/profile') : Args(1) {
    my ($self, $c, $username) = @_;
    my $user = $c->model('DB::User')->find({ username => $username });
    unless ($user) {
        $c->stash->{error_msg} = "Пользователь не найден";
        $c->response->redirect($c->uri_for('/'));
        return;
    }

    my $posts = $user->posts->search({}, { order_by => { -desc => 'created_at' } });
    $c->stash(
        viewed_user => $user,
        posts       => $posts,
        template    => 'user/profile.tt',
    );
}

__PACKAGE__->meta->make_immutable;
1;
