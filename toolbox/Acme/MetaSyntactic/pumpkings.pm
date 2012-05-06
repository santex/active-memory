package Acme::MetaSyntactic::pumpkings;
use strict;
use Acme::MetaSyntactic::MultiList;
our @ISA = qw( Acme::MetaSyntactic::MultiList );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::pumpkings - The pumpkings theme

=head1 DESCRIPTION

This is the list of the Perl Pumpkings, as listed in perlhist(1).

The names are the pumpkings PAUSE id (except for C<NI-S>, which was
changed to C<NI_S>).

=head1 CONTRIBUTOR

Rafael Garcia-Suarez.

Introduced in version 0.14, published on March 21, 2005.

Turned into a multilist (separate lists for different versions of Perl)
by Abigail in version 0.74, published on May 15, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::MultiList>.

=cut

__DATA__
# default
perl5
# names perl0
lwall
# names perl1
lwall mschwern rclamp
# names perl2
lwall
# names perl3
lwall
# names perl4
lwall
# names perl5
lwall andyd tomc cbail ni_s chips timb micb gsar gbarr
jhi hvds rgarcia nwclark lbrocard

