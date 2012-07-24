use strict;
use Test::More;
use AI::MicroStructure ();
$ENV{AMS_REMOTE} = 1;
@ARGV=("galaxie");
my @themes =
    grep { eval "require $_;"; $_->has_remotelist() }
    map {"AI::MicroStructure::$_"} AI::MicroStructure->themes();

# allow testing only a few themes
# "dilbert viclones" will test ONLY those themes
# "not dilbert tmnt" will test ALL BUT those themes
my %test;
if ( @ARGV && $ARGV[0] eq 'not' ) {
    shift;
    %test = map { $_ => 1 } @themes;
    $test{"AI::MicroStructure::$_"} = 0 for @ARGV;
}
else {
    %test =
          map { $_ => 1 } @ARGV
        ? map {"AI::MicroStructure::$_"} @ARGV
        : @themes;
}

    eval { require LWP::Simple; };
    
    LWP::Simple::get( 'http://www.google.com/intl/en/' );

    # need Test::Differences
    eval { require Test::Differences; };
    my $has_test_diff = $@ eq '';

    for my $theme (@themes) {


            no warnings 'utf8';
            my $current = [ sort $theme->name(0) ];
            my $online  = [ sort $theme->remote_list() ];

                # count
                print( scalar @$current,
                    scalar @$online,
                    "$theme has @{[scalar @$online]} items"
                );

                # details
                if( $has_test_diff ) {
                    Test::Differences::eq_or_diff(
                        $current, $online,
                        "$theme is up to date",
                        { context => 1 }
                    );
                }
                else {
                    is_deeply( $current, $online, "$theme is up to date" );
                }
            }
    

