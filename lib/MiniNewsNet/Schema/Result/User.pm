# lib/MiniNewsNet/Schema/Result/User.pm
package MiniNewsNet::Schema::Result::User;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    'username' => {
        data_type   => 'text',
        is_nullable => 0,
    },
    'email' => {
        data_type   => 'text',
        is_nullable => 0,
    },
    'password' => {
        data_type   => 'text',
        is_nullable => 0,
    },
    'avatar' => {
        data_type   => 'text',
        is_nullable => 1,
        default_value => '/static/img/avatar_placeholder.png',
    },
    'bio' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    'created_at' => {
        data_type     => 'datetime',
        set_on_create => 1,
        is_nullable   => 1,
    },
    'updated_at' => {
        data_type   => 'datetime',
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key('id');

# Пример отношений
__PACKAGE__->has_many('posts'      => 'MiniNewsNet::Schema::Result::Post', 'user_id');
__PACKAGE__->has_many('comments'   => 'MiniNewsNet::Schema::Result::Comment', 'user_id');
__PACKAGE__->has_many('likes'      => 'MiniNewsNet::Schema::Result::Like', 'user_id');
__PACKAGE__->has_many('sent_msgs'  => 'MiniNewsNet::Schema::Result::Message', 'sender_id');
__PACKAGE__->has_many('recv_msgs'  => 'MiniNewsNet::Schema::Result::Message', 'receiver_id');
__PACKAGE__->has_many('friends_rel'=> 'MiniNewsNet::Schema::Result::Friend', 'user_id');
__PACKAGE__->has_many('notifs'     => 'MiniNewsNet::Schema::Result::Notification', 'user_id');

1;
