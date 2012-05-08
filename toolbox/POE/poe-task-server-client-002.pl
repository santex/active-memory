#!/usr/bin/perl
use warnings;
use strict;
use POE;
use POE::Filter::Reference;
use POE::Component::Server::TCP;
use POE::Component::Client::TCP;
### Create a server that receives and sends Perl data structures.  It
### will be referred to by the name "sum-server" when necessary.  It
### listens on localhost port 12345.  It uses POE::Filter::Reference
### to parse input and format output.
POE::Component::Server::TCP->new(
  Alias        => "sum_server",
  Address      => "localhost",
  Port         => 12345,
  ClientFilter => "POE::Filter::Reference",

  # Handle client requests here.
  ClientInput => sub {
    my ($heap, $list) = @_[HEAP, ARG0];
    my $sum = 0;
    my (@odd, @even, @bad, $status);

    # Process the request into buckets for odd, even, and
    # non-integers.  Sum the integers in the request.
    if (ref($list) eq 'ARRAY') {
      foreach (@$list) {
        if (/^\d+$/) {
          if   ($_ % 2) { push @odd,  $_; }
          else          { push @even, $_; }
          $sum += $_;
        }
        else {
          push @bad, $_;
        }
      }
      $status = "OK";
    }
    else {
      $status = "Error: Bad request type: " . ref($list);
    }

    # Build the response hash, then send it to the client.
    my %response = (
      sum  => $sum,
      odd  => \@odd,
      even => \@even,
      bad  => \@bad,
      stat => $status,
    );
    $heap->{client}->put(\%response);
  },

  # Since this is a one-shot test program, shut down the server
  # after the first client has disconnected.  This posts "shutdown"
  # to the server itself.  Using yield() here would just shut down
  # the client connection.
  ClientDisconnected => sub {
    my $kernel = $_[KERNEL];
    $kernel->post(sum_server => "shutdown");
  },
);
### Create a client that sends and receives Perl data structures.
### Upon connecting with the server, it sends a list of things to
### process.  The server responds with a hash of a few things.  Upon
### receipt of that hash, the client displays its contents and exits.
POE::Component::Client::TCP->new(
  Alias         => "sum_client",
  RemoteAddress => "localhost",
  RemotePort    => 12345,
  Filter        => "POE::Filter::Reference",

  # Build a request and send it.
  Connected => sub {
    my $heap = $_[HEAP];
    my @request =
      qw( 0 2.718 3 3.1416 5 6 7 8 9 four score and seven years ago );
    $heap->{server}->put(\@request);
  },

  # Receive a response, display it, and shut down the client.
  ServerInput => sub {
    my ($kernel, $hash) = @_[KERNEL, ARG0];
    if (ref($hash) eq 'HASH') {
      print "Client received:\n";
      foreach (sort keys %$hash) {
        my $value = $hash->{$_};
        $value = "@$value" if ref($value) eq 'ARRAY';
        printf "\t%-4s = $value\n", $_;
      }
    }
    else {
      print "Client received an unknown response type: ", ref($hash), "\n";
    }
    $kernel->yield("shutdown");
  },
);
### Run both the client and server.  Yes, in the same program.
$poe_kernel->run();
