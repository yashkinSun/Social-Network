# lib/MiniNewsNet/Schema/Result/Post.pm
package MiniNewsNet::Schema::Result::Post;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    'user_id' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'title' => {
        data_type   => 'text',
        is_nullable => 0,
    },
    'content' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    'media_url' => {
        data_type     => 'text',
        is_nullable   => 1,
        default_value => '/static/img/media_placeholder.png',
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
__PACKAGE__->belongs_to('user' => 'MiniNewsNet::Schema::Result::User', 'user_id');
__PACKAGE__->has_many('comments' => 'MiniNewsNet::Schema::Result::Comment', 'post_id');
__PACKAGE__->has_many('likes'    => 'MiniNewsNet::Schema::Result::Like',   'post_id');

1;
