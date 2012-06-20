#!/usr/bin/perl -w
package AI::MicroStructure::Driver::CouchDB;
use strict;
use warnings;
use CouchDB::Client;

our $VERSION='0.01';

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

sub initialize {
  my $self = shift();
  %$self=@_;
}

sub store {
  my $self=shift;
  warn("Error: Wrong number of arguments.") unless @_ == 2;
  my $doc=shift;
  warn("Error: Document name must be defined.") unless defined $doc;
  my $data=shift;                        #support storing undef!
  my $cdbdoc=$self->_db->newDoc($doc);   #isa CouchDB::Client::Doc
  if ($self->_db->docExists($doc)) {
    $cdbdoc->retrieve;                   #to get revision number for object
    $cdbdoc->data({data=>$data});
    $cdbdoc->update;
  } else {
    $cdbdoc->data({data=>$data});
    $cdbdoc->create;
  }
  return $cdbdoc->data->{"data"};
}

sub retrieve {
  my $self=shift;
  my $doc=shift;
  warn("Error: Document name must be defined.") unless defined $doc;
  if ($self->_db->docExists($doc)) {
    my $cdbdoc=$self->_db->newDoc($doc); #isa CouchDB::Client::Doc
    $cdbdoc->retrieve;
    return $cdbdoc->data->{"data"};      #This may also be undef
  } else {
    return undef;
  }
}

sub delete {
  my $self=shift;
  warn("Error: Wrong number of arguments.") unless @_ == 1;
  my $doc=shift;
  warn("Error: Document name must be defined.") unless defined $doc;
  if ($self->_db->docExists($doc)) {
    my $cdbdoc=$self->_db->newDoc($doc); #isa CouchDB::Client::Doc
    $cdbdoc->retrieve;                   #to get revision number for object
    my $data=$cdbdoc->data->{"data"};    #since we already have the data
    $cdbdoc->delete;
    return $data;                        #return what we deleted
  } else {
    return undef;
  }
}

sub _client {                            #isa CouchDB::Client
  my $self=shift;
  unless (defined $self->{"_client"}) {
    $self->{"_client"}=CouchDB::Client->new(uri=>$self->uri);
    $self->{"_client"}->testConnection or warn("Error: CouchDB Server Unavailable");
  }
  return $self->{"_client"};
}

sub _db {                                #isa CouchDB::Client::DB
  my $self=shift;
  unless (defined $self->{"_db"}) {
    $self->{"_db"}=$self->_client->newDB($self->db);
    $self->{"_db"}->create unless $self->_client->dbExists($self->db);
  }
  return $self->{"_db"};
}

sub db {
  my $self=shift;
  $self->{"db"}=shift if @_;
  my $u = `whoami` ;
  $u =~ s/\n//g;
  $self->{"db"}=$u unless defined $self->{"db"};
  return $self->{"db"};
}

sub uri {
  my $self=shift;
  $self->{"uri"}=shift if @_;
  $self->{"uri"}='http://127.0.0.1:5984/' unless defined $self->{"uri"};
  return $self->{"uri"};
}

1;


