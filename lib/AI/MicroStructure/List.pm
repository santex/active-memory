package AI::MicroStructure::List;
use strict;
use AI::MicroStructure (); # do not export metaname and friends
use AI::MicroStructure::RemoteList;
use List::Util qw( shuffle );
use Carp;

our @ISA = qw( AI::MicroStructure::RemoteList );

sub init {
    my ($self, $data) = @_;
    my $class = caller(0);

    $data ||= AI::MicroStructure->load_data($class);
    croak "The optional argument to init() must be a hash reference"
      if ref $data ne 'HASH';

    no strict 'refs';
    no warnings;
    ${"$class\::Theme"} = ( split /::/, $class )[-1];
    @{"$class\::List"} = split /\s+/, $data->{names};
    *{"$class\::import"} = sub {
        my $callpkg = caller(0);
        my $theme   = ${"$class\::Theme"};
        my $meta    = $class->new();
        *{"$callpkg\::meta$theme"} = sub { $meta->name(@_) };
      };
    ${"$class\::meta"} = $class->new();
}

sub name {
    my ( $self, $count ) = @_;
    my $class = ref $self;

    if( ! $class ) { # called as a class method!
        $class = $self;
        no strict 'refs';
        $self = ${"$class\::meta"};
    }
	no strict 'refs';

    if( defined $count){
    if ($count == 0 ) {
        return
          wantarray ? shuffle @{"$class\::List"} : scalar @{"$class\::List"};
    }
    }
    $count ||= 1;
    my $list = $self->{cache};
    {
      no strict 'refs';
      if (@{"$class\::List"}) {
          push @$list, shuffle @{"$class\::List"} while @$list < $count;
      }
    }
    splice( @$list, 0, $count );
}

sub new {
    my $class = shift;

    bless { cache => [] }, $class;
}

sub theme {
    my $class = ref $_[0] || $_[0];
    no strict 'refs';
    return ${"$class\::Theme"};
}




1;

__END__

