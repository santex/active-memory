#! /usr/local/bin/perl -w
#
# brownFreq.pl version 1.01
# (Last updated $Id: brownFreq.pl,v 1.11 2005/12/11 22:37:02 sidz1979 Exp $)
#
# This program reads the Brown Corpus and computes the frequency counts
# for each synset in WordNet. These frequency counts are used by 
# various measures of semantic relatedness to calculate the information 
# content values of concepts. The output is generated in a format as 
# required by the WordNet::Similarity modules for computing semantic 
# relatedness.
#
# Copyright (c) 2005
#
# Ted Pedersen, University of Minnesota, Duluth
# tpederse at d.umn.edu
#
# Satanjeev Banerjee, Carnegie Mellon University, Pittsburgh
# banerjee+ at cs.cmu.edu
#
# Siddharth Patwardhan, University of Utah, Salt Lake City
# sidd at cs.utah.edu
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#
# -----------------------------------------------------------------------------

# Variable declarations
my $wn;
my $wnver;
my $line;
my $sentence;
my @parts;
my %compounds;
my %stopWords;
my %offsetFreq;
my %newFreq;
my %topHash;

# Some modules used
use Getopt::Long;
use WordNet::QueryData;

# First check if no commandline options have been provided... in which case
# print out the usage notes!
if ( $#ARGV == -1 )
{
    &minimalUsageNotes();
    exit;
}

# Now get the options!
&GetOptions("version", "help", "compfile=s", "stopfile=s", "outfile=s", "wnpath=s", "resnik", "smooth=s");

# If the version information has been requested
if(defined $opt_version)
{
    $opt_version = 1;
    &printVersion();
    exit;
}

# If detailed help has been requested
if(defined $opt_help)
{
    $opt_help = 1;
    &printHelp();
    exit;
}

# Look for the Compounds file... exit if not specified.
if(!defined $opt_compfile)
{
    &minimalUsageNotes();
    exit;
}

if(defined $opt_outfile)
{
    $outfile = $opt_outfile;
}
else
{
    &minimalUsageNotes();
    exit;
}

# Get the path to WordNet...
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

# Load the compounds
print STDERR "Loading compounds... ";
open (WORDS, "$opt_compfile") || die ("Couldnt open $opt_compfile.\n");
while (<WORDS>)
{
    s/[\r\f\n]//g;
    $compounds{$_} = 1;
}
close WORDS;
print STDERR "done.\n";

# Load the stop words if specified
if(defined $opt_stopfile)
{
    print STDERR "Loading stoplist... ";
    open (WORDS, "$opt_stopfile") || die ("Couldnt open $opt_stopfile.\n");
    while (<WORDS>)
    {
	s/[\r\f\n]//g;
	$stopWords{$_} = 1;
    }
    close WORDS;
    print STDERR "done.\n";
}

# Load up WordNet
print STDERR "Loading WordNet... ";
$wn=(defined $opt_wnpath)? (WordNet::QueryData->new($opt_wnpath)):(WordNet::QueryData->new());
die "Unable to create WordNet object.\n" if(!$wn);
$wnPCPath = $wnUnixPath = $wn->dataPath() if($wn->can('dataPath'));
print STDERR "done.\n";

# Load the topmost nodes of the hierarchies
print STDERR "Loading topmost nodes of the hierarchies... ";
&createTopHash();
print STDERR "done.\n";

# Read the input, form sentences and process each
print STDERR "Computing frequencies... ";
$sentence = "";
while($line=<>)
{
    $line=~s/[\r\f\n]//g;
    $line=~s/^[A-Z]+[0-9]+ [0-9]+ //;
    @parts = split(/[.?!]/, $line);
    foreach (1..$#parts)
    {
	$sentence .= shift(@parts)." ";
	&process($sentence);
	$sentence = "";
    }
    $sentence .= shift(@parts)." " if(@parts);
}
&process($sentence);
print STDERR "done.\n";

# Hack to prevent warning...
$opt_resnik = 1 if(defined $opt_resnik);

# Smoothing!
if(defined $opt_smooth)
{
    print STDERR "Smoothing... ";
    if($opt_smooth eq 'ADD1')
    {
	foreach $pos ("noun", "verb")
	{
	    my $localpos = $pos;

	    if(!open(IDX, $wnUnixPath."/data.$pos"))
	    {
		if(!open(IDX, $wnPCPath."/$pos.dat"))
		{
		    print STDERR "Unable to open WordNet data files.\n";
		    exit;
		}
	    }
	    $localpos =~ s/(^[nv]).*/$1/;
	    while(<IDX>)
	    {
		last if(/^\S/);
	    }
	    ($offset) = split(/\s+/, $_, 2);
	    $offset =~ s/^0*//;
	    $offsetFreq{$localpos}{$offset}++;
	    while(<IDX>)
	    {
		($offset) = split(/\s+/, $_, 2);
		$offset =~ s/^0*//;
		$offsetFreq{$localpos}{$offset}++;
	    }
	    close(IDX);
	}
	print STDERR "done.\n";
    }
    else
    {
	print STDERR "\nWarning: Unknown smoothing '$opt_smooth'.\n";
	print STDERR "Use --help for details.\n";
	print STDERR "Continuing without smoothing.\n";
    }
}

# Propagating frequencies up the WordNet hierarchies... 
print STDERR "Propagating frequencies up through WordNet... ";
$offsetFreq{"n"}{0} = 0;
$offsetFreq{"v"}{0} = 0;
&propagateFrequency(0, "n");
&propagateFrequency(0, "v");
delete $newFreq{"n"}{0};
delete $newFreq{"v"}{0};
print STDERR "done.\n";

# Print the output to file
print STDERR "Writing output file... ";
open(OUT, ">$outfile") || die "Unable to open $outfile for writing.\n";
print OUT "wnver::".$wn->version()."\n";
foreach $pos ("n", "v")
{
    foreach $offset (sort {$a <=> $b} keys %{$newFreq{$pos}})
    {
	print OUT "$offset$pos $newFreq{$pos}{$offset}";
	print OUT " ROOT" if($topHash{$pos}{$offset});
	print OUT "\n";
    }
}
close(OUT);
print "done.\n";

# ----------------- Subroutines start Here ----------------------

# Processing of each sentence
# (1) Convert to lowercase
# (2) Remove all unwanted characters
# (3) Combine all consequetive occurrence of numbers into one
# (4) Remove leading and trailing spaces
# (5) Form all possible compounds in the words
# (6) Get the frequency counts
sub process
{
    my $block;
    
    $block = lc(shift);
    $block =~ s/\'//g;
    $block =~ s/[^a-z0-9]+/ /g;
    while($block =~ s/([0-9]+)\s+([0-9]+)/$1$2/g){}
    $block =~ s/^\s+//;
    $block =~ s/\s+$//;
    $block = &compoundify($block);
    while($block =~ /([\w_]+)/g)
    {
	&updateFrequency($1) if(!defined $stopWords{$1});
    }
}

# Form all possible compounds within a sentence
sub compoundify
{
    my $block;
    my $string;
    my $done;
    my $temp;
    my $firstPointer;
    my $secondPointer;
    my @wordsArray;
    
    # get the block of text
    $block = shift;
    
    # get all the words into an array
    @wordsArray = ();
    while ($block =~ /(\w+)/g)
    {
	push @wordsArray, $1;
    }
    
    # now compoundify, GREEDILY!!
    $firstPointer = 0;
    $string = "";
    
    while($firstPointer <= $#wordsArray)
    {
	$secondPointer = (($firstPointer + 5 < $#wordsArray)?($firstPointer + 5):($#wordsArray));
	$done = 0;
	while($secondPointer > $firstPointer && !$done)
	{
	    $temp = join ("_", @wordsArray[$firstPointer..$secondPointer]);
	    if(exists $compounds{$temp})
	    {
		$string .= "$temp "; 
		$done = 1;
	    }
	    else 
	    { 
		$secondPointer--; 
	    }
	}
	if(!$done) 
	{ 
	    $string .= "$wordsArray[$firstPointer] "; 
	}
	$firstPointer = $secondPointer + 1;
    }
    $string =~ s/ $//;
    
    return $string;    
}

# Subroutine to update frequency tokens on "seeing" a 
# word in text
sub updateFrequency
{
    my $word;
    my $pos;
    my $form;
    my @senses;
    my @forms;

    $word = shift;
    foreach $pos ("n", "v")
    {
	@forms = $wn->validForms($word."\#".$pos);
	foreach $form (@forms)
	{
	    push @senses, $wn->querySense($form);
	}
	foreach (@senses)
	{
	    if(defined $opt_resnik)
	    {
		$offsetFreq{$pos}{$wn->offset($_)} += (1/($#senses + 1));
	    }
	    else
	    {
		$offsetFreq{$pos}{$wn->offset($_)}++;
	    }
	}
    }
}

# Recursive subroutine that propagates the frequencies up
# the WordNet hierarchy
sub propagateFrequency
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
	$newFreq{$pos}{$node} = ($offsetFreq{$pos}{$node})?$offsetFreq{$pos}{$node}:0;
	return ($offsetFreq{$pos}{$node})?$offsetFreq{$pos}{$node}:0;
    }
    $sum = 0;
    if($#{$retValue} >= 0)
    {
	foreach $hyponym (@hyponyms)
	{
	    $sum += &propagateFrequency($hyponym, $pos);
	}
    }
    $newFreq{$pos}{$node} = (($offsetFreq{$pos}{$node})?$offsetFreq{$pos}{$node}:0) + $sum;
    return (($offsetFreq{$pos}{$node})?$offsetFreq{$pos}{$node}:0) + $sum;
}

# Subroutine that returns the hyponyms of a given synset.
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

# Subroutine to print detailed help
sub printHelp
{
    &printUsage();
    print "\nThis program computes the information content of concepts, by\n";
    print "counting the frequency of their occurrence in the Brown Corpus.\n";
    print "Options: \n";
    print "--compfile       Used to specify the file COMPFILE containing the \n";
    print "                 list of compounds in WordNet.\n";
    print "--outfile        Specifies the output file OUTFILE.\n";
    print "--stopfile       STOPFILE is a list of stop listed words that will\n";
    print "                 not be considered in the frequency count.\n";
    print "--wnpath         Option to specify WNPATH as the location of WordNet data\n";
    print "                 files. If this option is not specified, the program tries\n";
    print "                 to determine the path to the WordNet data files using the\n";
    print "                 WNHOME environment variable.\n";
    print "--resnik         Option to specify that the frequency counting should\n";
    print "                 be performed according to the method described by\n";
    print "                 Resnik (1995).\n";
    print "--smooth         Specifies the smoothing to be used on the probabilities\n"; 
    print "                 computed. SCHEME specifies the type of smoothing to\n";
    print "                 perform. It is a string, which can be only be 'ADD1'\n";
    print "                 as of now. Other smoothing schemes will be added in\n";
    print "                 future releases.\n";
    print "--help           Displays this help screen.\n";
    print "--version        Displays version information.\n\n";
}

# Subroutine to print minimal usage notes
sub minimalUsageNotes
{
    &printUsage();
    print "Type brownFreq.pl --help for detailed help.\n";
}

# Subroutine that prints the usage
sub printUsage
{
    print "brownFreq.pl [{--compfile COMPFILE --outfile OUTFILE [--stopfile STOPFILE]";
    print " [--wnpath WNPATH] [--resnik] [--smooth SCHEME] [FILE...] | --help | --version }]\n"
}

# Subroutine to print the version information
sub printVersion
{
    print "brownFreq.pl version 1.01\n";
    print "Copyright (c) 2005, Ted Pedersen, Satanjeev Banerjee and Siddharth Patwardhan.\n";
}

__END__

=head1 NAME

brownFreq.pl

=head1 SYNOPSIS

brownFreq.pl [--compfile=COMPFILE --outfile=OUTFILE [--stopfile=STOPFILE] 
 [--wnpath=WNPATH] [--resnik] [--smooth=SCHEME] FILES | --help --version]

=head1 OPTIONS

B<--compfile>=I<filename>

    The name of a file containing the compound words (collocations) in
    WordNet

B<--outfile>=I<filename>

    The name of a file to which output should be written

B<--stopfile>=I<filename>

    A file containing a list of stop listed words that will not be
    considered in the frequency counts.  A sample file can be down-
    loaded from
    http://www.d.umn.edu/~tpederse/Group01/WordNet/words.txt

B<--wnpath>=I<path>

    Location of the WordNet data files (e.g.,
    /usr/local/WordNet-2.1/dict)

B<--resnik>

    Use Resnik (1995) frequency counting

B<--smooth>=I<SCHEME>

    Smoothing should used on the probabilities computed.  SCHEME can
    only be ADD1 at this time

B<--help>

    Show a help message

B<--version>

    Display version information

B<FILES>

    Files for the Brown Corpus (e.g., /home/sid/Brown/BROWN1/*.TXT).

=cut
