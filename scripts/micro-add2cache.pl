#!/usr/bin/perl -W
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Cache::Memcached;
use strict;
use threads qw[ yield ];
use threads::shared;
use Thread::Queue;
use Time::HiRes qw[ sleep ];
use constant NTHREADS => 16;
    our $cache = new Cache::Memcached {
'servers' => [ "127.0.0.1:11211"],
'debug' => 0,
'compress_threshold' => 10_000,
} or warn($@);
our  $dir = sprintf("%s/active-memory/test/txt/ok/","/home/hagen");

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



sub catfile{
  my $file=shift;
     return unless($file);

      
  my $path = sprintf("%s/%s",$dir,$file);
#  print $path;
  my $cat = {};
  my @cat = map{
               my @x = split(":",$_); 
                  $_ = trim($x[1]); 
               }split("\n",
    `microdict $path | data-freq --limit 500`);
  
  $cat->{subject} = [@cat[0..10]];
  $cat->{body}    = [@cat];
  
  return $cat;
  
}



  die "$dir is not a directory" unless -d $dir;
  opendir(DIR, $dir) or die $!;
  
  my @symbols = grep { $_ = sprintf("%s",$_);  } 
              sort grep /^[\x20-\x7E]+$/,
              readdir(DIR);  
              
  closedir DIR;





my $pos :shared = 0;


my $size = $#symbols;

print $size;

sub thread {
    my $Q = shift;
    my $tid = threads->tid;
    while( my $line = $Q->dequeue ) {

        printf "%3d: (%10d of %10d) :%s\n", $tid, $pos, $size, $line;
	if(!$cache->get(md5_hex($line))){        
        	$cache->set(md5_hex($line), catfile($line));
	}        
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


