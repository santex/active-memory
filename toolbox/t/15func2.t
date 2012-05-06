use Test::More;
use strict;
use Acme::MetaSyntactic::batman;

plan tests => 2;

# the default list
no warnings;
my @names = metabatman();
my %seen = map { $_ => 1 } @Acme::MetaSyntactic::batman::List;
ok( exists $seen{$names[0]}, "metabatman" );

is_deeply(
    [ sort grep { /^meta\w+$/ } keys %:: ],
    [qw( metabatman )],
    "Default exported function"
);

