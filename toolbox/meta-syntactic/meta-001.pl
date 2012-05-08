#!/usr/bin/perl
use strict;
use Acme::MetaSyntactic; # loads the default theme
use Data::Dumper;

  my $meta = Acme::MetaSyntactic->new();
  my @themes = $meta->themes();
  foreach(@themes){
  printf("%s\n",$_);
  }

