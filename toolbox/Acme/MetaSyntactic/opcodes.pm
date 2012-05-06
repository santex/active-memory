package Acme::MetaSyntactic::opcodes;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );

# get the list from the current perl
use Opcode qw( opset_to_ops full_opset );
__PACKAGE__->init(
    { names => join( " ", map { uc "OP_$_" } opset_to_ops(full_opset) ) } );

1;

__END__

=head1 NAME

Acme::MetaSyntactic::opcodes - The Perl opcodes theme

=head1 DESCRIPTION

The names of the Perl opcodes. They are given by the
C<Opcode> module.

=head1 CONTRIBUTOR

Abigail

Introduced in version 0.53, published on December 19, 2005.

=head1 DEDICATION

This module is dedicated to Perl, which turned 18 years old the day
before this release was published.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

