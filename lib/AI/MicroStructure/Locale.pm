package AI::MicroStructure::Locale;
use strict;
use warnings;
use AI::MicroStructure (); # do not export metaname and friends
use AI::MicroStructure::MultiList;
use List::Util qw( shuffle );
use Carp;

our @ISA = qw( AI::MicroStructure::MultiList );

sub init {
    # alias the older package variable %Locale to %MultiList
    no strict 'refs';
    *{"$_[0]::Locale"}    = \%{"$_[0]::MultiList"};
    ${"$_[0]::Separator"} = '_';

    # call the parent class init code
    goto &AI::MicroStructure::MultiList::init;
}

sub new {
    my $class = shift;

    no strict 'refs';
    my $self = bless { @_, cache => [] }, $class;

    # compute some defaults
    if( ! exists $self->{category} ) {
        $self->{category} =
            exists $self->{lang}
            ? $self->{lang}
            : $ENV{LANGUAGE} || $ENV{LANG} || '';
        if( !$self->{category} && $^O eq 'MSWin32' ) {
            eval { require Win32::Locale; };
            $self->{category} = Win32::Locale::get_language() unless $@;
        }
    }

    my $cat = $self->{category};

    # support for territories
    if ( $cat && $cat ne ':all' ) {
        ($cat) = $cat =~ /^([-A-Za-z_]+)/;
        $cat = lc( $cat || '' );
        1 while $cat
            && !exists ${"$class\::MultiList"}{$cat}
            && $cat =~ s/_?[^_]*$//;
    }

    # fall back to last resort
    $self->{category} = $cat || ${"$class\::Default"};
    $self->_compute_base();
    return $self;
}

*lang      = \&AI::MicroStructure::MultiList::category;
*languages = \&AI::MicroStructure::MultiList::categories;

1;

__END__

