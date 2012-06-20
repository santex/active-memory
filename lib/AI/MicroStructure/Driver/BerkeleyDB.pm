#!/usr/bin/perl -
package AI::MicroStructure::Driver::BerkeleyDB;
use strict ;
use warnings;
use Data::Dumper;
use Carp;
use BerkeleyDB ;

our $VERSION='0.01';

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;


  $self->{filename} = shift ;

  $self->{filename} =   "/tmp/tree.db"  unless $self->{filename};

  return $self;
}


sub initialize {
  my $self = shift();
  %$self=@_;
}

sub store{

  my $self = shift;

  
    my %h ;
    tie %h, 'BerkeleyDB::Btree',
                -Filename   => $self->{filename},
                -Flags      => DB_CREATE,
                -Compare    => sub { lc $_[0] cmp lc $_[1] }
      or warn "Cannot open $self->{filename}: $!\n" ;


    $h{"1x"}=4;

    print Dumper \%h;

    untie %h ;

}

sub retrieve{

  my $self = shift;
  my %h ;
    tie %h, 'BerkeleyDB::Btree',
                -Filename   => $self->{filename},
                -Flags      => DB_CREATE,
                -Compare    => sub { lc $_[0] cmp lc $_[1] }
      or warn "Cannot open $self->{filename}: $!\n" ;


    untie %h ;


    return $h{$_[0]};

}


sub unlink {

  my $self = shift;

  unlink $self->{filename};
}


sub delete  {  my $self=shift; }
sub _client {  my $self=shift; }
sub _db     {  my $self=shift; }
sub db      {  my $self=shift; }
sub uri     {  my $self=shift; }

1;
