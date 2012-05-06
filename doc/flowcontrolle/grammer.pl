
#!/usr/bin/perl -w
package AI::MICRO::ToolFlow;
use strict;
$|++;
use strict;
use lib '../lib';
	my $VERSION= 0.02;

BEGIN {
    
    @EXPORT_OK= qw( );
    
    require Exporter;
    *import= \&Exporter::import;
    if(  eval { require GraphViz::Parse::RecDescent; }  ) {
		
			use vars qw( $VERSION @EXPORT_OK $db);

my $recipegrammar =
q{
        Object:
                IngredientQualifier(s) Ingredient
              | ReferenceQualifier(s) Ingredient
              | Reference

        Clause:
                SubordinateClause
              | CoordinateClause

        SubordinateClause:
                'until' State
              | 'while' State
              | 'for' Time

        CoordinateClause:
                /and( then)?/ Step
              | /or/ Step

        State:
                Object Verb Adjective
              | Adjective

        Time:
                Number TimeUnit

        TimeUnit:
                /hours?/
                /minutes?/
                /seconds?/

        QuantityUnit:
                /lbs?/


        Object:
                ReferenceQualifier Ingredient
              | Reference

        Reference:
                'they'
              | 'it'
              | 'them'

        Ingredient:
                'potatoes'
              | 'lard'
              | 'olive oil'
              | 'sugar'
              | 'bacon fat'
              | 'butter'
              | 'salt'
              | 'vinegar'

        IngredientQualifier:
                Amount
              | Number
              | 'a'
              | 'some'
              | 'large'
              | 'small'

        Amount: Number QuantityUnit

        ReferenceQualifier:
                'the'
              | 'those'
              | 'each'
              | 'half the'

        Number:
                /[1-9][0-9]*/
              | /one|two|three|four|five|six|seven|eight|nine/
              | 'a dozen'

        Adjective:
                '		    '     
};
        
		
    }
}




my $graph = GraphViz::Parse::RecDescent->new($recipegrammar);
$graph->as_png("recdescent.png");




my $dir = File::Spec->tmpdir();
my $CACHE_VERSION = 1;
my $VERSION = "0.01";
my $backtest = {};
my @tested;
chdir("/tmp/");


# return only matching modules
sub wanted { 
   /longtrend_backtest[_](.*).data$/ && push @tested,[$1,$File::Find::name];

}

my @looking = ["Finance::Quant","Finance::Optical","Finance::Google","Finance::NASDAQ"];
# look in the @IRC dirs that exist
find(\&wanted, grep { -r and -d } @INC);

# nice printout
foreach (@tested) {
  $backtest->{$_->[0]}=[$_->[1]];
#  print "$_->[0]=$_->[1]\n";
}



package AI::MICRO;
use strict;
use vars qw( $VERSION @EXPORT_OK );
BEGIN {
    $VERSION= 0.001_001;
    @EXPORT_OK= qw( LightUp );
    require IO::Handle;
    require Exporter;
    *import= \&Exporter::import;
    if(  eval { require bytes; 1 }  ) {
        bytes->import();
    }
}



sub _smoke { 0 }
sub _stoke { 1 }
sub _bytes { 2 }
sub _puffs { 3 }


sub LightUp
{
    return __PACKAGE__->Ignite( @_ );
}


sub Ignite
{
    my( $class, @fuel )= @_;
    $class ||= __PACKAGE__;
    @fuel= 1
        if  ! @fuel;
    my $bytes= length $fuel[0];
    my $smoke= IO::Handle->new();
    my $stoke= IO::Handle->new();
    pipe( $smoke, $stoke )
        or  _croak( "Can't ignite pipe: $!\n" );
    binmode $smoke;
    binmode $stoke;
    my $me= bless [], $class;
    $me->[_smoke]= $smoke;
    $me->[_stoke]= $stoke;
    $me->[_bytes]= $bytes;
    $me->[_puffs]= 0 + @fuel;
    for my $puff (  @fuel  ) {
        $me->_Stoke( $puff );
    }
    return $me;
}


sub _MagicDragon
{
    return __PACKAGE__ . '::Puff';
}


sub Puff
{
    my( $me )= @_;
    return $me->_MagicDragon()->Inhale( $me );
}


sub _Bogart
{
    my( $me )= @_;
    my( $smoke )= $me->[_smoke];
    my $puff;
    sysread( $smoke, $puff, 1 )
        or  die "Can't toke pipe: $!\n";
    return $puff;
}


sub _Stoke
{
    my( $me, $puff )= @_;
    my $stoke= $me->[_stoke];
    my $bytes= $me->[_bytes];
    if(  $bytes != length $puff  ) {
        _croak( "Tokin ($puff) is ", length($puff), " bytes, not $bytes!" );
    }
    syswrite( $stoke, $puff )
        or  die "Can't stoke pipe: $!\n";
}


sub Extinguish
{
    my( $me )= @_;
    for my $puffs (  $me->[_puffs]  ) {
        while(  $puffs  ) {
            $me->_Bogart();
            --$puffs;
        }
    }
    close $me->[_stoke];
    close $me->[_smoke];
}


sub _croak
{
    require Carp;
    Carp::croak( @_ );
}


package AI::Micro::Puff;

sub Inhale
{
    my( $class, $pipe )= @_;
    my $puff= $pipe->_Bogart();
    return bless [ $pipe, $puff ], $class;
}

sub Sniff
{
    my( $me )= @_;
    return $me->[1];
}

sub Exhale
{
    my( $me )= @_;
    return
        if  ! @$me;
    my( $pipe, $puff )= splice @$me;
    $pipe->_Stoke( $puff );
}

sub DESTROY
{
    my( $me )= @_;
    $me->Exhale();
}


1;
__END__

=head1 NAME

AI::Micro - A mutex and an LRU from crack pipe technology

=head1 SYNOPSIS

=head1 DESCRIPTION


    BEGIN {
        my $bong= LightUp( 0..9 );
        my @pool;

        sub sharesResource
        {
            my $dragon= $bong->Puff();
            # Only 10 threads at once can run this code!
            my $puff= $dragon->Sniff();
            # $puff is 0..9 and is unique among the threads here now
            Do_exclusive_stuff_with( $pool[$puff] );

        }

        sub stowParaphenalia
        {
        }

    }


