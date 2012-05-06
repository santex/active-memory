use Test::More;
use strict;
use Acme::MetaSyntactic 'batman';

plan tests => 4;

my @names = metaname();
my %seen = map { $_ => 1 } @Acme::MetaSyntactic::batman::List;
ok( exists $seen{$names[0]}, "metaname" );

my @bots = qw( purl url sarko bender );
my $meta = Acme::MetaSyntactic->new( 'bots' );

# yep, you can add the theme after creating the instance
Acme::MetaSyntactic->add_theme( bots => [ @bots ] );

@names = metabots();
is( scalar @names, 1, "metabots() returned a single item" );

push @names, metabots(3);
is( scalar @names, 4, "metabots( 3 ) returned three more items" );

%seen = map { $_ => 1 } @names;
is_deeply( \%seen, { map { $_ => 1 } @bots }, "Got the whole list");

