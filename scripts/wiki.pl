#!/usr/bin/perl -w
# moose numbers

package Runner;
use Data::Dumper;
use strict;
$|++;

use constant POCO_HTTP => "ua";
use POE qw(Component::Client::HTTP);
use  AI::MicroStructure::Driver::CouchDB;
my @urls =[map{$_="$_";}@ARGV];
   @urls = ["http://en.wikipedia.org/wiki/Galaxies"] unless(defined(@ARGV));
my $TOP = "http://en.wikipedia.org/wiki/";



print Dumper  @urls;

@ARGV=("hagen","hagen123pass","localhost");
our $x = AI::MicroStructure::Driver::CouchDB->new(uri=>"http://$ARGV[0]:$ARGV[1]\@$ARGV[2]:5984/",
                               db=>"wikilist");




POE::Component::Client::HTTP->spawn(Alias => POCO_HTTP, Timeout => 30);
POE::Component::My::Master->spawn(UA => POCO_HTTP, TODO => @urls);
$poe_kernel->run;
exit 0;

BEGIN {
  package POE::Component::My::Master;
  use POE::Session;             # for constants

  sub spawn {
    my $class = shift;
    POE::Session->create
        (package_states =>
         [$class => [qw(_start ready done)]],
         heap => {KIDMAX => 8, KIDS => 0, @_});
  }

  sub _start {
    my $heap = $_[HEAP];
    for (@{$heap->{TODO}}) {
      $heap->{DONE}{$_ = make_canonical($_)} = 1;
    }
    $_[KERNEL]->yield("ready", "initial");
  }

  sub ready {
    ## warn "ready because $_[ARG0]\n";
    my $heap = $_[HEAP];
    my $kernel = $_[KERNEL];
    return if $heap->{KIDS} >= $heap->{KIDMAX};
    return unless my $url = shift @{$heap->{TODO}};
    ## warn "doing: $url\n";
    $heap->{KIDS}++;
    POE::Component::My::Checker->spawn
        (UA => $heap->{UA},
         URL => $url,
         POSTBACK => $_[SESSION]->postback("done", $url),
        );
    $kernel->yield("ready", "looping");
  }

  sub done {
    my $heap = $_[HEAP];
    my ($request,$response) = @_[ARG0,ARG1];

    my ($url) = @$request;
    my @links = @{$response->[0]};

    for (@links) {
      my $next = sprintf( "%d", rand($#links+1));
      $_ = make_canonical($links[$next]);

      push @{$heap->{TODO}},$_
        unless $heap->{DONE}{$_}++;
    }

    $heap->{KIDS}--;
    $_[KERNEL]->yield("ready", "child done");
  }

  sub make_canonical {          # not a POE
    require URI;
    my $uri = URI->new(shift);
    $uri->fragment(undef);      # toss fragment
    $uri->canonical->as_string; # return value
  }

}                               # end POE::Component::My::Master

BEGIN {
  package POE::Component::My::Checker;
  use POE::Session;

  sub spawn {
    my $class = shift;
    POE::Session->create
        (package_states =>
         [$class => [qw(_start response)]],
         heap => {@_});
  }

  sub _start {
    require HTTP::Request::Common;
    my $heap = $_[HEAP];
    my $url = $heap->{URL};
    my $request = HTTP::Request::Common::GET($url);
    $_[KERNEL]->post($heap->{UA}, 'request', 'response', $request);
  }





  sub response {
    my $url = $_[HEAP]{URL};
    my ($request_packet, $response_packet) = @_[ARG0, ARG1];
    my ($request, $request_tag) = @$request_packet;
    my ($response) = @$response_packet;

    my @links;

    if ($response->is_success) {

      if ($response->base =~ m{$TOP}) {
        if ($response->content_type eq "text/html") {
          my $doc={};
          my $linkdata={};
          use Data::Dumper;
          require HTML::SimpleLinkExtor;
          no warnings 'utf8';
          my $e = HTML::SimpleLinkExtor->new($response->base);
          $e->parse($response->decoded_content);
          @links = grep {/$TOP/}grep{!/Disambig|Help:|Wikipedia:|Special:|:Contents|:Featured_content|Main_Pag|_talk:|Talk:|#|[Aa]rticle[s|_]|All_*_*/}$e->links;
          foreach(@links){
  
            $linkdata->{base}->{$_} = 1 unless($linkdata->{base}->{$_});
          
          }
          @links = keys %{$linkdata->{base}};
          $linkdata->{image}=[grep{/^http.*.[\.](JPG|GIF|PNG|svg|jpg|png|gif)$/}@links];
          $linkdata->{audio}=[grep{/^http.*.[\.](mp3|wave|ogg|OGG|WAVE|MP3)$/}@links];
          $linkdata->{video}=[grep{/^http.*.[\.](mpeg4|avi|mpeg|MPEG4|AVI|MPEG4)$/}@links];
          $linkdata->{pdf}=[grep{/^http.*.[\.](pdf|PDF)$/}@links];

          # 
           #warn $#links."\n";
            use WWW::Wikipedia;
            my $wiki = WWW::Wikipedia->new();

            $url =~ s/$TOP//g;
          my $result = $wiki->search($url);
          if (defined($result) && $result->text() ) {
          use HTML::Strip;

         my $hs = HTML::Strip->new();

         my $clean_text = $hs->parse($result->text() );
         $hs->eof;

#            print "\n"x10,$clean_text;
             warn $url;
             $doc={};
             $doc->{linknr}=$#links;
             $doc->{url}=$url;
             $doc->{tags}=[map{$_=~s/\)//g; $_=~s/ /_/g; $_=[split("_\\(",$_)] }grep {/[(].+?[)]/} $result->related()];
             $doc->{instances}= {};
             $doc->{members}={};
             
             foreach(@{$doc->{tags}}){
              $doc->{instances}->{$_->[0]}=$_->[1];

             }
             $doc->{members}=[keys %{$doc->{instances}}];
             $doc->{instances}=[values %{$doc->{instances}}];
             $doc->{article}=$clean_text;
             $doc->{links}=[sort split("\n",join( "\n",@links ))];
             $doc->{image}=$linkdata->{image};
             $doc->{audio}=$linkdata->{audio};
             $doc->{video}=$linkdata->{video};
             $doc->{pdf}=$linkdata->{pdf};
            # join( "\n",@links );


          $x->store("$url" ,$doc) unless(!$doc);
          }
          $_[HEAP]{POSTBACK}(\@links);

        }
        } else {
          # warn "not HTML: $url\n";
        }
    } else {
    }


  }
}                               # end POE::Component::My::Checker


use Data::Dumper;
    print Dumper $_[HEAP];
