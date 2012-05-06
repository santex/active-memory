package Acme::MetaSyntactic::pop2;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::pop2 - The pop2 theme

=head1 DESCRIPTION

This theme list all the POP2 commands, responses and states,
as listed in RFC 937.

See L<http://www.ietf.org/rfc/rfc937.txt> for details regarding
the POP2 protocol.

The history of the POP2 RFC is as follows: RFC 937 obsoletes RFC 918.
This is a much shorter history than POP3's.

=head1 CONTRIBUTOR

Philippe "BooK" Bruhat.

Introduced in version 0.68, published on April 3, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
HELO FOLD READ RETR ACKS ACKD NACK QUIT
OK Error
CALL NMBR SIZE XFER EXIT 
LSTN AUTH MBOX ITEM NEXT DONE
