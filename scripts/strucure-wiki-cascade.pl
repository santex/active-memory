#!/usr/bin/perl -X
use strict;
use warnings;
use JSON::XS;
use Data::Dumper;
use AI::MicroStructure;
use AI::MicroStructure::Ontology;
use AI::MicroStructure::Fitnes;
use AI::MicroStructure::Categorizer;
use AI::MicroStructure::Memorizer;
use AI::MicroStructure::Tree;
use AI::MicroStructure::Collection;
use IOMicroy;


use Digest::MD5 qw(md5 md5_hex md5_base64);
use Cache::Memcached;
use strict;
use threads qw[ yield ];
use threads::shared;
use Thread::Queue;
use AI::MicroStructure;
use Data::Dumper;
use Time::HiRes qw[ sleep ];
use constant NTHREADS => 5;
    our $cache = new Cache::Memcached {
'servers' => [ "127.0.0.1:11211"],
'debug' => 0,
'compress_threshold' => 10_000,
} or warn($@);
our  $dir = sprintf("%s/myperl/test/txt/ok/","/home/hagen");


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
  my @symbols = ();
  my $symbols = AI::MicroStructure->getBundle();


foreach my $cat(keys %$symbols){

  push @symbols,$cat;
  foreach my $elem (@{$symbols->{$cat}}){

  push @symbols,$elem;
  }

}

@symbols = reverse @symbols;
#die $#symbols;






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



@ARGV=("user",
      "pass",
      "localhost");

my $configure = (
{
  user=>$ARGV[0],
  pass=>$ARGV[1],
  dbfile=>sprintf("%s/active-memory/berkeley.dat",$ENV{HOME}),
  couchhost=>$ARGV[2],
  cachhost=>"localhost",
  cachhost=>"localhost",
  categories=>undef,
  couchport=>5984,
  couchdbname=>"wikilist",
  cacheport=>22922,
  uri=>"",
  home=>$ENV{HOME},

});

$configure->{bookpath}=sprintf("%s/active-memory/test/txt/ok",
                                $configure->{home});

$configure->{uri} =
    sprintf("http://%s:%s\@%s:%s/",
        $configure->{user},
        $configure->{pass},
        $configure->{couchhost},
        $configure->{couchport});


my $memo   = AI::MicroStructure::Memorizer->new(bookpath=>$configure->{bookpath});
my $driver = AI::MicroStructure::Driver->new($configure)->{driver};

#my $fitnes = AI::MicroStructure::Fitnes->new($configure);
my $ontlgy = AI::MicroStructure::Ontology->new($configure);
my $cat    = AI::MicroStructure::Categorizer->new(bookpath=>$configure->{bookpath});


my $x = AI::MicroStructure->new(
"AI::MicroStructure::Driver"      =>  $driver,
"AI::MicroStructure::Ontology"    =>  $ontlgy,
#"AI::MicroStructure::Fitnes"      =>  $fitnes,
"AI::MicroStructure::Memorizer"   =>  $memo,
"AI::MicroStructure::Categorizer" =>  $cat,
);


#print Dumper $driver;




my $files=decode_json($driver->{couch}->getList("ISS_"));
my $set = {};
foreach(@{$files->{rows}}){

  my @r = @{$_->{value}};
  print 1;
  foreach my $link (@r) {

    $set->{$link}=1;

  }


}
@symbols = keys %$set;

my $pos :shared = 0;


my $size = $#symbols;

print $size;

sub thread {
    my $Q = shift;
    my $tid = threads->tid;
    while( my $line = $Q->dequeue ) {

        printf "%3d: (%10d of %10d) :%s\n", $tid, $pos, $size, $line;
        if(!$cache->get(md5_hex($line))){
        system("perl ./wiki.pl $line &");
        $cache->set(md5_hex($line),"done");
        }

#        continue;
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
