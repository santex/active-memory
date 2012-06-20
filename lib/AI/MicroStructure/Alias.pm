package AI::MicroStructure::Alias;
use strict;
use warnings;
use Carp;

sub init {
    my ( $self, $alias ) = @_;
    my $class = caller(0);

    eval "require AI::MicroStructure::$alias;";
    croak "Aliased theme AI::MicroStructure::$alias failed to load: $@"
        if $@;

    no strict 'refs';
    no warnings;

    # copy almost everything over from the original
    for my $k ( grep { ! /^(?:Theme|meta|import)$/ }
        keys %{"AI::MicroStructure::$alias\::"} )
    {
        *{"$class\::$k"} = *{"AI::MicroStructure::$alias\::$k"};
    }

    # local things
    ${"$class\::Theme"} = ( split /::/, $class )[-1];
    ${"$class\::meta"}  = $class->new();
    *{"$class\::import"} = sub {
        my $callpkg = caller(0);
        my $theme   = ${"$class\::Theme"};
        my $meta    = $class->new();
        *{"$callpkg\::meta$theme"} = sub { $meta->name(@_) };
      };
}

1;

__END__
