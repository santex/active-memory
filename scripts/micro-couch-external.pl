 package MyProcess;
  use base qw/AI::MicroStructure::ExternalProcess/;

  sub _before {
      my ($self, $request) = @_;
      # Do something with the hashref $request
      return $request;
  }

  sub hello_world  {
      my ($self, $req) = @_;
      my $response = {
          body => "Hello, " . $req->{query}->{greeting_target} . "!"
      };
      return $response;
  }

  sub _after {
      my ($self,$response) = @_;
      # Do something with the hashref $response
      return $response;
  }
  
  1;
