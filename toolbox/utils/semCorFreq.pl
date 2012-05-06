#! /usr/local/bin/perl -w
#
# semCorFreq.pl version 1.01
# (Last updated $Id: semCorFreq.pl,v 1.7 2005/12/11 22:37:02 sidz1979 Exp $)
#
# A helper tool perl program for WordNet::Similarity. This 
# program is used to generate the frequency count data
# files (information content files) which are used by the 
# Jiang Conrath, Resnik and Lin measures to calculate the
# information content of synsets in WordNet.
#
# This program is used to generate the frequency count data 
# files which are used by the Jiang Conrath, Resnik and Lin 
# measures to calculate the information content of a synset in 
# WordNet. The output is generated in a format as required by
# the WordNet::Similarity modules for computing semantic
# relatedness.
#
# Copyright (c) 2005,
#
# Ted Pedersen, University of Minnesota, Duluth
# tpederse at d.umn.edu
#
# Siddharth Patwardhan, University of Utah, Salt Lake City
# sidd at cs.utah.edu
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to 
#
# The Free Software Foundation, Inc., 
# 59 Temple Place - Suite 330, 
# Boston, MA  02111-1307, USA.
#
# -----------------------------------------------------------------

# Include the QueryData package.
use WordNet::QueryData;

# Include library to get Command-Line options.
use Getopt::Long;

# Global Variable declaration.
my $wn;
my $wnPCPath;
my $wnUnixPath;
my $totalCount;
my $offset;
my $fname;
my $unknownSmooth;
my @line;
my %offsetMnem;
my %mnemFreq;
my %offsetFreq;
my %newFreq;
my %posMap;
my %topHash;

# Get Command-Line options.
&GetOptions("help", "version", "wnpath=s", "outfile=s", "smooth=s");

# Check if help has been requested ... If so ... display help.
if(defined $opt_help)
{
    $opt_help = 1;
    &showHelp;
    exit;
}

# Check if version number has been requested ... If so ... display version.
if(defined $opt_version)
{
    $opt_version = 1;
    &showVersion;
    exit;
}

# Check if path to WordNet Data files has been provided ... If so ... save it.
if(defined $opt_wnpath)
{
    $wnPCPath = $opt_wnpath;
    $wnUnixPath = $opt_wnpath;
}
elsif (defined $ENV{WNSEARCHDIR})
{
    $wnPCPath = $ENV{WNSEARCHDIR};
    $wnUnixPath = $ENV{WNSEARCHDIR};
}
elsif (defined $ENV{WNHOME})
{
    $wnPCPath = $ENV{WNHOME} . "\\dict";
    $wnUnixPath = $ENV{WNHOME} . "/dict";
}
else
{
    $wnPCPath = "C:\\Program Files\\WordNet\\2.1\\dict";
    $wnUnixPath = "/usr/local/WordNet-2.1/dict";
}


if(defined $opt_outfile)
{
    $fname = $opt_outfile;
}
else
{
    &showUsage;
    print "Type 'semCorFreq.pl --help' for detailed help.\n";
    exit;
}

# Initialize POS Map.
$posMap{"1"} = "n";
$posMap{"2"} = "v";


# Get a WordNet::QueryData object...
print STDERR "Loading WordNet ... ";
$wn = ((defined $opt_wnpath) ? (WordNet::QueryData->new($opt_wnpath)) : (WordNet::QueryData->new()));
if(!$wn)
{
    print STDERR "\nUnable to create WordNet object.\n";
    exit;
}
$wnPCPath = $wnUnixPath = $wn->dataPath() if($wn->can('dataPath'));
print STDERR "done.\n";


# Loading the Sense Indices.
print STDERR "Loading sense indices ... ";
open(IDX, $wnUnixPath."/index.sense") || open(IDX, $wnPCPath."\\sense.idx") || die "Unable to open sense index file.\n";
while(<IDX>)
{
    chomp;
    @line = split / +/;
    if($line[0] =~ /%([12]):/)
    {
	$posHere = $1;
	$line[1] =~ s/^0*//;
	push @{$offsetMnem{$line[1].$posMap{$posHere}}}, $line[0];
    }
}
close(IDX);
print STDERR "done.\n";


# Loading the frequency counts from 'cntlist'.
print STDERR "Loading cntlist ... ";
open(CNT, $wnUnixPath."/cntlist") || open(CNT, $wnPCPath."\\cntlist") || die "Unable to open cntlist.\n";
while(<CNT>)
{
    chomp;
    @line = split / /;
    if($line[1] =~ /%[12]:/)
    {
	$mnemFreq{$line[1]}=$line[0];
    }
}
close(CNT);
print STDERR "done.\n";


# Mapping the frequency counts to offsets...
print STDERR "Mapping offsets to frequencies ... ";
$unknownSmooth = 0;
foreach $tPos ("noun", "verb")
{
    my $xPos = $tPos;
    $xPos =~ s/(^[nv]).*/$1/;
    open(DATA, $wnUnixPath."/data.$tPos") || open(DATA, $wnPCPath."\\$tPos.dat") || die "Unable to open data file.\n";
    foreach(1 .. 29)
    {
	$line=<DATA>;
    }
    while($line=<DATA>)
    {
	$line =~ /^([0-9]+)\s+/;
	$offset = $1;
	$offset =~ s/^0*//;
	if(exists $offsetMnem{$offset."$xPos"})
	{
	    foreach $mnem (@{$offsetMnem{$offset."$xPos"}})
	    {
		if($offsetFreq{"$xPos"}{$offset})
		{
		    $offsetFreq{"$xPos"}{$offset} += ($mnemFreq{$mnem}) ? $mnemFreq{$mnem} : 0;
		}
		else
		{
		    # [old]
		    # Using initial value of 1 for add-1 smoothing. (added 06/22/2002)
		    # $offsetFreq{$offset} = ($mnemFreq{$mnem}) ? $mnemFreq{$mnem} : 0;
		    # [/old]
		    # No more add-1 (09/13/2002)
		    # Option for add-1 ! (05/01/2003)
		    $offsetFreq{"$xPos"}{$offset} = ($mnemFreq{$mnem}) ? $mnemFreq{$mnem} : 0;
		    if(defined $opt_smooth)
		    {
			if($opt_smooth eq 'ADD1')
			{
			    $offsetFreq{"$xPos"}{$offset}++;
			}
			else
			{
			    $unknownSmooth = 1;
			}
		    }
		}
	    }
	}
	else
	{
	    # Code added for Add-1 smoothing (06/22/2002)
	    # Code changed... no more add-1 (09/13/2002)
	    # Code changed... option for add-1 (05/01/2003)
	    $offsetFreq{"$xPos"}{$offset} = 0;
	    if(defined $opt_smooth)
	    {
		if($opt_smooth eq 'ADD1')
		{
		    $offsetFreq{"$xPos"}{$offset}++;
		}
		else
		{
		    $unknownSmooth = 1;
		}
	    }
	}
    }
    close(DATA);
}
print STDERR "done.\n";
print "Unknown smoothing scheme '$opt_smooth'.\nContinuing without smoothing.\n" if($unknownSmooth);


# Removing unwanted data structures...
print STDERR "Cleaning junk from memory ... ";
undef %offsetMnem;
undef %mnemFreq;
print STDERR "done.\n";


# Determine the topmost nodes of all hierarchies...
print STDERR "Determining topmost nodes of all hierarchies ... ";
&createTopHash();
print STDERR "done.\n";


# Propagate the frequencies up...
print STDERR "Propagating frequencies up through WordNet ... ";
$offsetFreq{"n"}{0} = 0;
$offsetFreq{"v"}{0} = 0;
&updateFrequency(0, "n");
&updateFrequency(0, "v");
delete $newFreq{"n"}{0};
delete $newFreq{"v"}{0};
print STDERR "done.\n";


# Write out the information content file...
print STDERR "Writing infocontent file ... ";
open(DATA, ">$fname") || die "Unable to open data file for writing.\n";
print DATA "wnver::".$wn->version()."\n";
foreach $offset (sort {$a <=> $b} keys %{$newFreq{"n"}})
{
    print DATA $offset."n ".$newFreq{"n"}{$offset};
    print DATA " ROOT" if($topHash{"n"}{$offset});
    print DATA "\n";
}
foreach $offset (sort {$a <=> $b} keys %{$newFreq{"v"}})
{
    print DATA $offset."v ".$newFreq{"v"}{$offset};
    print DATA " ROOT" if($topHash{"v"}{$offset});
    print DATA "\n";
}
close(DATA);
print STDERR "done.\n";
print STDERR "Wrote file '$fname'.\n";


# ---------------------- Subroutines start here -------------------------

# Recursive subroutine that calculates the cumulative frequencies
# of all synsets in WordNet.
# INPUT PARAMS  : $offset  .. Offset of the synset to update.
# RETRUN VALUES : $freq    .. The cumulative frequency calculated for 
#                             the node.
sub updateFrequency
{
    my $node;
    my $pos;
    my $sum;
    my $retValue;
    my $hyponym;
    my @hyponyms;

    $node = shift;
    $pos = shift;
    if($newFreq{$pos}{$node})
    {
	return $newFreq{$pos}{$node};
    }
    $retValue = &getHyponymOffsets($node, $pos);
    if($retValue)
    {
	@hyponyms = @{$retValue};
    }
    else
    {
	$newFreq{$pos}{$node} = $offsetFreq{$pos}{$node};
	return $offsetFreq{$pos}{$node};
    }
    $sum = 0;
    if($#{$retValue} >= 0)
    {
	foreach $hyponym (@hyponyms)
	{
	    $sum += &updateFrequency($hyponym, $pos);
	}
    }
    $newFreq{$pos}{$node} = $offsetFreq{$pos}{$node} + $sum;
    return $offsetFreq{$pos}{$node} + $sum;
}


# Creates and loads the topmost nodes hash.
sub createTopHash
{
    my $word;
    my $wps;
    my $upper;
    my $fileIsGood;
    my %wpsOffset;

    undef %wpsOffset;
    foreach $word ($wn->listAllWords("n"))
    {
	foreach $wps ($wn->querySense($word."\#n"))
	{
	    if(!$wpsOffset{$wn->offset($wps)})
	    {
		($upper) = $wn->querySense($wps, "hypes");
		if(!$upper)
		{
		    $topHash{"n"}{$wn->offset($wps)} = 1;	
		}
		$wpsOffset{$wn->offset($wps)} = 1;
	    }
	}
    }
    undef %wpsOffset;
    foreach $word ($wn->listAllWords("v"))
    {
	foreach $wps ($wn->querySense($word."\#v"))
	{
	    if(!$wpsOffset{$wn->offset($wps)})
	    {
		($upper) = $wn->querySense($wps, "hypes");
		if(!$upper)
		{
		    $topHash{"v"}{$wn->offset($wps)} = 1;
		}
		$wpsOffset{$wn->offset($wps)} = 1;
	    }
	}
    }
}


# Subroutine that returns the hyponyms of a given synset.
# INPUT PARAMS  : $offset  .. Offset of the given synset.
# RETURN PARAMS : @offsets .. Offsets of the hyponyms of $offset. 
sub getHyponymOffsets
{
    my $offset;
    my $wordForm;
    my $hyponym;
    my @hyponyms;
    my @retVal;

    $offset = shift;
    $pos = shift;
    if($offset == 0)
    {
	@retVal = keys %{$topHash{$pos}};
	return [@retVal];
    }
    $wordForm = $wn->getSense($offset, $pos);
    @hyponyms = $wn->querySense($wordForm, "hypos");
    if(!@hyponyms || $#hyponyms < 0)
    {
	return undef;
    }
    @retVal = ();
    foreach $hyponym (@hyponyms)
    {
	$offset = $wn->offset($hyponym);
	push @retVal, $offset;
    }
    return [@retVal];
}


# Subroutine to display Usage
sub showUsage
{
    print "Usage: semCorFreq.pl [{ --outfile FILE [--wnpath PATH] [--smooth SCHEME] | --help | --version }]\n";
}


# Subroutine to show detailed help.
sub showHelp
{
    &showUsage;
    print "\nA helper tool Perl program for WordNet::Similarity.\n";
    print "This program is used to generate the frequency count data\n";
    print "files which are used by the Jiang Conrath, Resnik and Lin\n";
    print "measures to calculate the information content of synsets in\n";
    print "WordNet.\n";
    print "\nOptions:\n";
    print "--outfile     Name of the output file (FILE) to write out the\n";
    print "              information content data to.\n";
    print "--wnpath      Option to specify the path to the WordNet data\n";
    print "              files as PATH.\n";
    print "--smooth      Specifies the smoothing to be used on the\n"; 
    print "              probabilities computed. SCHEME specifies the type\n";
    print "              of smoothing to perform. It is a string, which can be\n";
    print "              only be 'ADD1' as of now. Other smoothing schemes\n";
    print "              will be added in future releases.\n";
    print "--help        Displays this help screen.\n";
    print "--version     Displays version information.\n";
}


# Subroutine to display version information.
sub showVersion
{
    print "semCorFreq.pl version 1.01\n";
    print "Copyright (c) 2005, Ted Pedersen and Siddharth Patwardhan.\n";
}

__END__

=head1 NAME

semCorFreq.pl

=head1 SYNOPSIS

semCorFreq.pl [{ --outfile FILE [--wnpath PATH] [--smooth SCHEME] | --help | --version }]

=head1 OPTIONS

B<--outfile>=I<filename>

    The name of a file to which output should be written

B<--wnpath>=I<path>

    Location of the WordNet data files (e.g.,
    /usr/local/WordNet-2.1/dict)

B<--smooth>=I<SCHEME>

    Smoothing should used on the probabilities computed.  SCHEME can
    only be ADD1 at this time

B<--help>

    Show a help message

B<--version>

    Display version information

=cut
