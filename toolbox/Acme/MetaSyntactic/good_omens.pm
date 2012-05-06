package Acme::MetaSyntactic::good_omens;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );

=head1 NAME

Acme::MetaSyntactic::good_omens - The Good Omens theme

=head1 DESCRIPTION

This list gives the names of the characters from
Neil Gaiman and Terry Pratchett's novel, I<Good Omens>.

Source: I<Good Omens>

A Narrative of Certain Events occurring in the
last eleven years of human history, in strict accordance as shall
be shewn with: 

I<The Nice and Accurate Prophecies of Agnes Nutter>

Compiled and edited, with Footnotes of an Educational Nature
and Precepts for the Wise,
by Neil Gaiman and Terry Pratchett.

=cut

{
    my %seen;
    __PACKAGE__->init(
        {   names => join ' ',
            grep    { !$seen{$_}++ }
                map { s/_+/_/g; $_ }
                map { Acme::MetaSyntactic::RemoteList::tr_nonword($_) }
                map { Acme::MetaSyntactic::RemoteList::tr_accent($_) }
                map { /^=item\s+(.*?)\s*$/ ? $1 : () }
                split /\n/ => <<'=cut'} );

=pod

=head1 DRAMATIS PERSONAE 

=head2 SUPERNATURAL BEINGS

=over 4

=item God

God

=item Metatron

The Voice of God

=item Aziraphale

An angel, and part-time rare book dealer

=item Satan

A Fallen Angel; the Adversary

=item Beelzebub

A Likewise Fallen Angel and Prince of Hell

=item Hastur

A Fallen Angel and Duke of Hell

=item Ligur

Likewise a Fallen Angel and Duke of Hell

=item Crowley

An Angel who did not so much Fall as Saunter Vaguely Downwards

=back

=head2 APOCALYPTIC HORSEPERSONS

=over 4

=item DEATH

Death

=item War

War

=item Famine

Famine

=item Pollution

Pollution

=back

=head2 HUMANS

=over 4

=item Thou-Shalt-Not-Commit-Adultery Pulsifer

A Witchfinder

=item Agnes Nutter

A Prophetess

=item Newton Pulsifer

Wages Clerk and Witchfinder Private

=item Anathema Device

Practical Occultist and Professional Descendant

=item Shadwell

Witchfinder Sergeant

=item Madame Tracy

Painted Jezebel [mornings only, Thursdays by arrangement] and Medium

=item Sister Mary Loquacious

A Satanic Nun of the Chattering Order of St. Beryl

=item Mr Young

A Father

=item Mr Tyler

A Chairman of a Residents' Association

=item A Delivery Man 

=back

=head2 THEM

=over 4

=item ADAM

An Antichrist

=item Pepper

A Girl

=item Wensleydale

A Boy

=item Brian

A Boy

=back

Full Chorus of Tibetans, Aliens, Americans, Atlanteans and other rare and strange Creatures of the Last Days. 

=head2 AND

=over 4

=item Dog

Satanical hellhound and cat-worrier 

=back

=cut

}

666;

__END__

=head1 CONTRIBUTOR

Jean Forget.

Introduced in version 0.97, published on October 23, 2006.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

