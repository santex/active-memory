package Acme::MetaSyntactic::dilbert;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );
__PACKAGE__->init();

our %Remote = (
    source  => 'http://www.triviaasylum.com/dilbert/diltriv.html',
    extract => sub {
        return
            grep { $_ ne '' }
            map { s/_+/_/g; s/^_//; $_ }
            map { y!- '"/!____ !; s/\.//g; split ' ', lc }
            $_[0] =~ m!<b>([^<]+)</b>!gm;
    },
);

1;

=head1 NAME

Acme::MetaSyntactic::dilbert - The Dilbert theme

=head1 DESCRIPTION

Characters from the Dilbert daily strip.

The list (with details) is available here:
L<http://www.triviaasylum.com/dilbert/diltriv.html>.

=head1 CONTRIBUTOR

Original contributor: Sébastien Aperghis-Tramoni.

Introduced in version 0.03, published on January 14, 2005.

Duplicate removed in version 0.15, published on March 28, 2005.

Updated with a brand new list in version 0.29, published on July 4, 2005.

Remote list added and theme updated in version 0.49, published on November 21, 2005.

Later updates (from the source web site):

=over 4

=item * version 0.51, published on December 5, 2005

=item * version 0.52, published on December 12, 2005

=item * version 0.53, published on December 19, 2005

=item * version 0.57, published on January 16, 2006

=item * version 0.60, published on February 6, 2006

=item * version 0.68, published on April 3, 2006

=item * version 0.78, published on June 12, 2006

=item * version 0.80, published on June 26, 2006

=item * version 0.81, published on July 3, 2006

=item * version 0.82, published on July 10, 2006

=item * version 0.89, published on August 28, 2006

=item * version 0.91, published on September 11, 2006

=item * version 0.92, published on September 18, 2006

=item * version 0.97, published on October 23, 2006

=item * version 0.98, published on October 30, 2006

=back

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
al alice allen ann anne anne_l_retentive antina asok aunt_helen
avery_wong bad_ed barry becky ben betty beverly big_boss big_ed bill
bob bob_flabeau bob_weaselton bobby bobby_mcnewton bobby_noober boron
bottleneck_bill brad bradley brenda brenda_utthead brent brian bruce
bucky bud buff_bufferman camping_carl carl carlos carol cheryl chuck
cliffy co_op_employee connie cyrus_the_virus dan dave dawn dee_alamo
dilbert doctor_wolfington dogbert donald dorie ed eddy edfred edna
edward_lester_mann eileen ellen ernie flossie floyd floyd_remora
fred freshy_q gustav hammerhead_bob harold harry_middlepart helen
holly_hollister incredulous_ed irene irv irv_klepfurd jack janet
jennifer jenny_dworkin jim jimmy jittery_jeff john_smith johnson jose
juan_delegator judy karl kay_and_clem_bovinski ken kronos kudos larry
laura lauren laurie les lisa liz lola loopy loud_howard lulu mahoney
mary matt medical_mel mel michael_t_suit mike millard_bullrush milt ming
miss_cerberus miss_mulput miss_pennington mister_catbert mister_goodenrich
mittens mo mom monty mordac mother_nature motivation_fairy mr_death
mr_dork myron nardo neal_snow ned nelson nervous_ed norma norman
parrot_man paul paul_ooshen paul_tergeist peeved_eve peri_noid
pete_peters peter phil phil_de_cube phil_from_heck pigboy plywoodboss
pointy_haired_carl pointy_haired_pete proxis queen_bee_of_marketing
randy ratbert ray rex richard rick robert_roberts roboboss rocky ron
ruebert rufus_t_skwerrel russell sally sam_grooper sharon son_of_a_boss
sophie stan susan sven techno_bill technology_buddha ted ted_griffin
the_boss tim timmy tina toby todd tom too_helpful_guy topper toxic_tom
traylor uncle_albert uncle_max uncle_ned upholsterygeist virginia
waldo wally walter wendel wendy will willy wilson wilt_gandhi winston
world_s_smartest_garbage_man yergi yorgi yugi yvonne zenox zimbu zoltar
tex flashy petricia tim_zumph earl lefty sourpuss wendel_j_stone_iv
vijay exactly_man alan andy
lou mister_serdecisions sandeep
patty smokin_jim betty_the_bulldozer
amber_dextrous stinky_pete 
phil_o_dendron
steve
lyin_john
mindy
robbie_the_frightening_hobo
