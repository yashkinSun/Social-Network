package MiniNewsNet;
use Moose;
use namespace::autoclean;

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

__PACKAGE__->config(
    name => 'MiniNewsNet',

    'Plugin::Authentication' => {
        default => {
            class             => 'SimpleDB',
            user_model        => 'DB::User',
            password_type     => 'hashed',
            password_hash_type=> 'SHA-1',
        },
    },
);

__PACKAGE__->setup();

1;

