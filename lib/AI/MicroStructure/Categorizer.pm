#!/usr/bin/perl	-W

package AI::MicroStructure::Categorizer;
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use File::Spec;
use Data::Dumper;
use BerkeleyDB;
use Cache::Memcached::Fast;
use AI::MicroStructure::Remember;

require AI::Categorizer;
require AI::Categorizer::Learner::NaiveBayes;
require AI::Categorizer::Document;
require AI::Categorizer::KnowledgeSet;
require Lingua::StopWords;



sub new {
  my $this = shift;
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

sub initialize {
  my $self = shift;
  %$self=@_;
  
  $self->{cache} = new Cache::Memcached::Fast({
      servers => [ { address => 'localhost:11211',
                     weight => 2.5 }],
      namespace => 'my:',
      connect_timeout => 0.2,
      io_timeout => 0.5,
      close_on_error => 1,
      compress_threshold => 100_000,
      compress_ratio => 0.9,
      compress_methods =>
       [ \&IO::Compress::Gzip::gzip,
         \&IO::Uncompress::Gunzip::gunzip ],
      max_failures => 3,
      failure_timeout => 2,
      ketama_points => 150,
      nowait => 1,
      hash_namespace => 1,
      serialize_methods => [ \&Storable::freeze,
                             \&Storable::thaw ],
      utf8 => ($^V ge v5.8.1 ? 1 : 0),
      max_size => 4*512 * 1024,
  });



}


sub trim
{
  my $self = shift;
	my $string = shift;
  $string =  "" unless  $string;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	$string =~ s/\t//;
	$string =~ s/^\s//;
	return $string;
}


sub catfile{
  my $self = shift;
  my $path = sprintf("%s/%s",$self->{bookpath},
                     shift);
#  print $path;
  my $cat = {};
  my @cat = map{
               my @x = split(":",$_); 
                  $_ = $self->trim($x[1]); 
               }split("\n",
    `microdict $path | data-freq --limit 500`);
  
  $cat->{subject} = [@cat[0..10]];
  $cat->{body}    = [@cat];
  
  return $cat;
  
}

sub getBookList{

  my $self = shift;
  my $dir  = shift;
  
  $dir = $self->{bookpath}      unless defined($dir);
  die "$dir is not a directory" unless -d $dir;
  opendir(DIR, $dir) or die $!;
  
  my @mp3s = grep { $_ = sprintf("%s",$_);  } 
              sort grep /^[\x20-\x7E]+$/,
              readdir(DIR);  
              
  closedir DIR;

  return @mp3s;
}

sub analyseBookNames{

  my $self = shift;
  my $returns = {};
  my @books = $self->getBookList();
  my @data = ();
  my $content = {};
  my $name = "";
  my $namehex = "";
  
  foreach(@books) {
    $content = {};
    $namehex = md5_hex($_);
  
    next if($_ eq "." || $_ eq "..");

    $content = $self->{cache}->get($namehex);
    $name = sprintf("%s/%s",$self->{bookpath},$_);
  
    if(defined($content->{body})){
      
      $returns->{$namehex} = 
        {subject => $content->{subject},
         body    => $content->{body},
         name    => $name,
         md5hex  => $namehex};    
          
    }else{
    
      $content  = $self->catfile($_);
    
      $returns->{$namehex} = 
        {subject=>$content->{subject},
         body=>$content->{body},
         name=>$name,
         md5hex=>$namehex};
    
      $self->{cache}->set($namehex,$content);
      
    }
    
  }  
  

  return $returns;
  
}



sub getFeatures {

  my $self = shift;
      
  my %features = 
    (content_weights => {subject =>2,
                         body => 1},
      stopwords => Lingua::StopWords::getStopWords('en'),
      stemming => 'porter');

  
  return %features;
}


sub getTestDocs {

my $self = shift;

my  $test_set = { };
my @theme = split("\n",`perl -MAI::MicroStructure -le 'print for AI::MicroStructure->themes;'`);
foreach(@theme){
  my $name = lc $_;
  my $sub = lc `micro $name 1`;
  my $body = lc `micro $name 2`;
  $body=~ s/\n/ /g;
    $sub=~ s/\n/ /g;
      $name=~ s/_/ /g;
    $sub=~ s/_//g;
  $body=~ s/_//g;
  $test_set->{$name} = {content =>{
                            subject => $self->trim($sub),
                            body    => $self->trim($body)}};
                                      

}


  return $test_set;
}


sub training_books {

  my $self = shift;
  my $i = 0; 
  my $booklist = $self->analyseBookNames();
  my $chaps = {};
  my @keys = keys %$booklist;
  my @subject = ();
  my @body = ();
  
  foreach(@keys) {
    
    @subject = @{$booklist->{$keys[$i]}->{subject}};
    @body =    @{$booklist->{$keys[$i]}->{body}};
    
    if(@subject && @body){
      $self->{booknames}->{$i}=$booklist->{$keys[$i]}->{name};
      
      $chaps->{$i} = {subject=>join(" ",@subject),
                      body=>join(" ",@body)};
      $i++;
    }
  }
  
  return $chaps;

}

sub perform_standard_tests {

  my $self = shift;
  
  my %features = $self->getFeatures();
  my $chaps =    $self->training_books();
  my $test_set = $self->getTestDocs();


  my $docs;
  foreach my $cat(keys %$chaps) {
  $docs->{$cat} = {categories => [$cat],
	     content => {subject => $chaps->{$cat}->{subject},
		         body => $chaps->{$cat}->{body},
		        },
	    };
  }
  my $c = AI::Categorizer->new(knowledge_set => 
           AI::Categorizer::KnowledgeSet->new( name => 'CSL'),
	         verbose => 0,
	        );

  while (my ($name, $data) = each %$docs) {
    $c->knowledge_set->make_document(name => $name, %$data, %features);
  }
 
  my $learner = $c->learner;
     $learner->train;

  $learner->save_state('state');
  $learner = $learner->restore_state('state');

  my $threshold = 0.9;
  while (my ($name, $data) = each %$test_set) {
  
     my $doc = AI::Categorizer::Document->new
          (name => $name,
           content => $data->{content},
          %features);
  
     my $r = $learner->categorize($doc);
        $r->threshold($threshold);
my $b = $r->best_category;
  next unless $r->in_category($b);
    printf("\n\n[%s %s %s]\nis in category %d, with score %.3f\n%s\n%s\n",
           $name,
           $data->{content}->{subject},
           $data->{content}->{body},
           $b,
           $r->scores($b),
           $self->{booknames}->{$b},
           sprintf `microdict $self->{booknames}->{$b} | data-freq --limit 50`);

  }


}

END{
  my $self = shift;
#  untie %{$self->{microtree}};

}

1;

__DATA__

  
  new Cache::Memcached::Fast({
      servers => [ { address => 'localhost:11211',
                     weight => 2.5 }],
      namespace => 'my:',
      connect_timeout => 0.2,
      io_timeout => 0.5,
      close_on_error => 1,
      compress_threshold => 100_000,
      compress_ratio => 0.9,
      compress_methods =>
       [ \&IO::Compress::Gzip::gzip,
         \&IO::Uncompress::Gunzip::gunzip ],
      max_failures => 3,
      failure_timeout => 2,
      ketama_points => 150,
      nowait => 1,
      hash_namespace => 1,
      serialize_methods => [ \&Storable::freeze,
                             \&Storable::thaw ],
      utf8 => ($^V ge v5.8.1 ? 1 : 0),
      max_size => 4*512 * 1024,
  });

