package Acme::MetaSyntactic::olympics;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );

=head1 NAME

Acme::MetaSyntactic::olympics - Olympic cities theme

=head1 DESCRIPTION

This theme lists the cities who have hosted, or will host, Olympic Games.
Cities for both the Summer and Winter games are listed.

The list comes from L<http://www.olympic.org/>.

The following cities have held, or will hold, the Olympic games.

=cut

our %Remote = (
    source  =>  'http://www.olympic.org/uk/games/index_uk.asp',
    extract =>  sub {
        local $_ = shift;
        s/(Garmisch-)<br>\s+/$1/;
        my @names   =  m{<a \s+ class="(?:summer|winter)" \s+ [^>]+>
                                                 (\w[\w\s\-'.]+\w)\s+\d+</a>}gx;
        push @names => m{<img[^>]+>&nbsp;<a[^>]+>(\w[\w\s\-'.]+\w)\s+\d+</a>}g;

        my %seen;
        map {s/\W+/_/g; $_} grep {!$seen {$_} ++} @names;
    }
);

{
    my %seen;
    my $data = join " " =>
               grep {!$seen {$_} ++}
               map  {s/\W+/_/g; $_}
               map  {/^\s+\d+\s+(.+)$/ ? $1 : ()}
               split /\n/ => <<'=cut';

=pod

    Summer Games
    ============

    2012   London
    2008   Beijing
    2004   Athens
    2000   Sydney
    1996   Atlanta
    1992   Barcelona
    1988   Seoul
    1984   Los Angeles
    1980   Moscow
    1976   Montreal
    1972   Munich
    1968   Mexico City
    1964   Tokyo
    1960   Rome
    1956   Melbourne
    1952   Helsinki
    1948   London
    1936   Berlin
    1932   Los Angeles
    1928   Amsterdam
    1924   Paris
    1920   Antwerp
    1912   Stockholm
    1908   London
    1904   St. Louis
    1900   Paris
    1896   Athens


    Winter Games
    ============

    2010   Vancouver
    2006   Torino
    2002   Salt Lake City
    1998   Nagano
    1994   Lillehammer
    1992   Albertville
    1988   Calgary
    1984   Sarajevo
    1980   Lake Placid
    1976   Innsbruck
    1972   Sapporo
    1968   Grenoble
    1964   Innsbruck
    1960   Squaw Valley
    1956   Cortina d'Ampezzo
    1952   Oslo
    1948   St. Moritz
    1936   Garmisch-Partenkirchen
    1932   Lake Placid
    1928   St. Moritz
    1924   Chamonix

=cut

__PACKAGE__->init( { names => $data } );

}

1;

__END__

=head1 CONTRIBUTOR

Abigail

Introduced in version 0.82, published on July 10, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut
