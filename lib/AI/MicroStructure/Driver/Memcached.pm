#!/usr/bin/perl -w
package AI::MicroStructure::Driver::Memcached;
use Cache::Memcached;
use Data::Dumper;
our $VERSION='0.01';

sub new {

  my $class = shift;
  my $self ={};
  $self->{memcache} = new Cache::Memcached {
'servers' => [ "127.0.0.1:11211"],
'debug' => 0,
'compress_threshold' => 0};


  bless $self, $class;

  return $self;
}

sub retrieve {

    my $self = shift;

    return $self->{'memcache'}->get($_[0]);
}
sub store {
    my $self = shift;
    if (defined $_[1]){
        my $ref = $self->{'memcache'};
        $ref->set($_[0],$_[1]);
    } else {
        die "Cannot SET an undefined key in Mydbm\n";
    }
}

sub initialize { my $self = shift(); %$self=@_; }
sub delete  {  my $self=shift; }
sub _client {  my $self=shift; }
sub _db     {  my $self=shift; }
sub db      {  my $self=shift; }
sub uri     {  my $self=shift; }

1;
