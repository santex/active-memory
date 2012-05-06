use Test::More;
use Acme::MetaSyntactic::any;
use t::NoLang;

# "alter" the shuffle method
{
    no warnings;
    my ( $i, $j ) = ( 0, 0 );
    *List::Util::shuffle = sub { sort @_ };    # item selection
    *Acme::MetaSyntactic::any::shuffle =       # theme selection
        sub (@) { my @t = sort @_; push @t, shift @t for 1 .. $j; $j++; @t };
}

# compute the first 6 installed themes
my $meta   = Acme::MetaSyntactic->new();
my @themes = ( grep { ! /^any$/ } sort $meta->themes() )[ 0 .. 5 ];

# the test list is computed now because of cache issues
my @tests
    = map { [ ( sort $meta->name( $themes[$_] => 0 ) )[ 0 .. $_ + 1 ] ] }
    0 .. 5;

plan tests => scalar @tests;

for my $test (@tests) {
    my @names = metaany( scalar @$test );
    is_deeply( \@names, $test,
        qq{Got "random" names from a "random" theme (@{[shift @themes]})} );
}

