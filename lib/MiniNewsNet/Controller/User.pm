package MiniNewsNet::Controller::User;
use utf8;
use Moose;
use namespace::autoclean;
use Digest::SHA qw(sha1_hex);
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

sub register : Path('/user/register') : Args(0) {
    my ($self, $c) = @_;

    if ($c->request->method eq 'POST') {
        my $username = $c->request->param('username') || '';
        my $email    = $c->request->param('email')    || '';
        my $password = $c->request->param('password') || '';

        if ($username && $email && $password) {
            my $exists = $c->model('DB::User')->find({ username => $username });
            if ($exists) {
                $c->stash->{error_msg} = "Имя пользователя уже занято";
            } else {
                $c->model('DB::User')->create({
                    username   => $username,
                    email      => $email,
                    password   => sha1_hex($password),
                    created_at => DateTime->now,
                });
                # Используем flash, чтобы сообщение отобразилось после редиректа
                $c->flash->{message} = "Регистрация успешна. Теперь вы можете войти.";
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
        my $username = $c->request->param('username') || '';
        my $password = $c->request->param('password') || '';

        if ($username && $password) {
            # Хэшируем пароль вручную, так как в конфиге password_type => 'none'
            my $hashed = sha1_hex($password);
            if ($c->authenticate({ username => $username, password => $hashed })) {
                $c->response->redirect($c->uri_for('/'));
                return;
            } else {
                $c->stash->{error_msg} = "Неверные имя пользователя или пароль";
            }
        } else {
            $c->stash->{error_msg} = "Введите имя пользователя и пароль";
        }
    }

    # login.tt должен отображать flash.message, если он есть
    $c->stash(template => 'user/login.tt');
}

sub logout : Path('/user/logout') : Args(0) {
    my ($self, $c) = @_;
    $c->logout if $c->user_exists;
    $c->response->redirect($c->uri_for('/'));
}

sub require_login : Private {
    my ($self, $c) = @_;
    unless ($c->user_exists) {
        $c->stash->{error_msg} = "Требуется авторизация";
        $c->response->redirect($c->uri_for('/user/login'));
        $c->detach;
    }
    return 1;
}

sub edit : Path('/user/edit') : Args(0) {
    my ($self, $c) = @_;
    $c->detach('/user/require_login') unless $c->user_exists;

    my $user = $c->user->obj;
    if ($c->request->method eq 'POST') {
        my $bio   = $c->request->param('bio')   || '';
        my $email = $c->request->param('email') || $user->email;

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
