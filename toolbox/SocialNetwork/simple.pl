#!/usr/bin/perl -X

use strict;
use Data::Dumper;
use Acme::MetaSyntactic; # loads the default theme
use Graph::Undirected;
use Algorithm::SocialNetwork;




           my $G = Graph::Undirected->new();
             
           my $algo = Algorithm::SocialNetwork->new(graph => $G);
            $G->add_edges($algo,[qw(b c)]);
           my $BC = $algo->BetweenessCentrality();
           # $BC->{a} is 0
           # $BC->{b} is 2
           # $BC->{c} is 0
# 
#print  $G;
#print  $G;
 #foreach(@themes){ 
 print Dumper [$@,
               $G,$BC]; #print Dumper $_;
  
 #}
 
 
#;#




__DATA__

my (@themes,@names)= (Acme::MetaSyntactic::themes(8888),[]);


foreach(@themes){



  
     my $meta = Acme::MetaSyntactic->new($_->[0]);


           push @names , [$meta->name( 5000 )]; # return 4 distinct names (if possible)

}

print Dumper @names;
1;
__DATA__
           # this sets the default theme and loads Acme::MetaSyntactic::shadok
      

