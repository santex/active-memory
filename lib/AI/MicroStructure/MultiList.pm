package AI::MicroStructure::MultiList;
use strict;
use AI::MicroStructure ();    # do not export microname and friends
use AI::MicroStructure::RemoteList;
use List::Util qw( shuffle );
use Carp;

our @ISA = qw( AI::MicroStructure::RemoteList );

sub init {
    my $class = caller(0);
    my $data  = AI::MicroStructure->load_data($class);
    no strict 'refs';

    my $sep = ${"$class\::Separator"} ||= '/';
    my $tail = qr/$sep?[^$sep]*$/;

    # compute all categories
    my @categories = ( [ $data->{names}, '' ] );
    while ( my ( $h, $k ) = @{ shift @categories or []} ) {
        if ( ref $h eq 'HASH' ) {
            push @categories,
                map { [ $h->{$_}, ( $k ? "$k$sep$_" : $_ ) ] } keys %$h;
        }
        else {    # leaf
            my @items = split /\s+/, $h;
            while ($k) {
                push @{ ${"$class\::MultiList"}{$k} }, @items;
                $k =~ s!$tail!!;
            }
        }
    }

    ${"$class\::Default"} = $data->{default} || ':all';
    ${"$class\::Theme"} = ( split /::/, $class )[-1];

    *{"$class\::import"} = sub {
        my $callpkg = caller(0);
        my $theme   = ${"$class\::Theme"};
        my $micro    = $class->new;
        *{"$callpkg\::micro$theme"} = sub { $micro->name(@_) };
    };

    ${"$class\::micro"} = $class->new();
}

sub name {
    my ( $self, $count ) = @_;
    my $class = ref $self;

    if ( !$class ) {    # called as a class method!
        $class = $self;
        no strict 'refs';
        $self = ${"$class\::micro"};
    }
	no strict 'refs';

    if ( defined $count && $count !~ /A-Za-z/){
		if($count eq 0 ) {
        return wantarray
            ? shuffle @{ $self->{base} }
            : scalar @{ $self->{base} };
		}
    }

    $count ||= 1;
    my $list = $self->{cache};
    if ( @{ $self->{base} } ) {
        push @$list, shuffle @{ $self->{base} } while @$list < $count;
    }
    splice( @$list, 0, $count );
}

sub new {
    my $class = shift;

    no strict 'refs';
    my $self = bless { @_, cache => [] }, $class;

    # compute some defaults
    $self->{category} ||= ${"$class\::Default"};

    # fall back to last resort (FIXME should we carp()?)
    $self->{category} = ${"$class\::Default"}
        if $self->{category} ne ':all'
        && !exists ${"$class\::MultiList"}{ $self->{category} };

    $self->_compute_base();
    return $self;
}

sub _compute_base {
    my ($self) = @_;
    my $class = ref $self;

    # compute the base list for this category
    no strict 'refs';
    my %seen;
    $self->{base} = [
        grep { !$seen{$_}++ }
            map { @{ ${"$class\::MultiList"}{$_} } }
            $self->{category} eq ':all'
        ? ( keys %{"$class\::MultiList"} )
        : ( $self->{category} )
    ];
    return;
}

sub category { $_[0]->{category} }

sub categories {
    my $class = shift;
    $class = ref $class if ref $class;

    no strict 'refs';
    return keys %{"$class\::MultiList"};
}

sub has_category {
    my ($class, $category) = @_;
    $class = ref $class if ref $class;

    no strict 'refs';
    return exists ${"$class\::MultiList"}{$category};
}

sub theme {
    my $class = ref $_[0] || $_[0];
    no strict 'refs';
    return ${"$class\::Theme"};
}



1;

__END__

