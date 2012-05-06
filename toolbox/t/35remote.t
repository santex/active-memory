use Test::More tests => 19;
use strict;

{ eval "require LWP::UserAgent;"; }
my $has_lwp = !$@;

# test the helper subs
is( Acme::MetaSyntactic::RemoteList::tr_accent('a é ö ì À + ='),
    'a e o i A + =', 'tr_accent' );
is( Acme::MetaSyntactic::RemoteList::tr_nonword('a;Aö"1À +='),
    'a_A__1____', 'tr_nonword' );

# theme without a remote list
use Acme::MetaSyntactic::shadok ();
ok( ! Acme::MetaSyntactic::shadok->has_remotelist(),
    "No remote list for shadok" );
is( Acme::MetaSyntactic::shadok->source(), undef, 'shadok source() empty' );

my $shadok = Acme::MetaSyntactic::shadok->new();
ok( ! $shadok->has_remotelist(), 'No remote list for shadok object' );
is( $shadok->source(), undef, 'shadok object source() empty' );

# try to get the list anyway
SKIP: {
    skip "LWP::UserAgent required to test remote_list()", 1 if !$has_lwp;
    is( $shadok->remote_list(), undef, 'No remote list for shadok object' );
}

# default version of extract
is( $shadok->extract( 'zlonk aieee' ), 'zlonk aieee', "Default extract()" );


# theme with a remote list
use Acme::MetaSyntactic::dilbert ();
ok( Acme::MetaSyntactic::dilbert->has_remotelist(),
    'dilbert has a remote list' );
is( Acme::MetaSyntactic::dilbert->source(),
    'http://www.triviaasylum.com/dilbert/diltriv.html',
    'dilbert source()'
);

my $dilbert = Acme::MetaSyntactic::dilbert->new();
ok( $dilbert->has_remotelist(), 'dilbert object has a remote list' );
is( $dilbert->source(), 'http://www.triviaasylum.com/dilbert/diltriv.html',
    'dilbert source()' );

# these tests must be run after the test module has been loaded
END {
    ok( Acme::MetaSyntactic::dummy->has_remotelist,
        'dummy has a remote list' );

    my $dummy = Acme::MetaSyntactic::dummy->new();
    ok( $dummy->has_remotelist, 'dummy object has a remote list' );

    my $content = << 'EOC';
list
* meu
* zo
* bu
* gä
EOC
    is_deeply( [ Acme::MetaSyntactic::dummy->extract($content) ],
        [qw( meu zo bu ga )], 'extract() class method' );
    # this is now a generated method
    is_deeply( [ $dummy->extract($content) ],
        [qw( meu zo bu ga )], 'extract() object method' );

    SKIP: {
        skip "LWP::UserAgent required to test remote_list()", 3 if !$has_lwp;
        is_deeply(
            [ sort $dummy->name(0) ],
            [ sort $dummy->remote_list() ],
            'Same "remote" list'
        );

        is_deeply(
            [ sort $dummy->name(0) ],
            [ sort Acme::MetaSyntactic::dummy->remote_list() ],
            'Same "remote" list'
        );

        # test failing network
        $Acme::MetaSyntactic::dummy::Remote{source} = 'fail';
        is_deeply( [ $dummy->remote_list() ],
            [], 'Empty list when network fails' );
    }

}

# a test package
package Acme::MetaSyntactic::dummy;
use strict;

use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
use Cwd;

# data regarding the updates
our %Remote = (
    source  => 'file://' . cwd() . '/t/remote',
    extract => sub {
        my $content = shift;
        my @items       =
            map { Acme::MetaSyntactic::RemoteList::tr_nonword($_) }
            map { Acme::MetaSyntactic::RemoteList::tr_accent($_) }
            $content =~ /^\* (.*?)\s*$/gm;
        return @items;
    },
);

__PACKAGE__->init();
1;

__DATA__
# names
bonk clank_est eee_yow swoosh urkk wham_eth z_zwap
