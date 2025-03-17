package MiniNewsNet::Model::DB;
use strict;
use warnings;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
  schema_class => 'MiniNewsNet::Schema',
  connect_info => {
    dsn => 'dbi:SQLite:db/mini_news_net.db',
    quote_names => 1,
    sqlite_unicode => 1,
  },
);

1;
