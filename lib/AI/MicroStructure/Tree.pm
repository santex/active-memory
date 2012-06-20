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
   $root->name("I'm the tops");
my $new_daughter = $root->new_daughter;
   $new_daughter->name("More");
 

  print Dumper $root;


1;
