#!/usr/bin/perl
package AI::MicroStructure::Plug;
use strict;
use warnings;
use Search::ContextGraph;




BEGIN {
  package My::RDBO; $INC{"Plug"} = __FILE__;
  use base qw(Rose::DB::Object);
  sub init_db { shift; My::RDB->new }
}

BEGIN {
  package My::RDB; $INC{"Plug"} = __FILE__;
  use base qw(Rose::DB);

  our $FILENAME = sprintf("/tmp/plug.sqlite");

  __PACKAGE__->register_db
    (driver => 'sqlite',
     database => $FILENAME,
    );

  unless (0 and -f $FILENAME) {
    __PACKAGE__->initialize_database;
  }

sub delete {
    my ($self,
    $name,
    ) = @_;

    delete $self->{$_}{$name} for qw/TS AREA/;
}


sub membership {
    my ($self,
    $name,
    $val,
    ) = @_;

    return undef unless $self->exists($name);

    my $deg = 0;
    my @c   = $self->coords($name);

    my $x1 = shift @c;
    my $y1 = shift @c;

    while (@c) {
    my $x2 = shift @c;
    my $y2 = shift @c;

    next if $x1 == $x2;    # hmm .. why do we have this?

    unless ($x1 <= $val && $val <= $x2) {
        $x1 = $x2;
        $y1 = $y2;
        next;
    }
    $deg = $y2 - ($y2 - $y1) * ($x2 - $val) / ($x2 - $x1);
    last;
    }

    return $deg;
}

sub listAll {
    my $self = shift;

    return keys %{$self->{TS}};
}

sub listMatching {
    my ($self, $rgx) = @_;

    return grep /$rgx/, keys %{$self->{TS}};
}

sub max {    # max of two sets.
    my ($self,
    $set1,
    $set2,
    ) = @_;

    my @coords1 = $self->coords($set1);
    my @coords2 = $self->coords($set2);

    my @newCoords;
    my ($x, $y, $other);
    while (@coords1 && @coords2) {
    if ($coords1[0] < $coords2[0]) {
        $x     = shift @coords1;
        $y     = shift @coords1;
        $other = $set2;
    } else {
        $x     = shift @coords2;
        $y     = shift @coords2;
        $other = $set1;
    }
    my $val    = $self->membership($other, $x);
    $val = $y if $y > $val;
    push @newCoords => $x, $val;
    }

    push @newCoords => @coords1 if @coords1;
    push @newCoords => @coords2 if @coords2;

    return @newCoords;
}

sub min {    # min of two sets.
    my ($self,
    $set1,
    $set2,
    ) = @_;

    my @coords1 = $self->coords($set1);
    my @coords2 = $self->coords($set2);

    my @newCoords;
    my ($x, $y, $other);
    while (@coords1 && @coords2) {
    if ($coords1[0] < $coords2[0]) {
        $x     = shift @coords1;
        $y     = shift @coords1;
        $other = $set2;
    } else {
        $x     = shift @coords2;
        $y     = shift @coords2;
        $other = $set1;
    }
    my $val    = $self->membership($other, $x);
    $val = $y if $y < $val;
    push @newCoords => $x, $val;
    }

    push @newCoords => @coords1 if @coords1;
    push @newCoords => @coords2 if @coords2;

    return @newCoords;
}

sub complement {
    my ($self, $name) = @_;

    my @coords = $self->coords($name);
    my $i = 0;
    return map {++$i % 2 ? $_ : 1 - $_} @coords;
}

sub coords {
    my ($self,
    $name,
    ) = @_;

    return undef unless $self->exists($name);

    return @{$self->{TS}{$name}};
}

sub scale {  # product implication
    my ($self,
    $name,
    $scale,
    ) = @_;

    my $i = 0;
    my @c = map { $_ * ++$i % 2 ? 1 : $scale } $self->coords($name);

    return @c;
}

sub clip {   # min implication
    my ($self,
    $name,
    $val,
    ) = @_;

    my $i = 0;
    my @c = map {
    ++$i % 2 ? $_ : $_ > $val ? $val : $_
    }$self->coords($name);

    return @c;
}

# had to roll my own centroid algorithm.
# not sure why standard algorithms didn't work
# correctly!
sub centroid {   # center of mass.
    my ($self,
    $name,
    ) = @_;

    return undef unless $self->exists($name);

    my @coords = $self->coords($name);
    my @ar;

    my $x0 = shift @coords;
    my $y0 = shift @coords;
    my ($x1, $y1);

    while (@coords) {
    $x1 = shift @coords;
    $y1 = shift @coords;

    my $a1 = abs(0.5 * ($x1 - $x0) * ($y1 - $y0));
    my $c1 = (1/3) * ($x0 + $x1 + ($y1 > $y0 ? $x1 : $x0));

    my $a2 = abs(($x1 - $x0) * ($y0 < $y1 ? $y0 : $y1));
    my $c2 = $x0 + 0.5 * ($x1 - $x0);

    my $ta = $a1 + $a2;
    next if $ta == 0;

    my $c  = $c1 * ($a1 / $ta);
    $c    += $c2 * ($a2 / $ta);

    push @ar => [$c, $ta];
    } continue {
    $x0 = $x1;
    $y0 = $y1;
    }

    my $ta = 0;
    $ta += $_->[1] for @ar;

    my $c = 0;
    $c += $_->[0] * ($_->[1] / $ta) for @ar;

    return $c;
}

sub median {
    my ($self,
    $name,
    ) = @_;

    my @coords = $self->coords($name);

    return 0;
}

sub exists {
    my ($self,
    $name,
    ) = @_;

    return exists $self->{TS}{$name};
}

sub uniquify {
    my $self = shift;

    my @new;
    my %seen;

    while (@_) {
    my $x = shift;
    my $y = shift;

    next if $seen{$x};

    push @new => ($x, $y);
    $seen{$x} = 1;
    }

    return @new;
}



sub on_error_ignore {
  my $self = shift;
}

sub on_error_warn {
  my $self = shift;
  warn $@;
}

sub on_error_die {
  my $self = shift;
  die $@;
}

sub do_something_dangerous {
  my $self = shift;
  my $task = shift;             # coderef
  eval { $task->(@_) };
  if ($@) {
    my $error = $@;
    my $action = $self->{on_error} || 'on_error_die';
    $self->$action($@);
  }
}

sub reciprocal {
  my $self = shift;

  my $somevalue = shift;

  my $result;
  $self->do_something_dangerous
    (sub { $result = 1 / $somevalue });
  return $result;
}

sub open_file {
  my $self = shift;

  my $file = shift;

  my $filehandle;
  $self->do_something_dangerous
    (sub { open my $h, "<", $file or die "Cannot open $file: $!";
           $filehandle = $h;
         });
  return $filehandle;
}

sub add {
    my ($self,
    $name,
    $xmin,
    $xmax,
    @coords,
    ) = @_;

    # make sure coords span the whole universe.
    if ($coords[0] > $xmin) {
    unshift @coords => ($xmin, $coords[1]);
    }

    if ($coords[-2] < $xmax) {
    push @coords => ($xmax, $coords[-1]);
    }

    $self->{TS}{$name} = \@coords;
}


  sub initialize_database {
    my $class = shift;
    my $db = $class->new;
  warn $db->driver unless $db->driver eq "sqlite";
    unlink $db->database;

    my $dbc = Search::ContextGraph->new();
    my $dbh = $db->dbh;


    $dbh->{RaiseError} = 0;
    $dbh->{PrintError} = 0;

    $dbh->do($_) or die "$DBI::errstr
      for $_" for split /\n{2,}/, <<'END_OF_SQL';
CREATE TABLE if not exists persons (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  birthdate DATE
)

CREATE TABLE  if not exists films (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  release_date DATE
)

CREATE TABLE  if not exists roles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  person_id INTEGER REFERENCES persons(id),
  film_id INTEGER REFERENCES films(id),
  category TEXT,
  detail TEXT
)

CREATE TABLE  if not exists studios (
  name TEXT PRIMARY KEY
)

CREATE TABLE  if not exists film_studio_map (
  film_id INTEGER REFERENCES films(id),
  studio_name TEXT REFERENCES studios(name),
  PRIMARY KEY (film_id, studio_name)
)

END_OF_SQL
  }

  if ("use loader") {
    require Rose::DB::Object::Loader;
    my $loader = Rose::DB::Object::Loader->new
      (db_class => __PACKAGE__,
       base_class => 'My::RDBO',
       class_prefix => 'My::RDBO',

      );
    my @classes = $loader->make_classes;
    push @classes,Search::ContextGraph->new;
    if ("show resulting classes") {
      foreach my $class (@classes) {
        #print "#" x 70, "\n";
        if ($class->isa('Rose::DB::Object')) {
 #         print $class->meta->perl_class_definition;
        } else {                # Rose::DB::Object::Manager subclasses
#          print $class->perl_class_definition, "\n";
        }
      }
    }
  }
}


1;
__DATA__















__DATA__
package AI::MicroStructure::Storage;
use AI::MicroStructure::Driver::CouchDB;
use base qw{AI::MicroStructure::Driver::CouchDB};
use strict;
use warnings;
our $VERSION='0.01';
1;

package AI::MicroStructure::Cache;
use AI::MicroStructure::Driver::Memcached;
use base qw{AI::MicroStructure::Driver::Memcached};
use strict;
use warnings;
our $VERSION='0.01';
1;

@ARGV=("hagen","hagen123pass","108.59.253.25");
die() unless($#ARGV==2);

my $x = AI::MicroStructure::Storage->new(uri=>"http://$ARGV[0]:$ARGV[1]\@$ARGV[2]:5984/",
                               db=>"hagen");

my $cache = AI::MicroStructure::Cache->new;
my $key = 'steem';
my $data = $x->retrieve($key);

$cache->store($key ,$data);
print Dumper $cache->retrieve($key);
1;


package main;
use Data::Dumper;
@ARGV=("hagen","hagen123pass","108.59.253.25");
die() unless($#ARGV==2);

my $x = AI::MicroStructure::Storage->new(uri=>"http://$ARGV[0]:$ARGV[1]\@$ARGV[2]:5984/",
                               db=>"hagen");

my $cache = AI::MicroStructure::Cache->new;
my $key = 'steem';
my $data = $x->retrieve($key);
print $data;
$x->store($key ,$data);
print Dumper $cache->retrieve($key);
1;

