package Acme::MetaSyntactic::oulipo;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::oulipo - The Oulipo theme

=head1 DESCRIPTION

This theme contains the initials of the members of the French literary
group Oulipo, created by Raymond Queneau (RQ) and François Le Lionnais
(FLL) in 1960. These initials are commonly used in place of a member's
full name.

See the official Oulipo web site at L<http://www.oulipo.net/>.

=head1 CONTRIBUTOR

Philippe "BooK" Bruhat (co-creator of the first Oulipo web site, back
in 1995).

Introduced in version 0.28, published on June 27, 2005.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
NA  MB  VB  JB  CB  AB  PB  IC  FC  BC  RC  SC
MD  JD  LE  FF  PF  AG  MG  JJ  AL  FLL HLT JL
HM  MM  IM  OP  GP  RQ  JQ  PR  JR  OS  AMS
