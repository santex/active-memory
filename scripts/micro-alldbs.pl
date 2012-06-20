#!/usr/bin/perl
use strict;
use AI::MicroStructure;
use Data::Dumper;
use LWP::UserAgent;
use JSON;

my $i=0;
my $ix=0;
my $ua = LWP::UserAgent->new;
my $dat = {};
my $res;
my $hash={};
my $matches={};
my $files={};
my @metas;
my $x = AI::MicroStructure->new;
my $total={};
my @themes = grep { !/^(?:any)/ } AI::MicroStructure->themes;
my @metas;


 foreach ("http://algoservice.com:5984/_all_dbs")
 {

 $res = $ua->get($_);


$ix++;
$hash->{$_}= decode_json($res->content);

if(ref $hash->{$_} eq "ARRAY"){

foreach(grep!/_/,@{$hash->{$_}}){

  
  next unless($_ !~ /test/ ); 
  
  $res = $ua->get("http://algoservice.com:5984/$_/_all_docs");
    
    $files->{$_}=decode_json($res->content);

} 
$total->{files} = $files;

}elsif(ref $hash->{$_} eq "HASH" && defined($hash->{$_}->{rows})){

warn ref $hash->{$_}; 

  foreach(@{$hash->{$_}->{rows}}){

      $dat->{$i++}=$_->{key};
  }
  
 
  }

}


END{
 print Dumper keys %$files;
}
