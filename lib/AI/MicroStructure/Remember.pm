#!/usr/bin/perl
package AI::MicroStructure::Remember;
    use strict;
    use warnings;
    use IO::File;
    sub TIESCALAR {
        my $class = shift;
        my $filename = shift;
        my $handle = IO::File->new( "> $filename" )
                         or die "Cannot open $filename: $!\n";
        print $handle "The Start\n";
        bless {FH => $handle, Value => 0}, $class;
    }
    sub FETCH {
        my $self = shift;
        return $self->{Value};
    }
    sub STORE {
        my $self = shift;
        my $value = shift;
        my $handle = $self->{FH};
        print $handle "$value\n";
        $self->{Value} = $value;
    }
    sub DESTROY {
        my $self = shift;
        my $handle = $self->{FH};
        print $handle "The End\n";
        close $handle;
    }
1;

