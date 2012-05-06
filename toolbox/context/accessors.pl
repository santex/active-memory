#!/usr/bin/perl -w

use Search::ContextGraph;
use Data::Dumper;

my %docs = (
  'First Document' => { 'elephant' => 2, 'snake' => 1 },
  'Second Document' => { 'camel' => 1, 'pony' => 1 },
  'Third Document' => { 'snake' => 2, 'constrictor' => 1 },
);

for my $XS ( 0..1 ) {
	last if $XS;
	
	my $cg = Search::ContextGraph->new( xs => $XS);
	
	print Dumper ($cg, "have Search::ContextGraph object");
	
	# ACTIVATE THRESHOLD
	
	print Dumper [($cg->get_activate_threshold(), 1, "Able to retrieve activate threshold" )];
	print Dumper ($cg->set_activate_threshold( .5 ),  "Setting activate threshold" );
	print Dumper [($cg->get_activate_threshold(), .5, "Activate threshold reset correctly" )];
	
	
	# COLLECTION THRESHOLD
	
	$cg->set_collect_threshold(.13);
	print Dumper ( abs( $cg->get_collect_threshold() - .13 ) < .001, "Collect was set properly" );
	print Dumper (	$cg->set_collect_threshold(0), "set collect threshold to zero" );
	print Dumper [(  $cg->get_collect_threshold(), 0, "collect threshold updated properly" )];

	
	# INITIAL ENERGY
	
	print Dumper [( $cg->get_initial_energy(), 100, "got correct initial energy" )];
	print Dumper ( $cg->set_initial_energy(120),  "reset initial energy" );
	print Dumper [( $cg->get_initial_energy(), 120, "initial energy reset correctly" )];
	
	
	# MAX DEPTH
	print Dumper [( $cg->get_max_depth(), 100000000, "Got correct default depth" )];
	print Dumper ( $cg->set_max_depth( 20 ), "Set maximum depth succeeded" );
	print Dumper [( $cg->get_max_depth(), 20, "Maximum depth updated properly" )];
	print Dumper ( $cg->set_max_depth(0), "Able to assign zero as maximum depth" );
	eval { $cg->set_max_depth() };
	print Dumper ( $@ =~ /Tried to set maximum depth to an undefined value/, 
				"did not allow maximum depth to be an undefined value");
	print Dumper [( $cg->get_max_depth(), 100000000, "Got correct default depth" )];
	
	# FAILURES
	
	# Can't set activation energy higher than initial energy;
	eval{ $cg->set_initial_energy( -200 ) };
	print Dumper (  $@, "Can't set initial energy to negative value" );
	
	eval{ $cg->set_activate_threshold( 0 ) };
	print Dumper (  $@, "Can't set activate threshold to zero" );
	
	eval{ $cg->set_activate_threshold( -120 ) };
	print Dumper (  $@, "Can't set activate threshold to negative value" );
	
}
