use strict;
use warnings;
use Template;
use FindBin;

my $config = {
    INCLUDE_PATH => "$FindBin::Bin/root/templates",
    ENCODING     => 'utf-8',
};

my $tt = Template->new($config) or die Template->error();

my $vars = { posts => [] };
my $template = 'index.tt';

print "Attempting to render template: $template\n";

$tt->process($template, $vars)
    or die "Template Toolkit error: " . $tt->error();
