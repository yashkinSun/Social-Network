# lib/MiniNewsNet/Schema/Result/Friend.pm
package MiniNewsNet::Schema::Result::Friend;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('friends');
__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    'user_id' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'friend_id' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'status' => {
        data_type   => 'text',
        is_nullable => 0,
        default_value => 'pending',
    },
    'created_at' => {
        data_type     => 'datetime',
        set_on_create => 1,
        is_nullable   => 1,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('user'     => 'MiniNewsNet::Schema::Result::User', 'user_id');
__PACKAGE__->belongs_to('friend'   => 'MiniNewsNet::Schema::Result::User', 'friend_id');

1;
