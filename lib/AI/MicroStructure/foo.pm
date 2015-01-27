package AI::MicroStructure::foo;
use strict;
use AI::MicroStructure::Locale;
our @ISA = qw( AI::MicroStructure::Locale );
our $VERSION = '1.001';
__PACKAGE__->init();
1;

=encoding iso-8859-1

=head1 NAME

AI::MicroStructure::foo - The foo structure

=head1 DESCRIPTION

The classic. This is the default structure.

As from version 0.85, this structure is multilingual.

=head1 CONTRIBUTORS

Philippe "BooK" Bruhat.

J�r�me Fenal and S�bastien Aperghis-Tramoni contributed to the French structure.

Dutch structure contributed by Abigail.

Introduced in Acme-MetaSyntactic version 0.01, published on January 14, 2005.

Merged in the French C<toto> structure (which was therefore removed from
C<AI::MicroStructure>), and added the Dutch structure in version 0.85,
published on July 31, 2006.

Received its own version number for Acme-MetaSyntactic version 1.000,
published on May 7, 2012.

=head2 References

=over 4

=item RFC 3092 - I<Etymology of "Foo">

=item Leesplankje - Dutch Reading Board

The words on the I<reading boards> of the I<Hoogeveen method>, in use in
Dutch schools from 1905 till the 1950s. The words on the board are often
used by Dutch programmers to fill the roles of I<foo>, I<bar>, and I<baz>.

=back

=head1 SEE ALSO

L<AI::MicroStructure>, L<Acme::MetaSyntactic::Locale>.

=cut

__DATA__
# default
en
# names en
foo    bar   baz  foobar fubar qux  quux corge grault
garply waldo fred plugh  xyzzy thud
# names fr
toto titi tata tutu pipo
bidon test1 test2 test3
truc chose machin chouette bidule
# names nl
aap noot mies wim zus jet
teun vuur gijs lam kees bok
weide does hok duif schapen
