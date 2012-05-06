use Test::More;
use t::NoLang;
use strict;
use Acme::MetaSyntactic;

END {
    my @langs = Acme::MetaSyntactic::digits->languages();

    plan tests => 4 * ( @langs + 2 ) + 7;

    is_deeply(
        [ sort @langs ],
        [qw( en fr it x-chiendent x-null yi )],
        "All languages (class)"
    );

    @langs = Acme::MetaSyntactic::digits->new()->languages();
    is_deeply(
        [ sort @langs ],
        [qw( en fr it x-chiendent x-null yi )],
        "All languages (instance)"
    );

    for my $args ( [], map { [ lang => $_ ] } @langs, 'zz' ) {
        my $meta = Acme::MetaSyntactic::digits->new(@$args);
        my $lang = $args->[1] || 'en';
        my ( $one, $four ) = ( 1, 4 );
        $lang = 'en' if $lang eq 'zz';    # check fallback to default
        ( $one, $four ) = ( 0, 0 ) if $lang eq 'x-null';    # empty list
        my @digits = $meta->name;
        is( $meta->lang, $lang, "lang() is $lang" );
        is( @digits, $one, "Single item ($one $lang)" );
        @digits = $meta->name(4);
        is( @digits, $four, "Four items ($four $lang)" );

        @digits = sort $meta->name(0);
        no warnings;
        my @all = sort @{ $Acme::MetaSyntactic::digits::Locale{$lang} };
        is_deeply( \@digits, \@all, "All items ($lang)" );
    }

    # tests for the various language schemes
    # by order of preference LANGUAGE > LANG > Win32::Locale
    my $meta;

    {
        # we don't need no Windows to test this
        local $INC{"Win32/Locale.pm"} = 1;
        local $^W = 0;
        *Win32::Locale::get_language = sub { 'it' };

        $^O   = 'MSWin32';
        $meta = Acme::MetaSyntactic::digits->new;
    }

    is_deeply( [ sort $meta->name(0) ],
        [ sort @{ $Acme::MetaSyntactic::digits::Locale{it} } ], "MSWin32" );

    $ENV{LANG} = 'fr';
    $meta = Acme::MetaSyntactic::digits->new;
    is_deeply( [ sort $meta->name(0) ],
        [ sort @{ $Acme::MetaSyntactic::digits::Locale{fr} } ], "LANG fr" );

    $ENV{LANGUAGE} = 'yi';
    $meta = Acme::MetaSyntactic::digits->new;
    is_deeply( [ sort $meta->name(0) ],
        [ sort @{ $Acme::MetaSyntactic::digits::Locale{yi} } ], "LANGUAGE yi" );

    delete @ENV{qw( LANG LANGUAGE ) };

    $ENV{LANG} = 'x-chiendent';
    $meta = Acme::MetaSyntactic::digits->new;
    is_deeply( [ sort $meta->name(0) ],
        [ sort @{ $Acme::MetaSyntactic::digits::Locale{'x-chiendent'} } ],
        "LANG x-chiendent" );

    $ENV{LANGUAGE} = 'x-chiendent';
    $meta = Acme::MetaSyntactic::digits->new;
    is_deeply( [ sort $meta->name(0) ],
        [ sort @{ $Acme::MetaSyntactic::digits::Locale{'x-chiendent'} } ],
        "LANGUAGE x-chiendent" );

}

package Acme::MetaSyntactic::digits;
use Acme::MetaSyntactic::Locale;
our @ISA = ('Acme::MetaSyntactic::Locale');
__PACKAGE__->init();
1;

__DATA__
# default
en
# names en
zero one two three four five six seven eight nine
# names fr
zero un deux trois quatre cinq six sept huit neuf
# names it
zero uno due tre quattro cinque sei sette otto nove
# names yi
nul eyn tsvey dray fir finf zeks zibn akht nayn
# names x-null
# names x-chiendent
nain deuil toit carte sein scie sexe huitre veuf disque
