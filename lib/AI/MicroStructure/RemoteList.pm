package AI::MicroStructure::RemoteList;
use strict;
use warnings;
use Carp;
use Data::Dumper;
# method that extracts the items from the remote content and returns them
sub extract {
    my $class = ref $_[0] || $_[0];
    no strict 'refs';
    my $func  = ${"$class\::Remote"}{extract};

    # provide a very basic default
    my $meth = ref $func eq 'CODE'
        ? sub { my %seen; return grep { !$seen{$_}++ } $func->( $_[1] ); }
        : sub { return $_[1] };    # very basic default

    # put the method in the subclass symbol table (at runtime)
    *{"$class\::extract"} = $meth;

    # now run the function^Wmethod
    goto &$meth;
}

# methods related to the source URL
sub source {
    my $class = ref $_[0] || $_[0];
    no strict 'refs';

    return ${"$class\::Remote"}{source};
}

sub sources {
    my $class = ref $_[0] || $_[0];
    no strict 'refs';

    my $src = ${"$class\::Remote"}{source};
    if ( ref $src eq 'ARRAY' ) {
        return @$src;
    }
    elsif ( ref $src eq 'HASH' ) {
        return
            map { ref $_ ? @$_ : $_ } $_[1] ? $src->{ $_[1] } : values %$src;
    }
    return $src;
}

sub has_remotelist { return defined $_[0]->source(); }

# main method: return the list from the remote source
sub remote_list {
#  print Dumper @_;


    my $class = ref $_[0] || $_[0];
    return unless $class->has_remotelist();

    # check that we can access the network
    eval {
        require LWP::UserAgent;
        die "version 5.802 required ($LWP::VERSION installed)\n"
            if $LWP::VERSION < 5.802;
    };
    if ($@) {
        carp "LWP::UserAgent not available: $@";
        return;
    }

    # fetch the content
    my @items;
    my @srcs = $class->sources($_[1]);
    my $ua   = LWP::UserAgent->new( env_proxy => 1 );
    foreach my $src (@srcs) {
        my $res  = $ua->request( HTTP::Request->new( GET => $src ) );
        if ( ! $res->is_success() ) {
            carp "Failed to get content at $src (" . $res->status_line();
            return;
        }

        # extract, cleanup and return the data
        # if decoding the content fails, we just deal with the raw content
        push @items =>
            $class->extract( $res->decoded_content() || $res->content() );

    }

    # return unique items
    my %seen;
    return grep { !$seen{$_}++ } @items;
}

#
# transformation subroutines
#
sub tr_nonword {
    my $str = shift;
    $str =~ tr/a-zA-Z0-9_/_/c;
    $str;
}

sub tr_accent {
    my $str = shift;
    $str =~ tr{ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüýÿ}
              {AAAAAACEEEEIIIINOOOOOOUUUUYaaaaaaceeeeiiiinoooooouuuuyy};
    return $str;
}

my %utf2asc = (
    "\xc3\x89" => 'E',
    "\xc3\xa0" => 'a',
    "\xc3\xa1" => 'a',
    "\xc3\xa9" => 'e',
    "\xc3\xaf" => 'i',
    "\xc3\xad" => 'i',
    "\xc3\xb6" => 'o',
    "\xc3\xb8" => 'o',
    "\xc5\xa0" => 'S',
    "\x{0160}" => 'S',
    # for pokemons
    "\x{0101}"     => 'a',
    "\x{012b}"     => 'i',
    "\x{014d}"     => 'o',
    "\x{016b}"     => 'u',
    "\xe2\x99\x80" => 'female',
    "\xe2\x99\x82" => 'male',
    "\x{2640}"     => 'female',
    "\x{2642}"     => 'male',
);
my $utf_re = qr/(@{[join( '|', sort keys %utf2asc )]})/; 

sub tr_utf8_basic {
    my $str = shift;
    $str =~ s/$utf_re/$utf2asc{$1}/go;
    return $str;
}

1;

__END__


