#!/usr/bin/perl
package AI::MicroStructure::Tree; # or whatever you're doing

use strict;
use Class::Container;
use base qw(Tree::DAG_Node);
use Params::Validate qw(:types);
use Data::Dumper;
use AI::MicroStructure::Collection;
use  AI::MicroStructure;
my @themes = grep { !/^(?:any)/ } AI::MicroStructure->themes;

my $root = Tree::DAG_Node->new({attributes=>{BASE_STRUCTURE=>[@themes]}});
   $root->name("santex");
my @static = qw(mindmasage collections stream tools others);
my $daughter = {};  

foreach my $cat (@static){


my $new_daughter = $root->new_daughter;
# $new_daughter->add_right_sisters(qw(A b));
   $daughter->{$cat}= $new_daughter;    
   $daughter->{$cat}->name($cat);# 
}
  my $m = match(@static);
foreach my $t (reverse @themes[0..2]){

  my $micro = "AI::MicroStructure"->new($t); 

  foreach my $entity ($micro->name(3)){
#  foreach my $i (1..2){

  my $new_daughter = $daughter->{$m}->new_daughter;
   #$new_daughter = $daughter->{$cat}->new_daughter;
   $daughter->{$m}->{$entity}= $new_daughter; 
   $daughter->{$m}->{$entity}->name(`micro`);
   }
 #  }
  
}

my $diagram = $root->draw_ascii_tree;
              print map "$_\n", @$diagram;


#  print Dumper $root;
sub match{
  my (@set) = @_;
  return $set[rand($#static+1)];

}
1;
