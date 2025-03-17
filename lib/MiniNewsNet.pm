package MiniNewsNet;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Загрузка плагинов Catalyst
use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Session
    Session::State::Cookie
    Session::Store::File
    Authentication
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'MiniNewsNet',
    # Настройки Static::Simple
    static => {
        dirs => [ 'static', 'favicon.ico' ],
        include_path => [
            __PACKAGE__->path_to('root'),
        ],
    },
);

# Инициализация приложения
__PACKAGE__->setup();

1;
