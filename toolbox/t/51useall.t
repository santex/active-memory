use Test::More;
use Acme::MetaSyntactic;

plan tests => scalar Acme::MetaSyntactic->themes;

for( Acme::MetaSyntactic->themes ) {
    `$^X -Mblib -MAcme::MetaSyntactic::$_ -e1`;
    is( $?, 0, "$_" );
}

