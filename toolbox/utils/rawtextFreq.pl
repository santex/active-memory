#! /usr/local/bin/perl -w
#

use strict;
use File::Find;

# Variable declarations
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
if ($#ARGV == -1)
{
    &minimalUsageNotes();
    exit 1;
}

our @opt_infiles;
our ($opt_version, $opt_help, $opt_compfile, $opt_stopfile, $opt_outfile);
our ($opt_wnpath, $opt_resnik, $opt_smooth, $opt_stdin);

# Now get the options!
my $ok = GetOptions("version", "help", "compfile=s", "stopfile=s", "outfile=s",
		    "wnpath=s", "resnik", "smooth=s", "stdin",
		    "infile=s" => \@opt_infiles);

# GetOptions should have already printed out a detail error message if
# $ok is false
$ok or die "Error getting command-line arguments\n";

# If the version information has been requested
if(defined $opt_version)
{
    $opt_version = 1;
    &printVersion();
    exit 0;
}

# If detailed help has been requested
if(defined $opt_help)
{
    $opt_help = 1;
    &printHelp();
    exit 0;
}

# Look for the Compounds file... exit if not specified.
if(!defined $opt_compfile)
{
    &minimalUsageNotes();
    exit 1;
}

# make sure either --stdin or --infile was given
unless ($opt_stdin or scalar @opt_infiles) {
    minimalUsageNotes ();
    exit 1;
}

# make sure that both --stdin and --infile were NOT given
if ($opt_stdin and scalar @opt_infiles) {
    minimalUsageNotes ();
    exit 1;
}

my $outfile;
if(defined $opt_outfile)
{
    $outfile = $opt_outfile;
}
else
{
    &minimalUsageNotes();
    exit 1;
}

# Load the compounds
print STDERR "Loading compounds... ";
open (WORDS, '<', "$opt_compfile") or die ("Couldn't open $opt_compfile.\n");
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
    open (WORDS, '<', "$opt_stopfile") or die "Couldn't open $opt_stopfile.\n";
    while (<WORDS>)
    {
	s/[\r\f\n]//g;
	$stopWords{$_} = 1;
    }
    close WORDS;
    print STDERR "done.\n";
}

my ($wnPCPath, $wnUnixPath);

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

# Load up WordNet
print STDERR "Loading WordNet... ";
my $wn = (defined $opt_wnpath)
         ? (WordNet::QueryData->new($opt_wnpath))
         : (WordNet::QueryData->new());
die "Unable to create WordNet object.\n" if(!$wn);
$wnPCPath = $wnUnixPath = $wn->dataPath() if(defined $wn->can('dataPath'));
print STDERR "done.\n";

# Load the topmost nodes of the hierarchies
print STDERR "Loading topmost nodes of the hierarchies... ";
&createTopHash();
print STDERR "done.\n";

# Read the input, form sentences and process each
#  We need to process each sentence (or clause really) at the same time.
#  This is because process() tries to find compounds in the sentence.  It is
#  not sufficient to process a line at a time because a sentence often
#  spans more than one line; therefore, a compound could also span a line
#  break (for example, the first word of a compound could be the last word
#  on a line, and the second word of the compound could be the first word
#  on the next line).
my $sentence = "";
# check if we're reading from a file or from STDIN
if (scalar @opt_infiles) {

    # first we have to figure out what files to process.  The files
    # are specified with in --infile option.  The value of the option
    # can be a filename, a directory, or a pattern (as understood by
    # Perl's glob() function).
    my @infiles = getFiles (@opt_infiles);

    print STDERR "Computing frequencies.\n";
    foreach my $i (0..$#infiles) {
	my $infile = $infiles[$i];

	print STDERR ("  Processing '$infile' (", $i + 1, "/",
		      $#infiles + 1, " files)... ");
	
	open (IFH, '<', $infile) or die "Cannot open file '$infile': $!";
	while (my $line = <IFH>)
	{
	    $line =~ s/[\r\f\n]//g;
	    my @parts = split (/[.?!,;:]/, $line);
	    foreach (1..$#parts)
	    {
		$sentence .= shift(@parts)." ";
		process ($sentence);
		$sentence = "";
	    }
	    $sentence .= shift(@parts)." " if(@parts);
	}
	process ($sentence);
	close IFH or die "Cannot not close file '$infile': $!";
	print STDERR "  done.\n";
    }
}
else {
    print STDERR "Computing frequencies... ";
    while (my $line = <STDIN>)
    {
	$line =~ s/[\r\f\n]//g;
	my @parts = split (/[.?!,;:]/, $line);
	foreach (1..$#parts)
	{
	    $sentence .= shift (@parts) . " ";
	    process ($sentence);
	    $sentence = "";
	}
	$sentence .= shift (@parts) . " " if @parts;
    }
    process ($sentence);
}
print STDERR "done.\n";

# Hack to prevent warning...
$opt_resnik = 1 if defined $opt_resnik;

# Smoothing!
if(defined $opt_smooth)
{
    print STDERR "Smoothing... ";
    if($opt_smooth eq 'ADD1')
    {
	foreach my $pos ("noun", "verb")
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
	    my ($offset) = split(/\s+/, $_, 2);
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
open(OUT, ">$outfile") || die "Unable to open $outfile for writing: $!\n";
print OUT "wnver::".$wn->version()."\n";
foreach my $pos ("n", "v")
{
    foreach my $offset (sort {$a <=> $b} keys %{$newFreq{$pos}})
    {
	print OUT "$offset$pos $newFreq{$pos}{$offset}";
	print OUT " ROOT" if($topHash{$pos}{$offset});
	print OUT "\n";
    }
}
close(OUT);
print STDERR "done.\n";


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
    my $block = shift; # get the block of text
    my $done;
    my $temp;
    my $secondPointer;

    # get all the words into an array
    my @wordsArray = $block =~ /(\w+)/g;

    # now compoundify, GREEDILY!!
    my $firstPointer = 0;
    my $string = "";

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
	$newFreq{$pos}{$node} = $offsetFreq{$pos}{$node}
	                        ? $offsetFreq{$pos}{$node}
                                : 0;

	return $offsetFreq{$pos}{$node}
	       ? $offsetFreq{$pos}{$node}
               : 0;
    }
    $sum = 0;
    if($#{$retValue} >= 0)
    {
	foreach $hyponym (@hyponyms)
	{
	    $sum += &propagateFrequency($hyponym, $pos);
	}
    }
    $newFreq{$pos}{$node} = ($offsetFreq{$pos}{$node}
			     ? $offsetFreq{$pos}{$node}
			     : 0) + $sum;

    return ($offsetFreq{$pos}{$node}
	    ? $offsetFreq{$pos}{$node}
	    : 0) + $sum;
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
    my $pos = shift;
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
    my $datapath = $wn->dataPath;
    my $unixfile_n = "${datapath}/data.noun";
    my $windozefile_n = "${datapath}\\noun.dat";

    my $nounfile = -e $windozefile_n ? $windozefile_n : $unixfile_n;

    open (NFH, '<', $nounfile) or die "Cannot open '$nounfile': $!";

    while (<NFH>) {
        next if "  " eq substr $_, 0, 2;
	next if / \@ \d\d\d\d\d\d\d\d /;
	next unless /^(\d\d\d\d\d\d\d\d) /;
	my $offset = $1 + 0;

	# QueryData::getSense will die() if the $offset and pos are not
	# found.  Putting this in an eval will catch the exception.  See
	# perldoc -f eval
	my $wps;
	eval {$wps = $wn->getSense ($offset, 'n')};
	if ($@) {
	    die "(offset '$offset' not found) $@";
	}
	$topHash{n}{$offset} = 1;
    }

    close NFH;

    my $unixfile_v = "${datapath}/data.verb";
    my $windozefile_v = "${datapath}\\verb.dat";

    my $verbfile = -e $windozefile_v ? $windozefile_v : $unixfile_v;

    open (VFH, '<', $verbfile) or die "Cannot open '$verbfile': $!";

    while (<VFH>) {
        next if " " eq substr ($_, 0, 2);
	next if / \@ \d\d\d\d\d\d\d\d /;
	next unless /^(\d\d\d\d\d\d\d\d) /;
	my $offset = $1 + 0;
	$topHash{v}{$offset} = 1;
    }

    close VFH;
}

sub getFiles
{
    my @inpatterns = @_;
    my @infiles;
    # the options to pass to File::Find::find()
    my %options = (wanted =>
		   sub {
		       unless (-d $File::Find::name) {
			   push @infiles, $File::Find::name;
		       }
		   },
		   follow_fast => 1);

    foreach my $pattern (@inpatterns) {
	if (-d $pattern) {
	    find (\%options, $pattern);
	}
	elsif (-e $pattern and not -d $pattern) {
	    push @infiles, $pattern;
	}
	else {
	    my @files = glob $pattern;
	    foreach my $file (@files) {
		if (-d $file) {
		    find (\%options, $pattern);
		}
		else {
		    push @infiles, $file;
		}
	    }
	}
    }
    return @infiles;
}

# Subroutine to print detailed help
sub printHelp
{
    &printUsage();
    print "\nThis program computes the information content of concepts, by\n";
    print "counting the frequency of their occurrence in raw text.\n";
    print "Options: \n";
    print "--compfile       Used to specify the file COMPFILE containing the \n";
    print "                 list of compounds in WordNet.\n";
    print "--outfile        Specifies the output file OUTFILE.\n";
    print "--stdin          Read the input from the standard input\n";
    print "--infile         INFILE is the name of an input file\n";
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
    print "Type rawtextFreq.pl --help for detailed help.\n";
}

# Subroutine that prints the usage
sub printUsage
{
    print <<'EOT';
Usage: rawtextFreq.pl --compfile COMPFILE --outfile OUTFILE
                       {--stdin | --infile FILE [--infile FILE ...]}
                       [--stopfile FILE] [--resnik] [--wnpath PATH]
                       [--smooth SCHEME]
                      | --help | --version
EOT
}

# Subroutine to print the version information
sub printVersion
{
    print "rawtextFreq.pl version 1.01\n";
    print "Copyright (c) 2005, Ted Pedersen, Satanjeev Banerjee, Siddharth Patwardhan and Jason Michelizzi.\n";
}

__END__

=head1 NAME

rawtextFreq.pl - Perl program for finding the frequencies of words in raw text
files

=head1 SYNOPSIS

rawtextFreq.pl --compfile COMPFILE --outfile OUTFILE [--stopfile=STOPFILE]
               {--stdin | --infile FILE [--infile FILE ...]} [--wnpath WNPATH]
               [--resnik] [--smooth=SCHEME] | --help | --version

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

B<--stdin>

    Read from the standard input the text that is to be used for
    counting the frequency of words.

B<--infile>=I<PATTERN>

    The name of a raw text file to be used to count word frequencies.
    This can actually be a filename, a directory name, or a pattern (as
    understood by Perl's glob() function).  If the value is a directory
    name, then all the files in that directory and its subdirectories will
    be used.

    If you are looking for some interesting files to use, check out
    Project Gutenberg: <http://www.gutenberg.org>.

    This option may be given more than once (if more than one file
    should be used).

=head1 AUTHORS

 Ted Pedersen, University of Minnesota, Duluth
 tpederse at d.umn.edu

 Satanjeev Banerjee, Carnegie Mellon University, Pittsburgh
 banerjee+ at cs.cmu.edu

 Siddharth Patwardhan, University of Utah, Salt Lake City
 sidd at cs.utah.edu

 Jason Michelizzi, University of Minnesota, Duluth
 mich0212 at d.umn.edu

=head1 BUGS

None.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2005, Ted Pedersen, Satanjeev Banerjee, Siddharth Patwardhan and Jason Michelizzi

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to

 Free Software Foundation, Inc.
 59 Temple Place - Suite 330
 Boston, MA  02111-1307, USA

=cut
