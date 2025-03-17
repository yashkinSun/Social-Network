# lib/MiniNewsNet/Schema/Result/Comment.pm
package MiniNewsNet::Schema::Result::Comment;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('comments');
__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    'post_id' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'user_id' => {
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
    'parent_id' => {
        data_type   => 'integer',
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('post' => 'MiniNewsNet::Schema::Result::Post', 'post_id');
__PACKAGE__->belongs_to('user' => 'MiniNewsNet::Schema::Result::User', 'user_id');

1;
