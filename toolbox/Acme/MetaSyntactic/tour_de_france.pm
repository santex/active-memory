package Acme::MetaSyntactic::tour_de_france;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );

=head1 NAME

Acme::MetaSyntactic::tour_de_france - Tour de France winners

=head1 DESCRIPTION

This theme has the winners of the Tour de France, the famous annual
cycling road race through France. The Tour was first held in 1903.

The winners from 1903 onwards are:

=cut

{
    my %seen;
    __PACKAGE__->init(
        {   names => join ' ',
            grep    { !$seen{$_}++ }
                map { Acme::MetaSyntactic::RemoteList::tr_nonword($_) }
                map { Acme::MetaSyntactic::RemoteList::tr_accent($_) }
                map { /^\s+\d+\s+(.*?)\s+\w+$/ ? $1 : () }
                split /\n/ => <<'=cut'} );

=pod

    2006   Floyd Landis          USA
    2005   Lance Armstrong       USA
    2004   Lance Armstrong       USA
    2003   Lance Armstrong       USA
    2002   Lance Armstrong       USA
    2001   Lance Armstrong       USA
    2000   Lance Armstrong       USA
    1999   Lance Armstrong       USA
    1998   Marco Pantani         ITA
    1997   Jan Ullrich           GER
    1996   Bjarne Riis           DEN
    1995   Miguel Indurain       ESP
    1994   Miguel Indurain       ESP
    1993   Miguel Indurain       ESP
    1992   Miguel Indurain       ESP
    1991   Miguel Indurain       ESP
    1990   Greg Lemond           USA
    1989   Greg Lemond           USA
    1988   Pedro Delgado         ESP
    1987   Stephen Roche         IRL
    1986   Greg Lemond           USA
    1985   Bernard Hinault       FRA
    1984   Laurent Fignon        FRA
    1983   Laurent Fignon        FRA
    1982   Bernard Hinault       FRA
    1981   Bernard Hinault       FRA
    1980   Joop Zoetemelk        NED
    1979   Bernard Hinault       FRA
    1978   Bernard Hinault       FRA
    1977   Bernard Thévenet      FRA
    1976   Lucien Van Impe       BEL
    1975   Bernard Thévenet      FRA
    1974   Eddy Merckx           BEL
    1973   Luis Ocana            ESP
    1972   Eddy Merckx           BEL
    1971   Eddy Merckx           BEL
    1970   Eddy Merckx           BEL
    1969   Eddy Merckx           BEL
    1968   Jan Janssen           NED
    1967   Roger Pingeon         FRA
    1966   Lucien Aimar          FRA
    1965   Felice Gimondi        ITA
    1964   Jacques Anquetil      FRA
    1963   Jacques Anquetil      FRA
    1962   Jacques Anquetil      FRA
    1961   Jacques Anquetil      FRA
    1960   Gastone Nencini       ITA
    1959   Federico Bahamontès   ESP
    1958   Charly Gaul           LUX
    1957   Jacques Anquetil      FRA
    1956   Roger Walkowiak       FRA
    1955   Louison Bobet         FRA
    1954   Louison Bobet         FRA
    1953   Louison Bobet         FRA
    1952   Fausto Coppi          ITA
    1951   Hugo Koblet           SUI
    1950   Ferdi Kubler          SUI
    1949   Fausto Coppi          ITA
    1948   Gino Bartali          ITA
    1947   Jean Robic            FRA
    1939   Sylvère Maes          BEL
    1938   Gino Bartali          ITA
    1937   Roger Labépie         FRA
    1936   Sylvere Maes          BEL
    1935   Romain Maes           BEL
    1934   Antonin Magne         FRA
    1933   Georges Speicher      FRA
    1932   André Leducq          FRA
    1931   Antonin Magne         FRA
    1930   André Leducq          FRA
    1929   Maurice Dewaele       BEL
    1928   Nicolas Frantz        LUX
    1927   Nicolas Frantz        LUX
    1926   Lucien Buysse         BEL
    1925   Ottavio Bottecchia    ITA
    1924   Ottavio Bottecchia    ITA
    1923   Henri Pélissier       FRA
    1922   Firmin Lambot         BEL
    1921   Léon Scieur           BEL
    1920   Philippe Thijs        BEL
    1919   Firmin Lambot         BEL
    1914   Philippe Thijs        BEL
    1913   Philippe Thijs        BEL
    1912   Odile Defraye         BEL
    1911   Gustavo Garrigou      FRA
    1910   Octave Lapize         FRA
    1909   François Faber        LUX
    1908   Lucien Petit-Breton   FRA
    1907   Lucien Petit-Breton   FRA
    1906   René Pottier          FRA
    1905   Louis Trousselier     FRA
    1904   Henri Cornet          FRA
    1903   Maurice Garin         FRA

=cut

}

1;

__END__

=pod

The official website for I<Le tour de France> is L<http://www.letour.fr/>.

=head1 CONTRIBUTOR

Abigail

Introduced in version 0.84, published on July 24, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

