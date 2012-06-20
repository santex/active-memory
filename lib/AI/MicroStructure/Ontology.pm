#!/usr/bin/perl	-w
package AI::MicroStructure::Ontology;
use strict;
use Data::Dumper;
use Carp;
use JSON;
use vars qw(
  $configure
	$pi
	$driver
	);




sub import {
	## print "import called with @_\n";
	local $configure = @_; # shame that Getopt::Long isn't structured better!
	use Getopt::Long ();


  


	Getopt::Long::GetOptions( '-',
		'driver=f'=>\$driver,
		'configure=f'=>\$configure,
		) or croak("bad import arguments");

    
} # end subroutine import definition


sub new {
  
  my($class,$args) = @_;
 
  my $self = bless { cache => [] }, $class;
  $configure = $args;
  
  $self->import;

  return $self;
}




sub initialize {
  my $self = shift();
 %$self= @_;

}


sub name{
    my $self = shift;

    return $self->{'name'} = shift if @_;
    return $self->{'name'};
}


sub authority{
    my $self = shift;

    return $self->{'authority'} = shift if @_;
    return $self->{'authority'};
}


sub definition{
    my $self = shift;

    return $self->{'definition'} = shift if @_;
    return $self->{'definition'};
}

sub identifier{
    my $self = shift;

    if(@_) {
        $self->throw("cannot modify identifier for ".ref($self))
            if exists($self->{'identifier'});
        my $id = shift;
        $self->{'identifier'} = $id if $id;
    }
    if(! exists($self->{'identifier'})) {
        ($self->{'identifier'}) = "$self" =~ /(0x[0-9a-fA-F]+)/;
    }
    return $self->{'identifier'};
}

sub close{
    my $self = shift;

    # if it is in the ontology store, remove it from there
    my $store = AI::MicroStructure::Ontology::OntologyStore->get_instance();
    $store->remove_ontology($self);
    # essentially we need to dis-associate from the engine here
    $self->engine(undef);
    return 1;
}



sub add_term{
    my $self = shift;
    my $term = shift;

    # set ontology if not set already
    $term->ontology($self) if $term && (! $term->ontology());
    return $self->engine->add_term($term,@_);
}

sub add_relationship {
  my $self = shift;
  my $rel = shift;

  if($rel && $rel->isa("AI::MicroStructure::Ontology::TermI")) {
    # we need to construct the relationship object on the fly
    my ($predicate,$object) = @_;
    $rel = AI::MicroStructure::Ontology::Relationship->new(
                                            -subject_term   => $rel,
                                            -object_term    => $object,
                                            -predicate_term => $predicate,
                                            -ontology       => $self,
                                           );
  }
  # set ontology if not set already
  $rel->ontology($self) unless $rel->ontology();
  return $self->engine->add_relationship($rel);
}

sub get_relationship_type{
    my $self = shift;
    return $self->engine->get_relationship_type(@_);
}

sub get_relationships {
  my $self = shift;
  my $term = shift;
  if($term) {
        # we don't need to filter in this case
        return $self->engine->get_relationships($term);
  }
  # else we need to filter by ontology
  return grep { my $ont = $_->ontology;
                # the first condition is a superset of the second, but
                # we add it here for efficiency reasons, as many times
                # it will short-cut to true and is supposedly faster than
                # string comparison
                ($ont == $self) || ($ont->name eq $self->name);
              } $self->engine->get_relationships(@_);
}

sub get_predicate_terms{
    my $self = shift;

    # skipped AI::MicroStructure::Ontology::Relationship w/o defined Ontology (bug 2573)
    return grep { $_->ontology && ($_->ontology->name eq $self->name)
              } $self->engine->get_predicate_terms(@_);
}

sub get_child_terms{
    return shift->engine->get_child_terms(@_);
}

sub get_descendant_terms{
    return shift->engine->get_descendant_terms(@_);
}

sub get_parent_terms{
    return shift->engine->get_parent_terms(@_);
}

sub get_ancestor_terms{
    return shift->engine->get_ancestor_terms(@_);
}

sub get_leaf_terms{
    my $self = shift;
    return grep { my $ont = $_->ontology;
                  # the first condition is a superset of the second, but
                  # we add it here for efficiency reasons, as many times
                  # it will short-cut to true and is supposedly faster than
                  # string comparison
                  ($ont == $self) || ($ont->name eq $self->name);
              } $self->engine->get_leaf_terms(@_);
}

sub get_root_terms{
    my $self = shift;
    return grep { my $ont = $_->ontology;
                  # the first condition is a superset of the second, but
                  # we add it here for efficiency reasons, as many times
                  # it will short-cut to true and is supposedly faster than
                  # string comparison
                  ($ont == $self) || ($ont->name eq $self->name);
              } $self->engine->get_root_terms(@_);
}

sub get_all_terms{
    my $self = shift;
    return grep { my $ont = $_->ontology;
                  # the first condition is a superset of the second, but
                  # we add it here for efficiency reasons, as many times
                  # it will short-cut to true and is supposedly faster than
                  # string comparison
                  ($ont == $self) || ($ont->name eq $self->name);
              } $self->engine->get_all_terms(@_);
}

sub find_terms{
    my $self = shift;
    return grep { $_->ontology->name eq $self->name;
              } $self->engine->find_terms(@_);
}

sub find_identical_terms{
    my $self = shift;
    return grep { $_->ontology->name eq $self->name;
              } $self->engine->find_identical_terms(@_);
}


sub find_similar_terms{
    my $self = shift;
    return grep { $_->ontology->name eq $self->name;
              } $self->engine->find_similar_terms(@_);
}

sub find_identically_named_terms{
    my $self = shift;
    return grep { $_->ontology->name eq $self->name
              } $self->engine->find_identically_named_terms(@_);
}

sub relationship_factory{
    return shift->engine->relationship_factory(@_);
}

sub term_factory{
    return shift->engine->term_factory(@_);
}


sub annotation{
    my $self = shift;
    $self->{'annotation'} = shift if @_;
    return $self->{'annotation'};
}


1;
