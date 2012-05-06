package Acme::MetaSyntactic::counting_rhyme;
use strict;
use Acme::MetaSyntactic::Locale;
our @ISA = qw( Acme::MetaSyntactic::Locale );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::counting_rhyme - The counting rhyme theme

=head1 DESCRIPTION

Based on popular children counting rhymes, mostly used to decide roles
in games (who'll be the wolf?)

=head1 FULL VERSIONS

=head2 English

    Eeny, meeny, miny, moe
    Catch a tiger by the toe
    If he hollers let him go,
    Eeny, meeny, miny, moe.

=head2 French

    Am, stram, gram,
    Pique et pique et colégram
    Bourre, bourre et ratatam
    Am, stram, gram.

=head2 Dutch

    Iene, miene, mutte,
    tien pond grutten,
    tien pond kaas,
    Iene, miene, mutte,
    is de baas.

=head2 German

    Eene, Meene, Muh, und raus bist du
    Eene, Meene, Maus, und du bist raus
    Eene, Meene, Meck, und du bist weg
    Weg bist du noch lange nicht,
    sag mir erst wie alt du bist.

=head1 CONTRIBUTORS

Xavier Caron proposed the idea in French, and Paul-Christophe Varoutas
provided the English version. Abigail provided the Dutch version.
Yanick and Anja Champoux provided the German theme.

Introduced in version 0.30, published on July 11, 2005.

Patched a typo in version 0.39, published on September 12, 2005.

Updated with the Dutch theme in version 0.47, published on November 7, 2005.

Updated with the German theme in version 0.68, published on April 3, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::Locale>.

=cut

__DATA__
# default
en
# names en 
eenie meeny miny moe
catch a tiger by the toe 
if he hollers let him go 
# names fr
am stram gram
pique et colegram
bourre ratatam
# names nl 
iene miene mutte
tien pond grutten
kaas is de baas
# names de
eene meene muh und raus bist du 
maus meck weg 
noch lange nicht 
sag mir erst wie alt
