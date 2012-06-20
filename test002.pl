#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper;
use AI::MicroStructure;
use AI::MicroStructure::Ontology;
use AI::MicroStructure::Fitnes;
use AI::MicroStructure::Categorizer;
use AI::MicroStructure::Memorizer;
use AI::MicroStructure::Tree;
use AI::MicroStructure::Collection;
use AI::MicroStructure::IOMicroy;



@ARGV=("user",
      "pass",
      "localhost");

my $configure = (
{
  user=>$ARGV[0],
  pass=>$ARGV[1],
  dbfile=>sprintf("%s/active-memory/berkeley.dat",$ENV{HOME}),
  couchhost=>$ARGV[2],
  cachhost=>"localhost",
  cachhost=>"localhost",
  categories=>undef,
  couchport=>5984,
  couchdbname=>"user",
  cacheport=>22922,
  uri=>"",
  home=>$ENV{HOME},
  
});

$configure->{bookpath}=sprintf("%s/myperl/test/txt/ok",
                                $configure->{home});

$configure->{uri} = 
    sprintf("http://%s:%s\@%s:%s/",
        $configure->{user},
        $configure->{pass},
        $configure->{couchhost},
        $configure->{couchport});


my $memo   = AI::MicroStructure::Memorizer->new(bookpath=>$configure->{bookpath});
my $driver = AI::MicroStructure::Driver->new($configure);
my $fitnes = AI::MicroStructure::Fitnes->new($configure);
my $ontlgy = AI::MicroStructure::Ontology->new($configure);
my $cat    = AI::MicroStructure::Categorizer->new(bookpath=>$configure->{bookpath});


my $x = AI::MicroStructure->new(
"AI::MicroStructure::Driver"      =>  $driver,
"AI::MicroStructure::Ontology"    =>  $ontlgy,
"AI::MicroStructure::Fitnes"      =>  $fitnes,
"AI::MicroStructure::Memorizer"   =>  $memo,
"AI::MicroStructure::Categorizer" =>  $cat,
);


1;



__DATA__




my $lol =
               [
                 [
                   [ [ 'Det:The' ],
                     [ [ 'dog' ], 'N'], 'NP'],
                   [ '/with rabies\\', 'PP'],
                   'NP'
                 ],
                 [ 'died', 'VP'],
                 'S'
               ];
     
     

    
 my $tree = Tree::DAG_Node->lol_to_tree($lol);



$memo->perform_standard_tests;
#$memo->sampleRun();
            

             my $diagram = $tree->draw_ascii_tree;
              print map "$_\n", @$diagram;



my @docs  = $memo->getDocList();
my @terms = grep{length($_)<20}$memo->getTermList();


#print Dumper [@terms];
    
print $x->{tools}->{"AI::MicroStructure::Memorizer"}->{out};


#print Dumper $x->getBundle();
my $bundle = $x->getBundle();
my @ar=();

#print Dumper $memo;



#exit;
use WWW::Wikipedia;
my $wiki = WWW::Wikipedia->new();
my $result = "";


foreach my $main (keys %$bundle){

foreach(@{$bundle->{$main}}){

my  @bv = @{$memo->query_simple_intersection([$main,lc $_])};

if(defined($bv[0])){
push @ar,[$main,$_,\@bv];    

printf("\n%s=%s",$main,$_);
}

$result = $wiki->search(lc $_);
  if (defined($result) && $result->text() ) { 

    foreach(grep {/[(]*[)]/} $result->related()){
      $bundle->{instance}->{$_}=$result->text();

    }
  }

}
  
}

$driver->{'driver'}->{'couch'}->store("booknotes",[@ar,keys %{$bundle->{instance} } ]);




    print Dumper [$memo->query_simple_search("nasa")];
#    print Dumper [$memo->query_simple_intersection(),
 #                 $memo->query_simple_search("biotech")];
#







my $ix=0;
my @i=[0,0];    
    my $out = {};
    my @t = $x->themes;
    my @mods  =  grep/^[A-Z]/,keys %{{$x->find_modules}};
    my $i = (0,0);
      print dbg();
      foreach my $m (@mods){ printf("\n%s",$m);  }
      print dbg();
      foreach my $theme (@t){
        $i[0]++,
        $i[1]=0;

        my @names = map {$_=lc $_ } $x->name($theme,AI::MicroStructure->new( $theme )->name);


       
        foreach my $name (@names){
        
            AI::MicroStructure::IOMicroy::log("io",$ix++,$theme,$name,$#names);
            $out->{buff} .= sprintf("\n%s", join (" ",($#names,$theme,$name)));
        }
      }


sub dbg{
my $nl="\n";
return "@"x100;
}

print $out->{buff};#. `echo '$out->{buff}' | data-freq --limit 10`;

1;

__END__
warn "doclist";
exit 0;
#$x->{tools}->{"AI::MicroStructure::Memorizer"}->perform_standard_tests;

           #my $mem=$x->{tools}->{"AI::MicroStructure::Memorizer"};
             #$mem->threadSupport();
             #$mem->perform_standard_tests();


__DATA__

use JSON;
use Data::Dumper;
use AI::MicroStructure::Ontology;
use AI::MicroStructure::Fitnes;
use AI::MicroStructure::Categorizer;
use AI::MicroStructure::Memorizer;
#use Tree::DAG_Node;
use Tree::DAG_Node;
my @ISA = qw(Tree::DAG_Node);

our $configure = ();

INIT{



$configure->{bookpath}=sprintf("%s/myperl/test/txt/ok",
                                $configure->{home});

$configure->{uri} = 
    sprintf("http://%s:%s\@%s:%s/",
        $configure->{user},
        $configure->{pass},
        $configure->{couchhost},
        $configure->{couchport});
        

};

        
my $memo   = AI::MicroStructure::Memorizer->new(bookpath=>$configure->{bookpath});
my $driver = AI::MicroStructure::Driver->new($configure);
my $fitnes = AI::MicroStructure::Fitnes->new($configure);
my $ontlgy = AI::MicroStructure::Ontology->new($configure);
my $cat    = AI::MicroStructure::Categorizer->new(bookpath=>$configure->{bookpath});


my $x = AI::MicroStructure->new(
"AI::MicroStructure::Driver"      =>  $driver,
"AI::MicroStructure::Ontology"    =>  $ontlgy,
"AI::MicroStructure::Fitnes"      =>  $fitnes,
"AI::MicroStructure::Memorizer"   =>  $memo,
"AI::MicroStructure::Categorizer" =>  $cat,
);


 for i in `perl -MAI::MicroStructure -le 'print for AI::MicroStructure->themes;'`; do echo $i; done
 
 count=0; for i in `perl -MAI::MicroStructure -le 'print  for AI::MicroStructure->themes';`; do echo "@@@@@@@@@@<SET>@@@@@@@@@@@@<"$count">@@@@@@@@@<"$i">@@@@@@@@@"; count=$(expr $count + 1); perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(",", $m->name(scalar $m));'; perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(",",$m->name(scalar $m)); print join(",",$m->categories()); print 1; $ENV{LANGUAGE} , $ENV{LANG}; ';   done

