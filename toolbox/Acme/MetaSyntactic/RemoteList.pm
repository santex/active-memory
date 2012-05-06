package Acme::MetaSyntactic::RemoteList;
use strict;
use warnings;
use Carp;

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
    $str =~ tr{�������������������������������������������������������}
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

=head1 NAME

Acme::MetaSyntactic::RemoteList - Retrieval of a remote source for a theme

=head1 SYNOPSIS

    package Acme::MetaSyntactic::contributors;
    use strict;
    use Acme::MetaSyntactic::List;
    our @ISA = qw( Acme::MetaSyntactic::List );
    
    # data regarding the remote source
    our %Remote = (
        source =>
            'http://search.cpan.org/dist/Acme-MetaSyntactic/CONTRIBUTORS',
        extract => sub {
            my $content = shift;
            my @items   =
                map { Acme::MetaSyntactic::RemoteList::tr_nonword($_) }
                map { Acme::MetaSyntactic::RemoteList::tr_accent($_) }
                $content =~ /^\* (.*?)\s*$/gm;
            return @items;
        },
    );

    __PACKAGE__->init();

    1;

    # and the usual documentation and list definition

=head1 DESCRIPTION

This base class adds the capability to fetch a fresh list of items from a
remote source to any theme that requires it.

To be able to fetch remote items, an C<Acme::MetaSyntactic> theme must
define the package hash variable C<%Remote> with the appropriate keys.

The keys are:

=over 4

=item C<source>

The URL where the data is available.
This can also be an array reference containing several URLs, whose
content will be passed to the C<extract> subroutine.

=item C<extract>

A reference to a subroutine that extracts a list of items from a string.
The string is meant to be the content available at the URL stored in
the C<source> key.

=back

C<LWP::Simple> is used to download the remote data.

All existing C<Acme::MetaSyntactic> behaviours
(C<Acme::MetaSyntactic::List> and C<Acme::MetaSyntactic::Locale> are
subclasses of C<Acme::MetaSyntactic::RemoteList>.

=head1 METHODS

As an ancestor, this class adds the following methods to an
C<Acme::MetaSyntactic> theme:

=over 4

=item remote_list()

Returns the list of items available at the remote source, or an empty
list in case of error.

=item has_remotelist()

Return a boolean indicating if the C<source> key is defined (and therefore
if the theme actually has a remote list).

=item source()

Return the data structure containing the source URLs. This can be quite
different depending on the class: a single scalar (URL), an array
reference (list of URLs) or a hash reference (each value being either
a scalar or an array reference) for themes that are subclasses of
C<Acme::MetaSyntactic::MultiList>.

=item sources( [ $category ] )

Return the list of source URL. The C<$category> parameter can be used
to select the sources for a sub-category of the theme (in the case of
C<Acme::MetaSyntactic::MultiList>).

=item extract( $content )

Return a list of items from the C<$content> string. C<$content> is
expected to be the content available at the URL given by C<source()>.

=back

=head1 TRANSFORMATION SUBROUTINES

The C<Acme::MetaSyntactic::RemoteList> class also provides a few helper
subroutines that simplify the normalisation of items:

=over 4

=item tr_nonword( $str )

Return a copy of C<$str> with all non-word characters turned into
underscores (C<_>).

=item tr_accent( $str )

Return a copy of C<$str> will all iso-8859-1 accented characters turned
into basic ASCII characters.

=item tr_utf8_basic( $str )

Return a copy of C<$str> with some of the utf-8 accented characters turned
into basic ASCII characters. This is very crude, but I didn't to bother
and depend on the proper module to do that.

=back

=head1 AUTHOR

Philippe 'BooK' Bruhat, C<< <book@cpan.org> >>.

=head1 ACKNOWLEDGEMENTS

Thanks to Michael Scherer for his help in finding the name of this
module on C<#perlfr>. Welcome in F<CONTRIBUTORS>, Michael! C<:-)>

    #perlfr Tue Nov  1 19:33 CET 2005
    <@BooK> bon, je sais toujours pas comment appeler mon module moi
    <@BooK> AMS::RemoteSource ?
    < misc> RemoteListing ?
    <@BooK> RemoteList, m�me

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::List>,
L<Acme::MetaSyntactic::Locale>.

=head1 COPYRIGHT & LICENSE

Copyright 2005-2006 Philippe 'BooK' Bruhat, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

