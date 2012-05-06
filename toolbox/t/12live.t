use Test::More tests => 3;
use Acme::MetaSyntactic;

my $meta = Acme::MetaSyntactic->new( 'coverhack' );
eval { my $name = $meta->name; };
like( $@, qr!^Metasyntactic list coverhack does not exist!, "So there!" );

$meta = Acme::MetaSyntactic->new();
eval { $meta->name( digits => 2 ); };
like( $@, qr!^Metasyntactic list digits does not exist!, "AMS::digits not there yet" );

push @INC, 't';
eval { $meta->name( digits => 2 ); };
is( $@, '', 'AMS::digits in @INC now' );

