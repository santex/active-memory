#! /usr/local/bin/perl -X
#
use strict;
use Getopt::Long;

# Declarations!
our ($opt_version, $opt_help);
my (@parts, %hash);

# Get the options!
&GetOptions("version", "help");

# If the version information has been requested...
if(defined $opt_version)
{
    $opt_version = 1;     # Hack to prevent "Single occurrence of variable" warning.
    &printVersion();
    exit;
}

# If detailed help has been requested...
if(defined $opt_help)
{
    $opt_help = 1;        # Hack to prevent "Single occurrence of variable" warning.
    &printHelp();
    exit;
}

while(<DATA>)
{
    s/[\r\f\n]//;
    s/^\s+//;
    s/\s+$//;
    @parts = split(/\s+/);
    $hash{"$parts[0]<>$parts[1]<>"} = sprintf("%.2f", $parts[2]) if(@parts);
}

print "0\n";
my $lastRank = 1;
my $rank = 1;
my $last;
foreach my $key (sort {$hash{$b} <=> $hash{$a}} keys %hash)
{
    $lastRank = $rank if(defined $last && $hash{$key} != $last);
    print "$key$lastRank $hash{$key} 0 0 0\n";
    $rank++;
    $last = $hash{$key};
}

# ----------------- Subroutines Start Here ----------------------

# Subroutine to print detailed help
sub printHelp
{
    &printUsage();
    print "\nProgram to rank the output of similarity.pl based on the semantic\n";
    print "relatedness of the word pairs. The output is in a format that can\n";
    print "processed by the rank.pl program of the Text::NSP package. The rank.pl\n";
    print "program takes two lists of ranked pairs of words and computes the\n";
    print "correlation between them according to Spearman's correlation\n";
    print "coefficient. The input can be specified in file(s) on the command line,\n";
    print "or if no file(s) are specified, then STDIN is assumed. Output is written\n";
    print "to STDOUT.\n\n";
    print "Options: \n";
    print "--help           Displays this help screen.\n";
    print "--version        Displays version information.\n\n";
}

# Subroutine to print minimal usage notes
sub minimalUsageNotes
{
    &printUsage();
    print "Type rankFormat.pl --help for detailed help.\n";
}

# Subroutine that prints the usage
sub printUsage
{
    print "Usage: rankFormat.pl [FILE... |--help | --version]\n";
}

# Subroutine to print the version information
sub printVersion
{
    print "rankFormat.pl version 1.02\n";
    print "Copyright (c) 2006, Ted Pedersen and Siddharth Patwardhan.\n";
}

__END__

=head1 NAME

rankFormat.pl - Program to rank the output of similarity.pl.

=head1 SYNOPSIS

rankFormat.pl [FILE... | --help | --version]

=head1 DESCRIPTION

Program to rank the output of similarity.pl based on the semantic
relatedness of the word pairs. The output is in a format that can
processed by the rank.pl program of the Text::NSP package. The rank.pl
program takes two lists of ranked pairs of words and computes the
correlation between them according to Spearman's correlation
coefficient.

=head1 OPTIONS

B<--help>

    Displays a detailed usage message

B<--version>

    Displays version information.

=head1 AUTHORS

 Ted Pedersen, University of Minnesota Duluth
 tpederse at d.umn.edu

 Siddharth Patwardhan, University of Utah, Salt Lake City
 sidd at cs.utah.edu

=head1 BUGS

=head1 SEE ALSO

perl(1)

WordNet::Similarity(3)

http://wordnet.princeton.edu

http://wn-similarity.sourceforge.net

http://groups.yahoo.com/group/wn-similarity

http://ngram.sourceforge.net

=head1 COPYRIGHT

Copyright (c) 2006, Ted Pedersen and Siddharth Patwardhan

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

=cut


__DATA__
bug fixing
hacking
