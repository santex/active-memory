package Acme::MetaSyntactic::smtp;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::smtp - The (E)SMTP commands theme

=head1 DESCRIPTION

Commands of the SMTP and ESMTP protocols, as described in
RFC 821 (L<http://www.ietf.org/rfc/rfc821.txt>) and
RFC 2821 (L<http://www.ietf.org/rfc/rfc2821.txt>).

=head1 CONTRIBUTOR

Abigail

Introduced in version 0.66, published on March 20, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
HELO EHELO MAIL RCPT DATA SEND SOML SAML RSET VRFY EXPN HELP NOOP QUIT TURN
