use strict;
use warnings;
use Data::Dumper;
use Storable::CouchDB;
use Test::More tests =>6;

BEGIN { 


  
  warn("Starting tests in $0\n".
    "     \n".
    "     \n")
  unless @ARGV == 1;


  use_ok('Cache::Rest');
  use_ok('Cache::ConfigRestCache');
  use_ok('LWP');
  use_ok('Storable::CouchDB');
};

  
  
  my $conf = Cache::ConfigRestCache->new;
  my $browser = LWP::UserAgent->new();  

  ok(defined($conf->{SOURCES}->{INDEX}->{URL}),"rest source file is defined");
  
  my $seite = $browser->get($conf->{SOURCES}->{INDEX}->{URL});
  ok($seite->is_success,"rest source file is acessable");
  
#ok( $seite->is_success, "Nonexistent document is undefined" );
#ok( !defined( $conf->has_doc( 'doc-101' )), "Nonexistent document is undefined" );

#äok( $conf->has_term( 'months-old black truffle'), "Found 'months-old black truffle'" );

#ok( $conf->has_term( 'ravioli'), "Found 'ravioli'" );
#is($conf->has_term( 'moustache' ), undef , "Nonexistent term is undefined" );
#äok( !defined( $conf->has_term( 'snake eyes' )), "Nonexistent term is undefined" );




  

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.
__DATA__

die "Die seite existiert nicht" unless $seite->is_success;
die "Der MIME-Typ der Rückgabe stimmt nicht, er sollte HTML sein, ist aber", $seite->content_type unless $seite->content_type eq 'text/html';
   
  my $s = Storable::CouchDB->new(uri=>"http://admin:allegiantG4\@localhost:5984");
  my $deepDataStructure = {q=>0..100};
  my $data = $s->retrieve('doc'); #undef if not exists
  $s->store('doc1' => "data");    #overwrites or creates if not exists
  $s->store('doc2' => {"my" => "data"});
  $s->store('doc3' => ["my", "data"]);
  $s->store('doc4' => undef);
  $s->store('doc5' => $deepDataStructure);
  $s->delete('doc');
  
