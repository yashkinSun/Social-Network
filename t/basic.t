use strict;
use warnings;
use Test::More tests => 4;
use Test::WWW::Mechanize::Catalyst 'MiniNewsNet';

my $mech = Test::WWW::Mechanize::Catalyst->new;

# Проверяем главную страницу
$mech->get_ok('/','Главная открывается');
$mech->content_contains('Лента постов','Контент найден');

# Проверяем страницу регистрации
$mech->get_ok('/user/register','Регистрация открывается');
$mech->content_contains('Регистрация','Слово "Регистрация" на странице');
