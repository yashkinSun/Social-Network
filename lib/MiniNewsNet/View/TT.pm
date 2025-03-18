package MiniNewsNet::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    WRAPPER            => 'wrapper.tt',
    render_die         => 1,
    ENCODING           => 'utf-8',

    # явное указание полного пути (для Windows это обязательно):
    INCLUDE_PATH       => [
        'C:/Coding/MiniNewsNet/root/templates'
    ],

    COMPILE_DIR        => 'C:/Coding/MiniNewsNet/tmp/tt_cache',
    COMPILE_EXT        => '.ttc',
);

1;
