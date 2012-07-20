#!/usr/bin/perl	-W
package AI::MicroStructure::Driver;
use strict;
use warnings;
use JSON;
use Data::Dumper;
use Carp;
use AI::MicroStructure::ObjectSet;
use AI::MicroStructure::Driver::CouchDB;
use AI::MicroStructure::Driver::Memcached;
use AI::MicroStructure::Driver::BerkeleyDB;

use vars qw(
  $configure
	$pi
	$driver
	);




sub import {
	## print "import called with @_\n";
	local $configure = @_; # shame that Getopt::Long isn't structured better!
	use Getopt::Long ();


  


	Getopt::Long::GetOptions( '-',
		'driver=f'=>\$driver,
		'configure=f'=>\$configure,
		) or croak("bad import arguments");

    
} # end subroutine import definition


sub new {
  
  my($class,$args) = @_;
 
  my $self = bless { cache => [] }, $class;
  $configure = $args;
  
  $self->import;
  $self->connectDriver;

 
  return $self;
}




sub initialize {
  my $self = shift();
 %$self= @_;

}


sub defaultDriver {

  my $self = shift;


    $configure->{pass} = "pass" unless($configure->{pass});
    $configure->{filename} = "/tmp/berkeleysDB.dat" unless($configure->{filename});
    $configure->{couchport} = 5984 unless($configure->{couchport});
    $configure->{cacheport} = 22922 unless($configure->{cacheport});
    $configure->{couchhost} = "localhost" unless($configure->{couchhost});
    $configure->{cachehost} = "127.0.0.1" unless($configure->{cachehost});
    $configure->{user} = `whoami`unless($configure->{user});
    $configure->{user} =~ s/\n//g unless($configure->{user});
    $configure->{pass} = "pass" unless($configure->{pass});

    $configure->{uri} = sprintf("http://%s:%s\@%s:%s/",$configure->{user},
                                                       $configure->{pass},
                                                       $configure->{couchhost},
                                                       $configure->{couchport});



    return $configure;
  
  }


  
sub connectDriver{


  my $self = shift;



   if( scalar keys %$configure < 8){

      warn("User needs to configure the driver\nadd \$configure | \@ARGV\n\nattemptting bypass");   
      
      
      $self->{configure} = $self->defaultDriver($configure);
      
      warn Dumper $self->{configure};
      
   }else{
   
      $self->{configure} = $configure;
   }
  
  $self->{driver}->{'berkeley'}   =AI::MicroStructure::Driver::BerkeleyDB->new($self->{configure}->{filename});

  $self->{driver}->{'memcache'} =AI::MicroStructure::Driver::Memcached->new($self->{configure}->{cachehost},$self->{configure}->{cacheport});


  $self->{driver}->{'couch'}  =AI::MicroStructure::Driver::CouchDB->new( user=>$self->{configure}->{user},
                                                           auth=>$self->{configure}->{pass},
                                                           host=>$self->{configure}->{couchhost},
                                                           uri=> $self->{configure}->{uri} ,
                                                           dbname=>$self->{configure}->{couchdbname}) or warn  $self->{configure}->{uri};

  $self->{driver}->{categories} = $self->{configure}->{categories};
  $self->{driver}->{documents}  = $self->{configure}->{documents};
  $self->{driver}->{query}  = $self->{configure}->{query};

  #print Dumper $self;



}

1;
