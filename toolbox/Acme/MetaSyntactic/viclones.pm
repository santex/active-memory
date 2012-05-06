package Acme::MetaSyntactic::viclones;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
__PACKAGE__->init();

our %Remote = (
    source  => 'http://www.saki.com.au/mirror/vi/clones.php3',
    extract => sub {
        return
            map { y!- /!__!d; /clone/ ? () : $_ }
            $_[0] =~ /^<dt>\s*([^[\n\(]+?)(?:\s*\([^)]+\))?\s*\[/gm;
    },
);

1;

=head1 NAME

Acme::MetaSyntactic::viclones - The C<vi> clones theme

=head1 DESCRIPTION

A list of vi clones, as maintained by Sven Guckes on
L<http://www.saki.com.au/mirror/vi/clones.php3>.

=head1 CONTRIBUTOR

Philippe "BooK" Bruhat.

Introduced in version 0.10, published on February 21, 2005.

Added a remote list in version 0.49, published on November 21, 2005.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
BBStevie bedit Bvi calvin e3 Elvis exvi elwin javi jVi Lemmy levee nvi
Oak_Hill_vi PVIC trived tvi vigor vile vim Watcom_VI WinVi viper virus
xvi
