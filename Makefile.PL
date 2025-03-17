# Makefile.PL
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'MiniNewsNet',
    VERSION_FROM => 'lib/MiniNewsNet.pm',
    PREREQ_PM    => {
        'Catalyst'                        => 0,
        'Catalyst::Devel'                 => 0,
        'DBIx::Class'                     => 0,
        'Catalyst::Plugin::Authentication'=> 0,
        'Catalyst::Plugin::Session'       => 0,
        'Catalyst::Plugin::Session::State::Cookie' => 0,
        'Catalyst::Plugin::Session::Store::File'   => 0,
        'Template'                        => 0,
        'JSON'                            => 0,
        'Test::WWW::Mechanize::Catalyst'  => 0,
        'HTML::FormFu'                    => 0,
        'DateTime'                        => 0,
        'Email::Sender'                   => 0,
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.46 ?
      ('LICENSE'=> 'perl') : ()),
);
