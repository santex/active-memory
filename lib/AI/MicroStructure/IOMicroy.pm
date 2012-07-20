#!/usr/bin/perl -w
package IOMicroy;
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


INIT {
    our $Logname="/tmp/".(sprintf caller(0))."x.sqlite";
    
    # Connect
    $LOG_dbh=DBI->connect("DBI:SQLite:$Logname",'','',{ AutoCommit=>0,PrintError=>0,RaiseError=>0 });

    $LOG_dbh->do(<<"__SQL__");
        create table if not exists concepts (
            number text,
            structure text,
            item text
             );
__SQL__


    $LOG_dbh->do(<<"__SQL__");
        create table if not exists instance (
            number text,
            structure text,
            item text
             );
__SQL__


    $LOG_dbh->do(<<"__SQL__");
        create table if not exists member (
            number text,
            structure text,
            item text
             );
__SQL__





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
$LOG_dbh->do("create view score as select *,ROUND(replace(item,\",\",\"0\")/1000000)  as id from instance order by  id desc;" );
    # Prepare an insert
    
    foreach(qw/io personal concepts instance member/){
    $LOG_sth->{$_}=$LOG_dbh->prepare(<<"__SQL__");
     insert into $_ (number,structure,item) values (?,?,?)
     
__SQL__

}

}

END {  $LOG_dbh->commit(); $LOG_dbh->disconnect();   };

1;
