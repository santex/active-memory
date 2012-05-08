#!/usr/bin/perl -w
# $Id$
# This program implements a fun little neural network.  The network
# doesn't accomplish anything particularly useful; it just shows
# another way that POE can be used to simulate concurrency.
use strict;
use POE;

# Initialize a neuron session when it's first instantiated.  Save its
# parameters within itself, and set an alias for the neuron so it can
# be referred to by name later.
sub neuron_start {
  my ($kernel, $session, $heap, $neuron_name, $threshhold, $low_fire,
    $high_fire) = @_[KERNEL, SESSION, HEAP, ARG0 .. ARG3];

  # Save things this neuron needs to know about itself.
  $heap->{name}       = $neuron_name;
  $heap->{threshhold} = $threshhold;
  $heap->{low_fire}   = $low_fire;
  $heap->{high_fire}  = $high_fire;
  $heap->{value}      = 0;

  # Register the neuron's name.
  $kernel->alias_set($neuron_name);

  # Be noisy for the sake of science.
  print "Neuron '$heap->{name}' started.\n";
}

# The neuron has received a stimulus.  Accumulate the stimulus, and
# fire outbound stimuli if its incoming stimulus threshhold has been
# exceeded.
sub neuron_stimulated {
  my ($kernel, $session, $heap, $value) = @_[KERNEL, SESSION, HEAP, ARG0];

  # Add the stimulus to the neuron's accumulator, and be noisy.
  $heap->{value} += $value;
  print "Neuron $heap->{name} received $value and now has $heap->{value}.\n";

  # If this stimulus pushes the neuron over a threshhold, then fire a
  # stimulus to the "high" neighbor neuron.  If there's no such
  # neuron, then move on to "low" bit.
  if ($heap->{value} >= $heap->{threshhold}) {
    if (length $heap->{high_fire}) {
      $kernel->post($heap->{high_fire}, stimulate => 10);
      print("Neuron $heap->{name} reached its threshhold and fired to ",
        "$heap->{high_fire}.\n");
    }
    else {
      print("Neuron $heap->{name} reached its threshhold and has ",
        "nothing to do.\n");
    }

    # Reset the accumulator so this neuron is never stuck in a "high"
    # state.
    $heap->{value} = 0;
  }

  # Always fire a stimulus to the low-threshhold neuron, but do this
  # after a brief, random delay.  This uses delay_add() to enqueue
  # multiple redundant delays.  If it used delay(), each call would
  # overwrite the previous one.
  if (length $heap->{low_fire}) {
    $kernel->delay_add(respond_later => rand(5));
  }
}

# Respond after a delay.  The delay is done, and we can now fire a
# low-threshhold event.
sub neuron_delayed_response {
  my ($kernel, $heap) = @_[KERNEL, HEAP];
  $kernel->post($heap->{low_fire}, stimulate => 10);
  print "Neuron $heap->{name} has fired a stimulus to $heap->{low_fire}.\n";
}

# This defines a small (probably pointless) neural network.  Each
# record has four fields.  The first two are about the neuron itself:
# Its name, and its stimulus accumulator's overflow threshhold.  The
# other two fields are neurons to send stimuli to when an incoming
# stimulus is too weak or overflows the neuron's accumulator.
my @neural_net = (
  ['one',   10,  'one',   'two'],
  ['two',   20,  'three', 'four'],
  ['three', 30,  'five',  'six'],
  ['four',  50,  'seven', 'eight'],
  ['five',  100, 'nine',  'ten'],
  ['six',   70,  'seven', 'eight'],
  ['seven', 80,  'nine',  'ten'],
  ['eight', 40,  'nine',  'ten'],
  ['nine',  60,  '',      'ten'],
  ['ten',   90,  '',      ''],
);

# A quick and dirty way to spawn neurons.  It scans the list of
# neurons and passes each record to a new Session.  POE::Session maps
# event names to the functions that will handle those events.  For
# example, "_start" will be handled by neuron_start().
foreach (@neural_net) {
  my ($name, $threshhold, $low, $high) = @$_;
  POE::Session->create(
    inline_states => {
      _start        => \&neuron_start,
      stimulate     => \&neuron_stimulated,
      respond_later => \&neuron_delayed_response,
    },

    #         ARG0,  ARG1,        ARG2, ARG3 ... for neuron_start
    args => [$name, $threshhold, $low, $high],
  );
}

# Prod the network into life by giving it an initial stimulus.  Neuron
# "one" is designed to constantly generate new stimuli, so poking it
# once will set it throbbing indefinitely.
$poe_kernel->post(one => stimulate => 10);

# Run the neural network until Dave arrives to unplug it, or Zaphod
# pops 'round with an axe.  If you don't know a Dave or Zaphod, you
# can simply stop it with Ctrl+C.
$poe_kernel->run();
exit 0;
