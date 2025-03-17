package MiniNewsNet::Schema;
use strict;
use warnings;
use base 'DBIx::Class::Schema';

# Загрузка Result-классов
__PACKAGE__->load_namespaces();

1;
