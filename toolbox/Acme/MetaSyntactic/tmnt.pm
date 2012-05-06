package Acme::MetaSyntactic::tmnt;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
__PACKAGE__->init();

our %Remote = (
    source  => ['http://www.ninjaturtles.com/html/profiles.htm',
                'http://www.ninjaturtles.com/html/profil02.htm'],
    extract => sub {
        return
            map { s/\W+/_/g; $_ }
            map { split /\s+&amp;\s+/ }
            $_ [0] =~ m{<a href="/html/profile?\d+.htm">([^<]+)</a>}g
    }
);

1;

=head1 NAME

Acme::MetaSyntactic::tmnt - The Teenage Mutant Ninja Turtles theme

=head1 DESCRIPTION

The Teenage Mutant Ninja Turtles are a comic series created in 1984 
by Kevin Eastman and Peter Laird. They have been published as comic
books, television series, and movies.

The official web of Mirage Studios has a lot of information about
the TMNT, see L<http://www.ninjaturtles.com/>.

=head1 CONTRIBUTOR

Abigail

Introduced in version 0.58, published on January 23, 2006.

Made updatable in version 0.59, published on January 30, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
Donatello Leonardo Michelangelo Raphael Master_Splinter April_O_Neil
Casey_Jones The_Shredder Hun Foot_Soldier Krang Bebop Rocksteady
Rat_King Leatherhead Slash Mondo_Gecko Ray_Fillet Wingnut Screwloose
Merdude Tattoo Wyrm Dreadmon Jagwar
