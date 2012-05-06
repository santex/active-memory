package Acme::MetaSyntactic::phonetic;
use strict;
use Acme::MetaSyntactic::Locale;
our @ISA = qw( Acme::MetaSyntactic::Locale );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::phonetic - The phonetic theme

=head1 DESCRIPTION

Several phonetic alphabets.

Most of them come from this list:
L<http://montgomery.cas.muohio.edu/meyersde/PhoneticAlphabets.htm>

=head1 CONTRIBUTOR

Michel Rodriguez provided the first list (NATO official phonetic alphabet).

Added Swahili and English on request of David Landgren, thus closing
RT ticket #14276.
While I was at it, I also added French, German and Italian.

Introduced in version 0.08, published on February 7, 2005.

Updated to handle multilingual phonetics in version 0.38,
published on September 5, 2005.

Updated (German fix by Gisbert W. Selke) in version 0.74, published on
May 15, 2006.

Updated with the Dutch list by Abigail in version 0.91, published on
September 11, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::Locale>.

=cut

__DATA__
# default
x-nato
# names x-nato
alpha   bravo charlie  delta echo foxtrot golf  hotel  india juliet  kilo
lima    mike  november oscar papa quebec  romeo sierra tango uniform victor
whiskey xray  yankee   zulu
# names en
Able Baker Charlie Dog   Edward Fox   George How  Item  Jiga   King    Love
Mike Nan   Oboe   Peter  Queen  Roger Sugar  Tape Uncle Victor William X_Ray
Yoke Zebra
# names sw
Ali    Banda  Chakechake Dodoma Entebe Fumba Gogo Homa Imba   Jambo KenyaLala
Mama   Nakuru Ona        Punda  Kyela  Rangi Simu Tatu Uganda Vitu  Wali
Eksrei Yai    Zanzibar
# names fr
Anatole Berthe Celestin Desire  Eugene  Emile  Francois Gaston Henri Irma
Joseph  Kleber Louis    Marcel  Nicolas Oscar  Pierre  Quintal Raoul Suzanne
Therese Ursule Victor   William Xavier  Yvonne Zoe
# names de
Anton     Bertha Caesar  Dora   Emil    Friedrich Gustav    Heinrich Ida
Jakob     Konrad Ludwig  Martha Nordpol Otto      Paula     Quelle   Richard
Siegfried Schule Theodor Ulrich Viktor  Wilhelm   Xanthippe Ypsilon  Zeppelin
# names it
Ancona Bologna Como    Domodossola Empoli Firenze  Genova Hacca        Imola
Jolly  Kappa   Livorno Milano      Napoli Otranto  Pisa   Quartomiglio Roma
Savona Torino  Udine   Venezia     Wagner Xilofono York   Zara
# names nl
Anna    Anton    Bernard Cornelis Dirk     Eduard   Ferdinand Gerard
Hendrik Izaak    Jan     Karel    Lodewijk Marie    Nico      Otto
Pieter  Quotient Rudolf  Simon    Teunis   Theodoor Utrecht   Victor
Willem  Xantippe Ypsilon IJsbrand Zaandam

