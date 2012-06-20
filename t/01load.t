use Test::More;
use AI::MicroStructure ();
use strict;

my @modules = map { "AI::MicroStructure::$_" } AI::MicroStructure->themes;
    
plan tests => scalar @modules;
use_ok( $_ ) for sort @modules;
