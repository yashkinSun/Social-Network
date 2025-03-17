# lib/MiniNewsNet/Schema/Result/Message.pm
package MiniNewsNet::Schema::Result::Message;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('messages');
__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    'sender_id' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'receiver_id' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'content' => {
        data_type   => 'text',
        is_nullable => 0,
    },
    'created_at' => {
        data_type     => 'datetime',
        set_on_create => 1,
        is_nullable   => 1,
    },
    'read_status' => {
        data_type     => 'integer',
        default_value => 0, # 0 = непрочитано, 1 = прочитано
        is_nullable   => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('sender'   => 'MiniNewsNet::Schema::Result::User', 'sender_id');
__PACKAGE__->belongs_to('receiver' => 'MiniNewsNet::Schema::Result::User', 'receiver_id');

1;
