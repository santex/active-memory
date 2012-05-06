  package Asynchrotron;

  sub new {
    my $class = shift;
    my $self = bless { }, $class;
    use Data::Dumper;
    POE::Session->create(
      object_states => [
        $self => {
          _start       => "_poe_start",
          do_something => "_poe_do_something",
        },
      ],
    );
    return $self;
  }
sub _stop {}
sub alias_set {
    return shift;
}
  sub _poe_start {

    $_[KERNEL]->alias_set("$_[OBJECT]");
  }
#The alias allows object methods to pass events into the session without having to store something about the session. The POE::Kernel call() transfers execution from the caller session's context into the component's session.

  sub do_something {
    my $self = shift;
    print "Inside the caller's session right now: @_\n";
    $poe_kernel->call("$self", "do_something", @_);
  }

  sub _poe_do_something {
    my @args = @_[ARG0..$#_];
    print "Inside the component's session now: @args\n";
    print Dumper $poe_kernel->call("$self", "get_count", @_);
    $_[OBJECT]{count}++;
  }

#Both $_[HEAP] and $_[OBJECT] are visible within the component's session. $_[HEAP] can be used for ultra-private encapsulation, while $_[OBJECT] may be used for data visible by accessors.

  sub get_count {
    my $self = shift;
    return $self->{count}; # $_[OBJECT]{count} above
  }
  
1;  
package main;

use strict;

sub POE::Kernel::ASSERT_DEFAULT () { 1 }

use HTTP::Request;
use POE qw(Component::Client::HTTP);

use POE;
use POE::Component;
use Data::Dumper;
print Asynchrotron->new;



sub response_handler {
  my ($request_packet, $response_packet) = @_[ARG0, ARG1];
  my $request_object  = $request_packet->[0];
  my $response_object = $response_packet->[0];

  my $stream_chunk;

  if (!defined($response_object->content)) {
    $stream_chunk = $response_packet->[1];
  }

}


POE::Kernel->run();
exit;

