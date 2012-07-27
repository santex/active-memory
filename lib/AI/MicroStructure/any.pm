package AI::MicroStructure::any;
use strict;
use List::Util 'shuffle';
use AI::MicroStructure ();

our $Theme = 'any';

sub import {
    # export the microany function
    my $callpkg = caller;
    my $micro    = AI::MicroStructure->new();
    no strict 'refs';
    *{"$callpkg\::microany"} = sub { $micro->name( @_ ) };
}

sub name {
    my $self  = shift;
    my $theme =
      ( shuffle( grep { !/^(?:any|random)$/ } AI::MicroStructure->themes() ) )[0];
    $self->{micro}->name( $theme, @_ );
}

sub new {
    my $class = shift;

    # we need a full AI::MicroStructure object, to support AMS::Locale
    return bless { micro => AI::MicroStructure->new( @_ ) }, $class;
}

sub theme { $Theme };

sub has_remotelist { };

1;


