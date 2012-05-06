use Test::More;
use Acme::MetaSyntactic;
use strict;

my @themes = Acme::MetaSyntactic->themes;

plan tests => @themes * 2;

for my $t (@themes) {
    eval "require Acme::MetaSyntactic::$t";
    is( eval { "Acme::MetaSyntactic::$t"->theme },
        $t, "theme() for Acme::MetaSyntactic::$t" );
    my $a = eval { "Acme::MetaSyntactic::$t"->new };
    is( eval { $a->theme }, $t, "theme() for Acme::MetaSyntactic::$t" );
}
