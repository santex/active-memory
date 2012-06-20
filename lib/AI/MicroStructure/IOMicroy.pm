package AI::MicroStructure::IOMicroy;
use strict;
use warnings;
use DBI;
use Data::Dumper;

our ($LOG_dbh,$LOG_sth);

sub log {
my $table=shift;
my $self = shift;
my $key = shift;
my $value = shift;
$LOG_sth->{$table}->execute($self,$key,$value); 

#unless($LOG_dbh->do( "select count(*) from io where structure='".$key."' and structure='".$value."'" ));
}

 # log:


sub   INIT {
    our $Logname="/tmp/".(sprintf caller(0))."x.sqlite";
    
    # Connect
    $LOG_dbh=DBI->connect("DBI:SQLite:$Logname",'','',{ AutoCommit=>0,PrintError=>0,RaiseError=>0 });
    $LOG_dbh->do(<<"__SQL__");
        create table if not exists io (
            number text,
            structure text,
            item text
             );
__SQL__
  $LOG_dbh->do(<<"__SQL__");
        create table if not exists tags (
            number text,
            structure text,
            item text
             );
        
     
__SQL__
    $LOG_dbh->do(<<"__SQL__");
    
        create table if not exists personal (
            number text,
            structure varchar,
            item text
             );
    
__SQL__
 $LOG_dbh->do( "create index  if not exists numberIdx on io(number)" );
#$LOG_dbh->do( "create index  if not exists sink on io(structure)" );
$LOG_dbh->do( "create unique index if not exists  edge on io(item)" );
#$LOG_dbh->do( "create unique index  if not exists uniqueIdx   on io(structure)" );
    # Prepare an insert
    
    foreach(qw/io/){
    $LOG_sth->{$_}=$LOG_dbh->prepare(<<"__SQL__");
     insert into io (number,structure,item) values (?,?,?)
     
__SQL__

}
}


END { $LOG_dbh->commit(); $LOG_dbh->disconnect();  exit(0); };
1;


package main;

use AI::MicroStructure;
my $x = AI::MicroStructure->new();
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

