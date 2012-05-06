package Acme::MetaSyntactic::debian;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::debian - The debian theme

=head1 DESCRIPTION

This theme lists all the Debian codenames. So far they have been
characters taken from the movie I<Toy Story> by Pixar.

Source: L<http://www.debian.org/doc/manuals/reference/ch-system.en.html#s-sourceforcodenames>.

=head1 CONTRIBUTOR

Philippe "BooK" Bruhat.

Introduced in version 0.20, published on May 2, 2005.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
buzz rex bo
hamm slink potato
woody sarge etch
sid
