#!/usr/bin/perl
-wT;
use strict;
use Tk;

###################################################################################
# Declare global variables and call main loop.
###################################################################################
my (@matrix, $manual);
my @birth = (0, 0, 0, 1, 0, 0, 0, 0, 0);
my @survive = (0, 0, 1, 1, 0, 0, 0, 0, 0);
my $title = 'Hagen Geissler\'s "Game of Life" by Ingram Braun (santex@cpan.org)';
my $delay = 5; my $sync = 1; my $torus = 1; my $percent = 40;
my $scale = 12; my $grid = 'groove'; my $x = 30; my $y = 30;
my $VERSION = 1.12;
InitGeometry();
InitMatrix();
CallSimulation();
MainLoop;

###################################################################################
# Configuration window
###################################################################################
sub InitGeometry() {
	my $mw = MainWindow->new;
	$mw->title($title);
	$mw->Label(-text => "Set up configuration")->pack(-side => 'top');
	$mw->Scale(-orient => 'horizontal', -length => 500,
		-label => "Length of rows (cells)", -variable => \$x, -from => 10, -to => 100)->pack;
	$mw->Scale(-orient => 'vertical', -length => 400, 
		-label => "Length of columns (cells)", -variable => \$y, -from => 10,
		-to => 75)->pack(-side => 'left');
	$mw->Scale(-orient => 'horizontal', -length => 200,
		-label => "Length of cells (pixel)", -variable => \$scale, -from => 3, -to => 25)->pack;
	$mw->Scale(-orient => 'horizontal', -length => 200,
		-label => "Window update delay (1/10 sec)", -variable => \$delay, -from => 1, -to => 30)->pack;
	$mw->Button(-text => "Continue", -command => sub {$mw->destroy()},
		)->pack(-side => 'bottom', -anchor => 's');
	my $frame1 = $mw->Frame(-borderwidth => 2, -relief => 'groove',
		)->pack(-side => 'left', -anchor => 'e');
	$frame1->Checkbutton(-text => "Mark cells manually",
		-variable => \$manual)->pack(-side => 'bottom', -anchor => 'w');
	$frame1->Checkbutton(-text => "Show grid", -variable => \$grid,	-onvalue => 'groove',
		-offvalue => 'flat')->pack(-side => 'bottom', -anchor => 'w');
	$frame1->Checkbutton(-text => "Torus shaped matrix", -variable => \$torus
		)->pack(-side => 'bottom', -anchor => 'w');
	$frame1->Checkbutton(-text => "Synchronous matrix updates", -variable => \$sync
		)->pack(-side => 'bottom', -anchor => 'w');
	my $frame2 = $mw->Frame(-label => "Birth", -borderwidth => 2, -relief => 'groove'
		)->pack(-side => 'left', -anchor => 'e');
	for (my $i = 8; $i >= 0; $i--) {
		$frame2->Checkbutton(-text => "$i", -variable => \$birth[$i]
		)->pack(-side => 'bottom', -anchor => 'w');}
	my $frame3 = $mw->Frame(-label => "Survival", -borderwidth => 2, -relief => 'groove'
		)->pack(-side => 'left', -anchor => 'e');
	for (my $i = 8; $i >= 0; $i--) {
		$frame3->Checkbutton(-text => "$i", -variable => \$survive[$i]
		)->pack(-side => 'bottom', -anchor => 'w');}
	$mw->waitWindow();}

###################################################################################
# Matrix initialization:a matrix with n squares is a list { 0, 1, ..., n-1}.
# Edge squares are to be found by calculation.
# 1 = living; 0 = dead.
###################################################################################
sub InitMatrix() {
	for (my $i = 0; $i < $x * $y; $i++) {$matrix[$i] = 0;}
	my $mw = MainWindow->new;
	$mw->title($title);
	$mw->Button(-text => "Continue", -command => sub {$mw->destroy()},
		)->pack(-side => 'top', -anchor => 'n');
	if ($manual == 0) {
		my $count1 = 0; my $count2 = 0;
		$mw->Scale(-orient => 'horizontal', -variable => \$percent, -from => 1, -to => 99,
			-label => "Percent living cells", -length => 200)->pack(-side => 'left');
		$mw->waitWindow();      # otherwise $percent is updated too early
		srand();
		$percent *= int $x * $y / 100;
		while ($count1 < $percent) {
			if ($matrix[$count2] == 0) {
				if ($percent > int(rand($x * $y))) {
					$matrix[$count2] = 1;
					$count1++;}}
			if ($count2 < $#matrix) {$count2++;}
			else {$count2 = 0;}}}
	else {
		my $width = 20; my $col = $width; my $row = 0; my @box;
		$mw->Label(-text => "Mark living cells"
		   )->pack(-side => 'top', -anchor => 's');
		my $frame = $mw->Frame()->pack(-side => 'bottom');
		for (my $i = 0; $i < $x * $y; $i++) {
			$col++;
			if ($i % $x == 0) {$col = 0; $row++;}
			$box[$i] = $frame->Checkbutton(-variable => \$matrix[$i]
				)->grid(-row => $row, -column => $col);}
		$mw->waitWindow();}}

###################################################################################
# Simulation window
###################################################################################
sub CallSimulation() {
	my $mw = MainWindow->new;
	$mw->title($title);
	my $counter = 0; my $col = 0; my $row = 0; my $run = 0;
	my $living = CountLivingCells(); my (@box, $colour);
	my $livperc = PercentLivingCells();
	$mw->title($title);
	my $frame1 = $mw->Frame()->pack(-side => 'left');
	my $frame2 = $mw->Frame()->pack(-side => 'right');
	$frame2->Button(-text => "Exit", -command => sub{ exit }
		)->pack(-side => 'bottom');
	my $display1 = $frame2->Label(-text => "Generation: $run",-anchor => 'w'
		)->pack(-side => 'top');
	my $display2 = $frame2->Label(-text => "Living cells: $living",	-anchor => 'w'
		)->pack(-side => 'top');
	my $display3 = $frame2->Label(-text => "Percent living cells: $livperc %",
		-anchor => 'w')->pack(-side => 'top');
	$frame2->Label(-text => "\t\t\t\t\t",-anchor => 'w')->pack(-side => 'top');
	for (my $i = 0; $i < $x * $y; $i++) {
		$col++;
		if ($i % $x == 0) {$col = 0; $row++;}
		if ($matrix[$i] == 0) {$colour = 'white';}
		else {$colour = 'black';}
		$box[$i] = $frame1->Frame(-bg => 'grey', -borderwidth => 1, -relief => $grid, -width 
		=> $scale, -height => $scale, -bg => $colour)->grid(-row => $row, -column => $col, -sticky => 'nsew');}
	$box[-1]->waitVisibility();
	$frame1->repeat($delay * 100, sub {
		UpdateMatrix();
		$run++;
		for (my $i = 0; $i < $x * $y; $i++) {
			if ($matrix[$i] == 0) {$colour = 'white';}
			else {$colour = 'black';}
			if ($box[$i]->cget(-bg) ne $colour) {$box[$i]->configure(-bg => $colour);}}
		$display1->configure(-text => "Generation: $run");
		$living = CountLivingCells();
		$display2->configure(-text => "Living cells: $living");
		$livperc = PercentLivingCells();
		$display3->configure(-text => "Percent living cells: $livperc %");})}

###################################################################################
# Set up cell by evaluating neighbours.
# Parameter is index of cell.
# This function can handle more then two cell conditions.
###################################################################################
sub UpdateMatrix() {
	my @buffer = @matrix;       # Matrix manipulation is carried out in a buffer
	for (my $i = 0; $i <= $#matrix; $i++) {
		my @neighbours = ReturnNeighbours($i);
		my %cond;
		foreach (@neighbours) {$cond{$matrix[$_]}++;}
		($sync == 0) ? $matrix[$i] = Rule($i, \%cond) : $buffer[$i] = Rule($i, \%cond);}
	if ($sync == 1) {@matrix = @buffer;}}

###################################################################################
# This function needs a cell index and returns a list of all its neighbours.
###################################################################################
sub ReturnNeighbours() {
	my $p = shift;
	my @return;
	if ($torus == 1) {
		if (1 == Top($p)) {
			push @return, $p+($y-1)*$x;
			if (1 == Right($p)) {push @return, ($p+($y-2)*$x+1, $p+($y-1)*$x-1, $p+1, $p-$x+1);}
			elsif (1 == Left($p)) {push @return, ($p+$y*$x-1, $p+($y-1)*$x+1, $p+2*$x-1, $p+$x-1);}
			else {push @return, ($p+($y-1)*$x-1,$p+($y-1)*$x+1);}}
		elsif (1 == Bottom($p)) {
			push @return, $p-($y-1)*$x;
			if (1 == Right($p)) {push @return, ($p-2*$x+1, $p-($y-1)*$x-1, $p-$x*$y+1, $p-$x+1);}
			elsif (1 == Left($p)) {push @return, ($p-($y-2)*$x-1, $p-($y-1)*$x+1, $p-1, $p+$x-1);}
			else {push @return, ($p-($y-1)*$x-1, $p-($y-1)*$x+1);}}
		elsif (1 == Right($p)) {push @return, ($p-$x+1, $p-2*$x+1, $p+1);}
		elsif (1 == Left($p)) {push @return, ($p+$x-1, $p-1, $p+2*$x-1);}
		else {}}
	if (0 == Top($p) && 0 == Right($p)) {push @return, $p-$x+1;}
	if (0 == Top($p) && 0 == Left($p)) {push @return, $p-$x-1;}
	if (0 == Bottom($p) && 0 == Left($p)) {push @return, $p+$x-1;}
	if (0 == Bottom($p) && 0 == Right($p)) {push @return, $p+$x+1;}
	if (0 == Top($p)) {push @return, $p-$x;}
	if (0 == Bottom($p)) {push @return, $p+$x;}
	if (0 == Right($p)) {push @return, $p+1;}
	if (0 == Left($p)) {push @return, $p-1;}
	return @return;}

###################################################################################
# This function tests if a particular cell meets a rule.
# Needs: cell index and a hash (condition => number of cases}
# Returns next cell state.
# Changed rules must be programmed here.
###################################################################################
sub Rule() {
	if ($matrix[$_[0]] == 0 && $birth[$_[1]->{1}] == 1) {return 1;}
	elsif ($matrix[$_[0]] == 1 && $survive[$_[1]->{1}] == 1) {return 1;}
	else {return 0};}

###################################################################################
# Returns number of living cells.
###################################################################################
sub CountLivingCells() {
	my $counter = 0;
	foreach (@matrix) {$counter += $_;}
	return $counter;}

###################################################################################
# Returns percentage of living cells.
###################################################################################
sub PercentLivingCells() {return(sprintf("%.2f",(CountLivingCells()/($#matrix+1)*100)));}

###################################################################################
# This subroutines take a cell index and tests on them being edge.
# Return 1 if an edge cell, otherwise 0.
###################################################################################
sub Top() {($_[0] < $x) ? return 1 : return 0;}
sub Bottom() {($_[0] > $x * ($y - 1) - 1) ? return 1 : return 0;}
sub Left(){($_[0] % $x == 0) ? return 1 : return 0;}
sub Right() {($_[0] % $x == $x - 1) ? return 1 : return 0;}



=pod OSNAMES

any

=pod SCRIPT CATEGORIES

Educational

=head1 NAME

F<life1.12.pl>

=head1 DESCRIPTION

This script implements a Game of Life according to Hagen Geissler. Matrix size as well as birth and survival rules are editable. The initial state can be set up by random generator or manually.

=head1 PREREQUISITES

This script requires the C<strict> module.  It also requires
C<Tk>.

=head1 AUTHOR

Copyright 2008-2011 Ingram Braun <santex@cpan.org>.  All rights reserved.

This script is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
THIS SOFTWARE DOES NOT COME WITH ANY WARRANTY WHATSOEVER. USE AT YOUR OWN RISK.

=head1 README

This script implements a Game of Life according to Hagen Geissler. Matrix size as well as birth and survival rules are editable. The initial state can be set up by random generator or manually.

An up to date perl distribution (5.6 or higher) and the Tk module is required.

Copyright 2008-2011 Ingram Braun <santex@cpan.org>.  All rights reserved. 

This script is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
THIS SOFTWARE DOES NOT COME WITH ANY WARRANTY WHATSOEVER. USE AT YOUR OWN RISK.

=cut
