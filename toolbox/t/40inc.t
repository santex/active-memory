use Test::More tests => 1;
use lib 't';

# look for themes in all @INC
use_ok( 'Acme::MetaSyntactic::digits' );
