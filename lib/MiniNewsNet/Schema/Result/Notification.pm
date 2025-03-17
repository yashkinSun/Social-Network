# lib/MiniNewsNet::Schema::Result::Notification.pm
package MiniNewsNet::Schema::Result::Notification;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('notifications');
__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    'user_id' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'type' => {
        data_type   => 'text',
        is_nullable => 0,
    },
    'content' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    'link' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    'is_read' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'created_at' => {
        data_type     => 'datetime',
        set_on_create => 1,
        is_nullable   => 1,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user' => 'MiniNewsNet::Schema::Result::User', 'user_id');

1;
