#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper;
use AI::MicroStructure;
use AI::MicroStructure::Ontology;
use AI::MicroStructure::Fitnes;
use AI::MicroStructure::Categorizer;
#use AI::MicroStructure::Memorizer;
use AI::MicroStructure::Tree;
use AI::MicroStructure::Collection;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Cache::Memcached;
use strict;
use threads qw[ yield ];
use threads::shared;
use Thread::Queue;
use Time::HiRes qw[ sleep ];
use constant NTHREADS => 5;

my @symbols =  @ARGV;







sub trim
{

	my $string = shift;
  $string =  "" unless  $string;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	$string =~ s/\t//;
	$string =~ s/^\s//;
	return $string;
}

  
#



my $pos :shared = 0;


my $size = $#symbols;


sub thread {
    my $Q = shift;
    my $tid = threads->tid;
    while( my $line = $Q->dequeue ) {
 #       my @set = @$line;
        my @symbols =map{$_=trim($_)}split(",",`micro-wnet $line`);
        print $#symbols,$line;
      # print `perl /home/hagen/myperl/AI-MicroStructure-0.01/scripts/wiki.pl $line &`;
    }
}

my $Q = Thread::Queue->new;
my @threads = map threads->create( \&thread, $Q ), 1 .. NTHREADS;

foreach(@symbols) {
    sleep 0.001 while $Q->pending;
  #  for( 1 .. $#symbols ) {
        $Q->enqueue($_);
        lock $pos;
        $pos++;
   # }
}

$Q->enqueue( (undef) x NTHREADS );
$_->join for @threads;

1;
