#!/usr/bin/perl -W
use strict; use warnings;
use WWW::Mechanize ();
use Getopt::Long;
use Pod::Usage;
use LWP::UserAgent::Anonymous;
use Data::Dumper;
use Data::RandomPerson;
use Digest::MD5 qw(md5_hex);

use HTTP::Cookies;
my @actions;
my $absolute;

my $user;
my $pass;
my $agent;
my $agent_alias;
my $cookie_filename;

my $mech = WWW::Mechanize->new();
my $uri = "http://127.0.0.1";# or die "Must specify a URL or file to check.  See --help for details.\n";

sub trim
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\@/\r\n/;
	return $string;
}

my @mac = <DATA>;#[split (/=| /,`macchanger -l | xargs echo -s`)];
my $r = Data::RandomPerson->new();
my $p = $r->create();
my $provider = ["googlemail.com","yahoo.de","yahoo.com","gmail.com"];
   $p->{salt} =  sprintf "%d",rand 4;
my $salt =    $p->{salt};
   my @dob = split "-",$p->{dob};
   my $toyoung = sprintf "%d", ($p->{age} < 28 ? 18 : 0);
   my $toold = sprintf "%d", ($p->{age} > 50 ? rand 50 : 0);

   if($toyoung) {
       $p->{dob} = sprintf "%d-%s-%s",($dob[0]-$toyoung),$dob[1],$dob[2];
       $toyoung = $toyoung-1;
       $p->{age} =  sprintf "%d",$p->{age} + $toyoung;
    }

   if($toold) {

       $p->{dob} = sprintf "%d-%s-%s",($dob[0]+$toold),$dob[1],$dob[2];
       $toold =  $toold+1;
       $p->{age} = sprintf "%d", $p->{age} - $toold;
    }



   $p->{email} = sprintf "%s.%s@%s" , lc  $p->{firstname},lc $p->{lastname},@$provider[$p->{salt}];
   $p->{pass} =  md5_hex $p->{email}.   $salt;
   $p->{mac} = sprintf(trim($mac[rand $#mac]));
   $p->{mac} .= sprintf(trim($mac[rand $#mac/2]));
   $p->{mac} =~ s/\n//g;

   $p->{mac} = [split(/ - /,$p->{mac})];
   $p->{macadd} = sprintf("%s:%s",trim($p->{mac}[1]),trim($p->{mac}[3]));
   $p->{organisation} = sprintf("%s",trim($p->{mac}[2]));
   $p->{organisation} =~ s/[0-9][0-9][0-9][0-9]//g;

  $p->{browser} = LWP::UserAgent::Anonymous->new("timeout"=>30,"agent"=>md5_hex(sprintf(Dumper $p)));
  #$p->{browser}->set_max_retray(12);
  $p->{browser}->set_debug(1);
  $p->{browser}->set_proxy();

  if(defined($p->{browser}->{'_proxy'}))
  {
#    $p->{request}  = HTTP::Request->new(HEAD=>'http://127.0.0.1/');
 #   $p->{response} = $p->{browser}->anon_request($p->{request});


		if ( -e $uri ) {
				require URI::file;
				$uri = URI::file->new_abs( $uri )->as_string;
		}

		@actions = (\&dump_forms) unless @actions;

	
		if ( defined $p->{browser} ) {
				$mech->agent( $p->{browser} );
		}
		elsif ( defined $agent_alias ) {
				$mech->agent_alias( $agent_alias );
		}



				 print Dumper $p;
  }
  delete $p->{mac};

if ( defined $cookie_filename ) {
    my $cookies = HTTP::Cookies->new( file => $cookie_filename, autosave => 1, ignore_discard => 1 );
    $cookies->load() ;
    $mech->cookie_jar($cookies);
}
else {
    $mech->cookie_jar(undef) ;
}

$mech->env_proxy();
my $response = $mech->get( $uri );
if (!$response->is_success and defined ($response->www_authenticate)) {
    if (!defined $user or !defined $pass) {
        die("Page requires username and password, but none specified.\n");
    }
    $mech->credentials($user,$pass);
    $response = $mech->get( $uri );
    $response->is_success or die "Can't fetch $uri with username and password\n", $response->status_line, "\n";
}
$mech->is_html or die qq{$uri returns type "}, $mech->ct, qq{", not "text/html"\n};

while ( my $action = shift @actions ) {
    $action->( $mech );
    print "\n" if @actions;
}


sub dump_headers {
    my $mech = shift;
    $mech->dump_headers( undef );
    return;
}

sub dump_forms {
    my $mech = shift;
    $mech->dump_forms( undef, $absolute );
    return;
}

sub dump_links {
    my $mech = shift;
    $mech->dump_links( undef, $absolute );
    return;
}

sub dump_images {
    my $mech = shift;
    $mech->dump_images( undef, $absolute );
    return;
}

sub dump_text {
    my $mech = shift;
    $mech->dump_text();
    return;
}

   END  {


   }

1;
__DATA__
0000 - 00:00:00 - Xerox Corporation
0001 - 00:00:01 - Xerox Corporation
0002 - 00:00:02 - Xerox Corporation
0003 - 00:00:03 - Xerox Corporation
0004 - 00:00:04 - Xerox Corporation
0005 - 00:00:05 - Xerox Corporation
0006 - 00:00:06 - Xerox Corporation
0007 - 00:00:07 - Xerox Corporation
0008 - 00:00:08 - Xerox Corporation
0009 - 00:00:09 - Xerox Corporation
0010 - 00:00:0a - Omron Tateisi Electronics Co.
0011 - 00:00:0b - Matrix Corporation
0012 - 00:00:0c - Cisco Systems, Inc.
0013 - 00:00:0d - Fibronics Ltd.
0014 - 00:00:0e - Fujitsu Limited
0015 - 00:00:0f - Next, Inc.
0016 - 00:00:10 - Sytek Inc.
0017 - 00:00:11 - Normerel Systemes
0018 - 00:00:12 - Information Technology Limited
0019 - 00:00:13 - Camex
0020 - 00:00:14 - Netronix
0021 - 00:00:15 - Datapoint Corporation
0022 - 00:00:16 - Du Pont Pixel Systems     .
0023 - 00:00:17 - Tekelec
0024 - 00:00:18 - Webster Computer Corporation
0025 - 00:00:19 - Applied Dynamics International
0026 - 00:00:1a - Advanced Micro Devices
0027 - 00:00:1b - Novell Inc.
0028 - 00:00:1c - Bell Technologies
0029 - 00:00:1d - Cabletron Systems, Inc.
0030 - 00:00:1e - Telsist Industria Electronica
0031 - 00:00:1f - Telco Systems, Inc.
0032 - 00:00:20 - Dataindustrier Diab Ab
0033 - 00:00:21 - Sureman Comp. & Commun. Corp.
0034 - 00:00:22 - Visual Technology Inc.
0035 - 00:00:23 - Abb Industrial Systems Ab
0036 - 00:00:24 - Connect As
0037 - 00:00:25 - Ramtek Corp.
0038 - 00:00:26 - Sha-ken Co., Ltd.
0039 - 00:00:27 - Japan Radio Company
0040 - 00:00:28 - Prodigy Systems Corporation
0041 - 00:00:29 - Imc Networks Corp.
0042 - 00:00:2a - Trw - Sedd/inp
0043 - 00:00:2b - Crisp Automation, Inc
0044 - 00:00:2c - Autotote Limited
0045 - 00:00:2d - Chromatics Inc
0046 - 00:00:2e - Societe Evira
0047 - 00:00:2f - Timeplex Inc.
0048 - 00:00:30 - Vg Laboratory Systems Ltd
0049 - 00:00:31 - Qpsx Communications Pty Ltd
0050 - 00:00:32 - Marconi Plc
0051 - 00:00:33 - Egan Machinery Company
0052 - 00:00:34 - Network Resources Corporation
0053 - 00:00:35 - Spectragraphics Corporation
0054 - 00:00:36 - Atari Corporation
0055 - 00:00:37 - Oxford Metrics Limited
0056 - 00:00:38 - Css Labs
0057 - 00:00:39 - Toshiba Corporation
0058 - 00:00:3a - Chyron Corporation
0059 - 00:00:3b - I Controls, Inc.
0060 - 00:00:3c - Auspex Systems Inc.
0061 - 00:00:3d - Unisys
0062 - 00:00:3e - Simpact
0063 - 00:00:3f - Syntrex, Inc.
0064 - 00:00:40 - Applicon, Inc.
0065 - 00:00:41 - Ice Corporation
0066 - 00:00:42 - Metier Management Systems Ltd.
0067 - 00:00:43 - Micro Technology
0068 - 00:00:44 - Castelle Corporation
0069 - 00:00:45 - Ford Aerospace & Comm. Corp.
0070 - 00:00:46 - Olivetti North America
0071 - 00:00:47 - Nicolet Instruments Corp.
0072 - 00:00:48 - Seiko Epson Corporation
0073 - 00:00:49 - Apricot Computers, Ltd
0074 - 00:00:4a - Adc Codenoll Technology Corp.
0075 - 00:00:4b - Icl Data Oy
0076 - 00:00:4c - Nec Corporation
0077 - 00:00:4d - Dci Corporation
0078 - 00:00:4e - Ampex Corporation
0079 - 00:00:4f - Logicraft, Inc.
0080 - 00:00:50 - Radisys Corporation
0081 - 00:00:51 - Hob Electronic Gmbh & Co. Kg
0082 - 00:00:52 - Intrusion.com, Inc.
0083 - 00:00:53 - Compucorp
0084 - 00:00:54 - Modicon, Inc.
0085 - 00:00:55 - Commissariat A L`energie Atom.
0086 - 00:00:56 - Dr. B. Struck
0087 - 00:00:57 - Scitex Corporation Ltd.
0088 - 00:00:58 - Racore Computer Products Inc.
0089 - 00:00:59 - Hellige Gmbh
0090 - 00:00:5a - Syskonnect Gmbh
0091 - 00:00:5b - Eltec Elektronik Ag
0092 - 00:00:5c - Telematics International Inc.
0093 - 00:00:5d - Cs Telecom
0094 - 00:00:5e - Usc Information Sciences Inst
0095 - 00:00:5f - Sumitomo Electric Ind., Ltd.
0096 - 00:00:60 - Kontron Elektronik Gmbh
0097 - 00:00:61 - Gateway Communications
0098 - 00:00:62 - Bull Hn Information Systems
0099 - 00:00:63 - Barco Control Rooms Gmbh
0100 - 00:00:64 - Yokogawa Digital Computer Corp
0101 - 00:00:65 - Network General Corporation
0102 - 00:00:66 - Talaris Systems, Inc.
0103 - 00:00:67 - Soft * Rite, Inc.
0104 - 00:00:68 - Rosemount Controls
0105 - 00:00:69 - Concord Communications Inc
0106 - 00:00:6a - Computer Consoles Inc.
0107 - 00:00:6b - Silicon Graphics Inc./mips
0108 - 00:00:6c - Private
0109 - 00:00:6d - Cray Communications, Ltd.
0110 - 00:00:6e - Artisoft, Inc.
0111 - 00:00:6f - Madge Ltd.
0112 - 00:00:70 - Hcl Limited
0113 - 00:00:71 - Adra Systems Inc.
0114 - 00:00:72 - Miniware Technology
0115 - 00:00:73 - Siecor Corporation
0116 - 00:00:74 - Ricoh Company Ltd.
0117 - 00:00:75 - Nortel Networks
0118 - 00:00:76 - Abekas Video System
0119 - 00:00:77 - Interphase Corporation
0120 - 00:00:78 - Labtam Limited
0121 - 00:00:79 - Networth Incorporated
0122 - 00:00:7a - Dana Computer Inc.
0123 - 00:00:7b - Research Machines
0124 - 00:00:7c - Ampere Incorporated
0125 - 00:00:7d - Oracle Corporation
0126 - 00:00:7e - Clustrix Corporation
0127 - 00:00:7f - Linotype-hell Ag
0128 - 00:00:80 - Cray Communications A/s
0129 - 00:00:81 - Bay Networks
0130 - 00:00:82 - Lectra Systemes Sa
0131 - 00:00:83 - Tadpole Technology Plc
0132 - 00:00:84 - Supernet
0133 - 00:00:85 - Canon Inc.
0134 - 00:00:86 - Megahertz Corporation
0135 - 00:00:87 - Hitachi, Ltd.
0136 - 00:00:88 - Brocade Communications Systems, Inc.
0137 - 00:00:89 - Cayman Systems Inc.
0138 - 00:00:8a - Datahouse Information Systems
0139 - 00:00:8b - Infotron
0140 - 00:00:8c - Alloy Computer Products (australia) Pty Ltd
0141 - 00:00:8d - Cryptek Inc.
0142 - 00:00:8e - Solbourne Computer, Inc.
0143 - 00:00:8f - Raytheon
0144 - 00:00:90 - Microcom
0145 - 00:00:91 - Anritsu Corporation
0146 - 00:00:92 - Cogent Data Technologies
0147 - 00:00:93 - Proteon Inc.
0148 - 00:00:94 - Asante Technologies
0149 - 00:00:95 - Sony Tektronix Corp.
0150 - 00:00:96 - Marconi Electronics Ltd.
0151 - 00:00:97 - Emc Corporation
0152 - 00:00:98 - Crosscomm Corporation
0153 - 00:00:99 - Mtx, Inc.
0154 - 00:00:9a - Rc Computer A/s
0155 - 00:00:9b - Information International, Inc
0156 - 00:00:9c - Rolm Mil-spec Computers
0157 - 00:00:9d - Locus Computing Corporation
0158 - 00:00:9e - Marli S.a.
0159 - 00:00:9f - Ameristar Technologies Inc.
0160 - 00:00:a0 - Sanyo Electric Co., Ltd.
0161 - 00:00:a1 - Marquette Electric Co.
0162 - 00:00:a2 - Bay Networks
0163 - 00:00:a3 - Network Application Technology
0164 - 00:00:a4 - Acorn Computers Limited
0165 - 00:00:a5 - Compatible Systems Corp.
0166 - 00:00:a6 - Network General Corporation
0167 - 00:00:a7 - Network Computing Devices Inc.
0168 - 00:00:a8 - Stratus Computer Inc.
0169 - 00:00:a9 - Network Systems Corp.
0170 - 00:00:aa - Xerox Corporation
0171 - 00:00:ab - Logic Modeling Corporation
0172 - 00:00:ac - Conware Computer Consulting
0173 - 00:00:ad - Bruker Instruments Inc.
0174 - 00:00:ae - Dassault Electronique
0175 - 00:00:af - Nuclear Data Instrumentation
0176 - 00:00:b0 - Rnd-rad Network Devices
0177 - 00:00:b1 - Alpha Microsystems Inc.
0178 - 00:00:b2 - Televideo Systems, Inc.
0179 - 00:00:b3 - Cimlinc Incorporated
0180 - 00:00:b4 - Edimax Computer Company
0181 - 00:00:b5 - Datability Software Sys. Inc.
0182 - 00:00:b6 - Micro-matic Research
0183 - 00:00:b7 - Dove Computer Corporation
0184 - 00:00:b8 - Seikosha Co., Ltd.
0185 - 00:00:b9 - Mcdonnell Douglas Computer Sys
0186 - 00:00:ba - Siig, Inc.
0187 - 00:00:bb - Tri-data
0188 - 00:00:bc - Rockwell Automation
0189 - 00:00:bd - Mitsubishi Cable Company
0190 - 00:00:be - The Nti Group
0191 - 00:00:bf - Symmetric Computer Systems
0192 - 00:00:c0 - Western Digital Corporation
0193 - 00:00:c1 - Madge Ltd.
0194 - 00:00:c2 - Information Presentation Tech.
0195 - 00:00:c3 - Harris Corp Computer Sys Div
0196 - 00:00:c4 - Waters Div. Of Millipore
0197 - 00:00:c5 - Farallon Computing/netopia
0198 - 00:00:c6 - Eon Systems
0199 - 00:00:c7 - Arix Corporation
0200 - 00:00:c8 - Altos Computer Systems
0201 - 00:00:c9 - Emulex Corporation
0202 - 00:00:ca - Arris International
0203 - 00:00:cb - Compu-shack Electronic Gmbh
0204 - 00:00:cc - Densan Co., Ltd.
0205 - 00:00:cd - Allied Telesis Labs Ltd
0206 - 00:00:ce - Megadata Corp.
0207 - 00:00:cf - Hayes Microcomputer Products
0208 - 00:00:d0 - Develcon Electronics Ltd.
0209 - 00:00:d1 - Adaptec Incorporated
0210 - 00:00:d2 - Sbe, Inc.
0211 - 00:00:d3 - Wang Laboratories Inc.
0212 - 00:00:d4 - Pure Data Ltd.
0213 - 00:00:d5 - Micrognosis International
0214 - 00:00:d6 - Punch Line Holding
0215 - 00:00:d7 - Dartmouth College
0216 - 00:00:d8 - Novell, Inc.
0217 - 00:00:d9 - Nippon Telegraph & Telephone
0218 - 00:00:da - Atex
0219 - 00:00:db - British Telecommunications Plc
0220 - 00:00:dc - Hayes Microcomputer Products
0221 - 00:00:dd - Tcl Incorporated
0222 - 00:00:de - Cetia
0223 - 00:00:df - Bell & Howell Pub Sys Div
0224 - 00:00:e0 - Quadram Corp.
0225 - 00:00:e1 - Grid Systems
0226 - 00:00:e2 - Acer Technologies Corp.
0227 - 00:00:e3 - Integrated Micro Products Ltd
0228 - 00:00:e4 - In2 Groupe Intertechnique
0229 - 00:00:e5 - Sigmex Ltd.
0230 - 00:00:e6 - Aptor Produits De Comm Indust
0231 - 00:00:e7 - Star Gate Technologies
0232 - 00:00:e8 - Accton Technology Corp.
0233 - 00:00:e9 - Isicad, Inc.
0234 - 00:00:ea - Upnod Ab
0235 - 00:00:eb - Matsushita Comm. Ind. Co. Ltd.
0236 - 00:00:ec - Microprocess
0237 - 00:00:ed - April
0238 - 00:00:ee - Network Designers, Ltd.
0239 - 00:00:ef - Kti
0240 - 00:00:f0 - Samsung Electronics Co., Ltd.
0241 - 00:00:f1 - Magna Computer Corporation
0242 - 00:00:f2 - Spider Communications
0243 - 00:00:f3 - Gandalf Data Limited
0244 - 00:00:f4 - Allied Telesis
0245 - 00:00:f5 - Diamond Sales Limited
0246 - 00:00:f6 - Applied Microsystems Corp.
0247 - 00:00:f7 - Youth Keep Enterprise Co Ltd
0248 - 00:00:f8 - Digital Equipment Corporation
0249 - 00:00:f9 - Quotron Systems Inc.
0250 - 00:00:fa - Microsage Computer Systems Inc
0251 - 00:00:fb - Rechner Zur Kommunikation
0252 - 00:00:fc - Meiko
0253 - 00:00:fd - High Level Hardware
0254 - 00:00:fe - Annapolis Micro Systems
0255 - 00:00:ff - Camtec Electronics Ltd.
0256 - 00:01:00 - Equip'trans
0257 - 00:01:01 - Private
0258 - 00:01:02 - 3com Corporation
0259 - 00:01:03 - 3com Corporation
0260 - 00:01:04 - Dvico Co., Ltd.
0261 - 00:01:05 - Beckhoff Automation Gmbh
0262 - 00:01:06 - Tews Datentechnik Gmbh
0263 - 00:01:07 - Leiser Gmbh
0264 - 00:01:08 - Avlab Technology, Inc.
0265 - 00:01:09 - Nagano Japan Radio Co., Ltd.
0266 - 00:01:0a - Cis Technology Inc.
0267 - 00:01:0b - Space Cyberlink, Inc.
0268 - 00:01:0c - System Talks Inc.
0269 - 00:01:0d - Coreco, Inc.
0270 - 00:01:0e - Bri-link Technologies Co., Ltd
0271 - 00:01:0f - Brocade Communications Systems, Inc.
0272 - 00:01:10 - Gotham Networks
0273 - 00:01:11 - Idigm Inc.
0274 - 00:01:12 - Shark Multimedia Inc.
0275 - 00:01:13 - Olympus Corporation
0276 - 00:01:14 - Kanda Tsushin Kogyo Co., Ltd.
0277 - 00:01:15 - Extratech Corporation
0278 - 00:01:16 - Netspect Technologies, Inc.
0279 - 00:01:17 - Canal +
0280 - 00:01:18 - Ez Digital Co., Ltd.
0281 - 00:01:19 - Rtunet (australia)
0282 - 00:01:1a - Eeh Datalink Gmbh
0283 - 00:01:1b - Unizone Technologies, Inc.
0284 - 00:01:1c - Universal Talkware Corporation
0285 - 00:01:1d - Centillium Communications
0286 - 00:01:1e - Precidia Technologies, Inc.
0287 - 00:01:1f - Rc Networks, Inc.
0288 - 00:01:20 - Oscilloquartz S.a.
0289 - 00:01:21 - Watchguard Technologies, Inc.
0290 - 00:01:22 - Trend Communications, Ltd.
0291 - 00:01:23 - Digital Electronics Corp.
0292 - 00:01:24 - Acer Incorporated
0293 - 00:01:25 - Yaesu Musen Co., Ltd.
0294 - 00:01:26 - Pac Labs
0295 - 00:01:27 - Open Networks Pty Ltd
0296 - 00:01:28 - Enjoyweb, Inc.
0297 - 00:01:29 - Dfi Inc.
0298 - 00:01:2a - Telematica Sistems Inteligente
0299 - 00:01:2b - Telenet Co., Ltd.
0300 - 00:01:2c - Aravox Technologies, Inc.
0301 - 00:01:2d - Komodo Technology
0302 - 00:01:2e - Pc Partner Ltd.
0303 - 00:01:2f - Twinhead International Corp
0304 - 00:01:30 - Extreme Networks
0305 - 00:01:31 - Bosch Security Systems, Inc.
0306 - 00:01:32 - Dranetz - Bmi
0307 - 00:01:33 - Kyowa Electronic Instruments C
0308 - 00:01:34 - Selectron Systems Ag
0309 - 00:01:35 - Kdc Corp.
0310 - 00:01:36 - Cybertan Technology, Inc.
0311 - 00:01:37 - It Farm Corporation
0312 - 00:01:38 - Xavi Technologies Corp.
0313 - 00:01:39 - Point Multimedia Systems
0314 - 00:01:3a - Shelcad Communications, Ltd.
0315 - 00:01:3b - Bna Systems
0316 - 00:01:3c - Tiw Systems
0317 - 00:01:3d - Riscstation Ltd.
0318 - 00:01:3e - Ascom Tateco Ab
0319 - 00:01:3f - Neighbor World Co., Ltd.
0320 - 00:01:40 - Sendtek Corporation
0321 - 00:01:41 - Cable Print
0322 - 00:01:42 - Cisco Systems, Inc.
0323 - 00:01:43 - Cisco Systems, Inc.
0324 - 00:01:44 - Emc Corporation
0325 - 00:01:45 - Winsystems, Inc.
0326 - 00:01:46 - Tesco Controls, Inc.
0327 - 00:01:47 - Zhone Technologies
0328 - 00:01:48 - X-traweb Inc.
0329 - 00:01:49 - T.d.t. Transfer Data Test Gmbh
0330 - 00:01:4a - Sony Corporation
0331 - 00:01:4b - Ennovate Networks, Inc.
0332 - 00:01:4c - Berkeley Process Control
0333 - 00:01:4d - Shin Kin Enterprises Co., Ltd
0334 - 00:01:4e - Win Enterprises, Inc.
0335 - 00:01:4f - Adtran Inc
0336 - 00:01:50 - Gilat Communications, Ltd.
0337 - 00:01:51 - Ensemble Communications
0338 - 00:01:52 - Chromatek Inc.
0339 - 00:01:53 - Archtek Telecom Corporation
0340 - 00:01:54 - G3m Corporation
0341 - 00:01:55 - Promise Technology, Inc.
0342 - 00:01:56 - Firewiredirect.com, Inc.
0343 - 00:01:57 - Syswave Co., Ltd
0344 - 00:01:58 - Electro Industries/gauge Tech
0345 - 00:01:59 - S1 Corporation
0346 - 00:01:5a - Digital Video Broadcasting
0347 - 00:01:5b - Italtel S.p.a/rf-up-i
0348 - 00:01:5c - Cadant Inc.
0349 - 00:01:5d - Oracle Corporation
0350 - 00:01:5e - Best Technology Co., Ltd.
0351 - 00:01:5f - Digital Design Gmbh
0352 - 00:01:60 - Elmex Co., Ltd.
0353 - 00:01:61 - Meta Machine Technology
0354 - 00:01:62 - Cygnet Technologies, Inc.
0355 - 00:01:63 - Cisco Systems, Inc.
0356 - 00:01:64 - Cisco Systems, Inc.
0357 - 00:01:65 - Airswitch Corporation
0358 - 00:01:66 - Tc Group A/s
0359 - 00:01:67 - Hioki E.e. Corporation
0360 - 00:01:68 - Vitana Corporation
0361 - 00:01:69 - Celestix Networks Pte Ltd.
0362 - 00:01:6a - Alitec
0363 - 00:01:6b - Lightchip, Inc.
0364 - 00:01:6c - Foxconn
0365 - 00:01:6d - Carriercomm Inc.
0366 - 00:01:6e - Conklin Corporation
0367 - 00:01:6f - Inkel Corp.
0368 - 00:01:70 - Ese Embedded System Engineer'g
0369 - 00:01:71 - Allied Data Technologies
0370 - 00:01:72 - Technoland Co., Ltd.
0371 - 00:01:73 - Amcc
0372 - 00:01:74 - Cyberoptics Corporation
0373 - 00:01:75 - Radiant Communications Corp.
0374 - 00:01:76 - Orient Silver Enterprises
0375 - 00:01:77 - Edsl
0376 - 00:01:78 - Margi Systems, Inc.
0377 - 00:01:79 - Wireless Technology, Inc.
0378 - 00:01:7a - Chengdu Maipu Electric Industrial Co., Ltd.
0379 - 00:01:7b - Heidelberger Druckmaschinen Ag
0380 - 00:01:7c - Ag-e Gmbh
0381 - 00:01:7d - Thermoquest
0382 - 00:01:7e - Adtek System Science Co., Ltd.
0383 - 00:01:7f - Experience Music Project
0384 - 00:01:80 - Aopen, Inc.
0385 - 00:01:81 - Nortel Networks
0386 - 00:01:82 - Dica Technologies Ag
0387 - 00:01:83 - Anite Telecoms
0388 - 00:01:84 - Sieb & Meyer Ag
0389 - 00:01:85 - Aloka Co., Ltd.
0390 - 00:01:86 - Uwe Disch
0391 - 00:01:87 - I2se Gmbh
0392 - 00:01:88 - Lxco Technologies Ag
0393 - 00:01:89 - Refraction Technology, Inc.
0394 - 00:01:8a - Roi Computer Ag
0395 - 00:01:8b - Netlinks Co., Ltd.
0396 - 00:01:8c - Mega Vision
0397 - 00:01:8d - Audesi Technologies
0398 - 00:01:8e - Logitec Corporation
0399 - 00:01:8f - Kenetec, Inc.
0400 - 00:01:90 - Smk-m
0401 - 00:01:91 - Syred Data Systems
0402 - 00:01:92 - Texas Digital Systems
0403 - 00:01:93 - Hanbyul Telecom Co., Ltd.
0404 - 00:01:94 - Capital Equipment Corporation
0405 - 00:01:95 - Sena Technologies, Inc.
0406 - 00:01:96 - Cisco Systems, Inc.
0407 - 00:01:97 - Cisco Systems, Inc.
0408 - 00:01:98 - Darim Vision
0409 - 00:01:99 - Heisei Electronics
0410 - 00:01:9a - Leunig Gmbh
0411 - 00:01:9b - Kyoto Microcomputer Co., Ltd.
0412 - 00:01:9c - Jds Uniphase Inc.
0413 - 00:01:9d - E-control Systems, Inc.
0414 - 00:01:9e - Ess Technology, Inc.
0415 - 00:01:9f - Phonex Broadband
0416 - 00:01:a0 - Infinilink Corporation
0417 - 00:01:a1 - Mag-tek, Inc.
0418 - 00:01:a2 - Logical Co., Ltd.
0419 - 00:01:a3 - Genesys Logic, Inc.
0420 - 00:01:a4 - Microlink Corporation
0421 - 00:01:a5 - Nextcomm, Inc.
0422 - 00:01:a6 - Scientific-atlanta Arcodan A/s
0423 - 00:01:a7 - Unex Technology Corporation
0424 - 00:01:a8 - Welltech Computer Co., Ltd.
0425 - 00:01:a9 - Bmw Ag
0426 - 00:01:aa - Airspan Communications, Ltd.
0427 - 00:01:ab - Main Street Networks
0428 - 00:01:ac - Sitara Networks, Inc.
0429 - 00:01:ad - Coach Master International  D.b.a. Cmi Worldwide, Inc.
0430 - 00:01:ae - Trex Enterprises
0431 - 00:01:af - Emerson Network Power
0432 - 00:01:b0 - Fulltek Technology Co., Ltd.
0433 - 00:01:b1 - General Bandwidth
0434 - 00:01:b2 - Digital Processing Systems, Inc.
0435 - 00:01:b3 - Precision Electronic Manufacturing
0436 - 00:01:b4 - Wayport, Inc.
0437 - 00:01:b5 - Turin Networks, Inc.
0438 - 00:01:b6 - Saejin T&m Co., Ltd.
0439 - 00:01:b7 - Centos, Inc.
0440 - 00:01:b8 - Netsensity, Inc.
0441 - 00:01:b9 - Skf Condition Monitoring
0442 - 00:01:ba - Ic-net, Inc.
0443 - 00:01:bb - Frequentis
0444 - 00:01:bc - Brains Corporation
0445 - 00:01:bd - Peterson Electro-musical Products, Inc.
0446 - 00:01:be - Gigalink Co., Ltd.
0447 - 00:01:bf - Teleforce Co., Ltd.
0448 - 00:01:c0 - Compulab, Ltd.
0449 - 00:01:c1 - Vitesse Semiconductor Corporation
0450 - 00:01:c2 - Ark Research Corp.
0451 - 00:01:c3 - Acromag, Inc.
0452 - 00:01:c4 - Neowave, Inc.
0453 - 00:01:c5 - Simpler Networks
0454 - 00:01:c6 - Quarry Technologies
0455 - 00:01:c7 - Cisco Systems, Inc.
0456 - 00:01:c8 - Thomas Conrad Corp.
0457 - 00:01:c8 - Conrad Corp.
0458 - 00:01:c9 - Cisco Systems, Inc.
0459 - 00:01:ca - Geocast Network Systems, Inc.
0460 - 00:01:cb - Evr
0461 - 00:01:cc - Japan Total Design Communication Co., Ltd.
0462 - 00:01:cd - Artem
0463 - 00:01:ce - Custom Micro Products, Ltd.
0464 - 00:01:cf - Alpha Data Parallel Systems, Ltd.
0465 - 00:01:d0 - Vitalpoint, Inc.
0466 - 00:01:d1 - Conet Communications, Inc.
0467 - 00:01:d2 - Macpower Peripherals, Ltd.
0468 - 00:01:d3 - Paxcomm, Inc.
0469 - 00:01:d4 - Leisure Time, Inc.
0470 - 00:01:d5 - Haedong Info & Comm Co., Ltd
0471 - 00:01:d6 - Manroland Ag
0472 - 00:01:d7 - F5 Networks, Inc.
0473 - 00:01:d8 - Teltronics, Inc.
0474 - 00:01:d9 - Sigma, Inc.
0475 - 00:01:da - Wincomm Corporation
0476 - 00:01:db - Freecom Technologies Gmbh
0477 - 00:01:dc - Activetelco
0478 - 00:01:dd - Avail Networks
0479 - 00:01:de - Trango Systems, Inc.
0480 - 00:01:df - Isdn Communications, Ltd.
0481 - 00:01:e0 - Fast Systems, Inc.
0482 - 00:01:e1 - Kinpo Electronics, Inc.
0483 - 00:01:e2 - Ando Electric Corporation
0484 - 00:01:e3 - Siemens Ag
0485 - 00:01:e4 - Sitera, Inc.
0486 - 00:01:e5 - Supernet, Inc.
0487 - 00:01:e6 - Hewlett-packard Company
0488 - 00:01:e7 - Hewlett-packard Company
0489 - 00:01:e8 - Force10 Networks, Inc.
0490 - 00:01:e9 - Litton Marine Systems B.v.
0491 - 00:01:ea - Cirilium Corp.
0492 - 00:01:eb - C-com Corporation
0493 - 00:01:ec - Ericsson Group
0494 - 00:01:ed - Seta Corp.
0495 - 00:01:ee - Comtrol Europe, Ltd.
0496 - 00:01:ef - Camtel Technology Corp.
0497 - 00:01:f0 - Tridium, Inc.
0498 - 00:01:f1 - Innovative Concepts, Inc.
0499 - 00:01:f2 - Mark Of The Unicorn, Inc.
0500 - 00:01:f3 - Qps, Inc.
0501 - 00:01:f4 - Enterasys Networks
0502 - 00:01:f5 - Erim S.a.
0503 - 00:01:f6 - Association Of Musical Electronics Industry
0504 - 00:01:f7 - Image Display Systems, Inc.
0505 - 00:01:f8 - Adherent Systems, Ltd.
0506 - 00:01:f9 - Teraglobal Communications Corp.
0507 - 00:01:fa - Horoscas
0508 - 00:01:fb - Dotop Technology, Inc.
0509 - 00:01:fc - Keyence Corporation
0510 - 00:01:fd - Digital Voice Systems, Inc.
0511 - 00:01:fe - Digital Equipment Corporation
0512 - 00:01:ff - Data Direct Networks, Inc.
0513 - 00:02:00 - Net & Sys Co., Ltd.
0514 - 00:02:01 - Ifm Electronic Gmbh
0515 - 00:02:02 - Amino Communications, Ltd.
0516 - 00:02:03 - Woonsang Telecom, Inc.
0517 - 00:02:04 - Bodmann Industries Elektronik Gmbh
0518 - 00:02:05 - Hitachi Denshi, Ltd.
0519 - 00:02:06 - Telital R&d Denmark A/s
0520 - 00:02:07 - Visionglobal Network Corp.
0521 - 00:02:08 - Unify Networks, Inc.
0522 - 00:02:09 - Shenzhen Sed Information Technology Co., Ltd.
0523 - 00:02:0a - Gefran Spa
0524 - 00:02:0b - Native Networks, Inc.
0525 - 00:02:0c - Metro-optix
0526 - 00:02:0d - Micronpc.com
0527 - 00:02:0e - Eci Telecom, Ltd., Nsd-us
0528 - 00:02:0f - Aatr
0529 - 00:02:10 - Fenecom
0530 - 00:02:11 - Nature Worldwide Technology Corp.
0531 - 00:02:12 - Sierracom
0532 - 00:02:13 - S.d.e.l.
0533 - 00:02:14 - Dtvro
0534 - 00:02:15 - Cotas Computer Technology A/b
0535 - 00:02:16 - Cisco Systems, Inc.
0536 - 00:02:17 - Cisco Systems, Inc.
0537 - 00:02:18 - Advanced Scientific Corp
0538 - 00:02:19 - Paralon Technologies
0539 - 00:02:1a - Zuma Networks
0540 - 00:02:1b - Kollmorgen-servotronix
0541 - 00:02:1c - Network Elements, Inc.
0542 - 00:02:1d - Data General Communication Ltd.
0543 - 00:02:1e - Simtel S.r.l.
0544 - 00:02:1f - Aculab Plc
0545 - 00:02:20 - Canon Aptex, Inc.
0546 - 00:02:21 - Dsp Application, Ltd.
0547 - 00:02:22 - Chromisys, Inc.
0548 - 00:02:23 - Clicktv
0549 - 00:02:24 - C-cor
0550 - 00:02:25 - One Stop Systems
0551 - 00:02:26 - Xesystems, Inc.
0552 - 00:02:27 - Esd Electronic System Design Gmbh
0553 - 00:02:28 - Necsom, Ltd.
0554 - 00:02:29 - Adtec Corporation
0555 - 00:02:2a - Asound Electronic
0556 - 00:02:2b - Saxa, Inc.

