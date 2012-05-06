package Acme::MetaSyntactic::linux;
use strict;
use Acme::MetaSyntactic::List;
our @ISA = qw( Acme::MetaSyntactic::List );

our %Remote = (
    source  => 'http://distrowatch.com/stats.php',
    extract => sub {
        return
            map {
                s/\@/_at_/g; s/\+/_plus_/g;
                s/^2/Two_/;  s/^64/Sixty_four_/;
                s/^_|_$//g;  s/_+/_/g;
                $_
                }
            map { Acme::MetaSyntactic::RemoteList::tr_nonword($_) }
            map { Acme::MetaSyntactic::RemoteList::tr_utf8_basic($_) }
            $_[0] =~ m!&bull; <a href="\w+">([^<]+)</a></td></tr>!g;
    }
);

__PACKAGE__->init();

1;

=head1 NAME

Acme::MetaSyntactic::linux - The Linux theme

=head1 DESCRIPTION

This theme contains the lists all the known and less
known Linux distributions, as maintained by DistroWatch on
L<http://distrowatch.com/stats.php>.

Note that the distribution list also contains the *BSD projects.

=head1 CONTRIBUTOR

Philippe "BooK" Bruhat.

Introduced in version 0.95, published on October 9, 2006.

Later updates (from the source web site):

=over 4

=item * version 0.97, published on October 23, 2006.

=item * version 0.98, published on October 30, 2006.

=item * version 0.99, published on November 6, 2006.

=back

=head1 DEDICATION

This module is dedicated to the Linux kernel for its fifteenth
anniversary. Linux was first published on the C<comp.archives> newsgroup
on October 5, 1991.
See L<http://groups.google.com/group/comp.archives/msg/13a145b453f89094>

Linux was announced on C<comp.os.minix> on August 25, 1991.
See L<http://groups.google.com/group/comp.os.minix/msg/b813d52cbc5a044b>

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>.

=cut

__DATA__
# names
Two_X
Sixty_four_Studio
AbulEdu
Adamantix
ADIOS
Admelix
Alinex
aLinux
AliXe
ALT
amaroK_Live
Annvix
AnNyung
Anonym_OS
APODIO
Arabian
Arch
ArcheOS
Archie
Ark
Arudius
AsianLinux
Asianux
ASLinux
ASPLinux
Astaro
Athene
ATmission
Atomix
Aurora
Aurox
AUSTRUMI
B2D
BackTrack
Bayanihan
BeleniX
Berry
BIG_LINUX
BinToo
BioBrew
Bioknoppix
blackPanther
BLAG
Bluewall
Bluewhite64
Buffalo
BU_Linux
Burapha
Caixa_Magica
cAos
Catix
CCux
CDlinux
Censornet
CentOS
ClarkConnect
Clusterix
clusterKNOPPIX
College
Condorux
Coyote
CRUX
Damn_Small
DANIX
DARKSTAR
Debian
Deep_Water
DeLi
DesktopBSD
Devil
Dizinha
DNALinux
DragonFly
Dreamlinux
dyne_bolic
Dzongkha
Eadem
Eagle
easys
Edubuntu
eduKnoppix
Ehad
Ekaaty
eLearnix
Elive
ELX
Endian
EnGarde
ERPOSS
Euronode
Evinux
EzPlanet_One
FAMELIX
Feather
Featherweight
Fedora
Fermi
Finnix
Foresight
FoX_Desktop
FreeBSD
Freedows
Freeduc
Freeduc_Sup
FreeNAS
FreeSBIE
Freespire
Frenzy
Frugalware
FTOSX
GeeXboX
Gelecek
GenieOS
Gentoo
GentooTH
Gentoox
GEOLivre
Gibraltar
gNewSense
GNIX
GNUstep
GoblinX
GoboLinux
GParted
Grafpup
grml
Guadalinex
GuLIC_BSD
Haansoft
Hakin9
Hancom
Hedinux
Helix
Heretix
Hikarunix
Hiweed
Holon
Honeywall
How_Tux
Ichthux
IDMS
Ignalum
Impi
IndLinux
INSERT
IPCop
JoLinux
Julex
K12LTSP
Kaella
Kalango
KANOTIX
Karamad
KateOS
K_DEMar
Kinneret
Klax
knopILS
Knoppel
Knopperdisk
KNOPPIX
KnoppiXMAME
KnoppMyth
KnoSciences
Komodo
Kororaa
Kubuntu
Kurumin
Kwort
L_A_S
LFS
LG3D
LIIS
Linare
Lineox
LinEspa
gnuLinEx
LinnexOS
Linpus
Linspire
LinuxConsole
Linux_EduCD
Linux_Live
LinuxTLE
Linux_XP
Litrix
LiveCD_Router
LiVux
LLGP
LliureX
LNX_BBC
Loco
Lormalinux
Lunar
Magic
Mandriva
MAX
Mayix
MCNLive
Media_Lab
Mediainlinux
MEPIS
Miracle
MirOS
Mockup
MoLinux
Momonga
Monoppix
m0n0wall
Morphix
MoviX
Muriqui
Murix
Musix
Mutagenix
Myah_OS
myLinux
Nasgaia
Nature_s
Navyn_OS
NepaLinux
NetBSD
NetSecL
Nexenta
Niigata
Nitix
Nonux
Novell_SLE
NST
nUbuntu
NuxOne
OliveBSD
Omoikane
O_Net
OpenBSD
Co_Create
OpenLab
OpenLX
OpenNA
Openwall
Oracle
Oralux
PAIPIX
ParallelKnoppix
Pardus
Parsix
PC_BSD
PCLinuxOS
Penguin_Sleuth
Pentoo
Pequelin
pfSense
Phaeronix
Pie_Box
Pilot
Pingo
Pingwinek
Plamo
PLD
Poseidon
pQui
Progeny
PUD
Puppy
QiLinux
Quantian
Rails_Live
Red_Flag
Red_Hat
redWall
RIP
ROCK
Rocks_Cluster
RoFreeSBIE
ROOT
ROSLIMS
rPath
Sabayon
SAM
SaxenOS
SchilliX
SCI_Linux
Scientific
Securepoint
Sentry_Firewall
SharkOS
Shift
Skolelinux
Slackintosh
Slackware
Slamd64
SLAMPP
SLAX
SLYNUX
SME_Server
SmoothWall
SoL
Solaris
Sorcerer
Source_Mage
StartCom
STD
StressLinux
STUX
SuliX
Sun_Wah
openSUSE
Symphony_OS
SystemRescue
T2
TA_Linux
Tablix
Taprobane
Thinstation
Tilix
tinysofa
Topologilinux
Trinity
trixbox
TrueBSD
Trustix
Truva
TumiX
TupiServer
Tuquito
Turbolinux
Turkix
Ubuntu
Ubuntu_CE
Ufficio_Zero
UHU_Linux
Ultima
Underground
Ututo
Vector
VideoLinux
Vine
VLOS
VNLinux
Voltalinux
Wazobia
White_Box
WIENUX
Wolvix
Xandros
Xarnoppix
Xenoppix
X_evian
Xfld
X_OS
Xteam
Xubuntu
Yellow_Dog
Yoper
YES
Zenwalk
ZoneCD
