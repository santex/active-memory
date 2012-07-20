#!/usr/bin/perl -W
package AI::MicroStructure;
use strict;
use warnings;
use Carp;
use File::Basename;
use File::Spec;
use File::Glob;
use Data::Dumper;
use AI::MicroStructure::Driver;
our $VERSION = '0.01';
our $Theme = 'any'; # default theme
our %META;
our %MODS;
our %ALIEN;
# private class method
our $str = "[A-Z]";
our $special = "any";
our $search;
our $data={};
our $item="";
our @items;
our @a=();

our ($new,$debug, $write) =(0,0,0); 
 
if( grep{/\bnew\b/} @ARGV ){ $new = 1; cleanArgs("new"); }
if( grep{/\bdebug\b/} @ARGV ){$debug = 1; cleanArgs("debug"); }; 
if( grep{/\bwrite\b/} @ARGV ){ $write = 1; cleanArgs("write");  }; 


sub cleanArgs{
    my ($key) = @_; 
    my @tmp=();
    foreach(@ARGV){ 
    push @tmp,$_ unless($_=~/$key/);}
    
    @ARGV=@tmp;
}
# private class method
sub find_themes {
    my ( $class, @dirs ) = @_;
      $ALIEN{"base"} =  [map  @$_,
              grep { $_->[0] !~ /^([A-Z]|foo)/ }    # remove the non-theme subclasses
              map  { [ ( fileparse( $_, qr/\.pm$/ ) )[0] => $_ ] }
              map  { File::Glob::bsd_glob( File::Spec->catfile( $_, qw( AI MicroStructure *.pm ) ) ) } @dirs];
              
      $ALIEN{"store"}=[];
      
      
      return @{$ALIEN{"base"}};
}

# fetch the list of standard themes


sub find_modules {


 my $themes = {};
   foreach(@INC)
   {

    my @set =  grep /($str)/,   map  @$_,
                map  { [ ( fileparse( $_, qr/\.pm$/ ) )[0] => $_ ] }
                map  { File::Glob::bsd_glob( File::Spec->catfile( $_, qw( AI MicroStructure *.pm ) ) ) } $_;

    foreach(@set){
      $themes->{$_}=$_;# unless($_=~/(usr\/local|basis)/);
    }
  }
  return %$themes;
}



$META{$_} = 0 for keys %{{__PACKAGE__->find_themes(@INC)} };
$MODS{$_} = $_ for keys %{{__PACKAGE__->find_modules(@INC)} };
$search = join("|",keys %META);
if( grep{/$search/} @ARGV ){ $Theme = $ARGV[0]; }; 

# fetch the list of standard themes

#print Dumper keys %META;
sub getComponents(){
  
  my $x= sprintf("%s",Dumper keys %META);

  return $x;
}


# the functions actually hide an instance
my $meta = AI::MicroStructure->new($Theme);

# END OF INITIALISATION

# support for use AI::MicroStructure 'stars'
# that automatically loads the required classes
sub import {
    my $class = shift;

    my @themes = ( grep { $_ eq ':all' } @_ )
      ? ( 'stars', grep { !/^(?:stars|:all)$/ } keys %META ) # 'stars' is still first
      : @_;

    $Theme = $themes[0] if @themes;
    $meta = AI::MicroStructure->new( $Theme );

    # export the metaname() function
    no strict 'refs';
    my $callpkg = caller;
    *{"$callpkg\::metaname"} = \&metaname;    # standard theme

    # load the classes in @themes
    for my $theme( @themes ) {
        eval "require AI::MicroStructure::$theme; import AI::MicroStructure::$theme;";
        croak $@ if $@;
        *{"$callpkg\::meta$theme"} = sub { $meta->name( $theme, @_ ) };
    }
}

sub new {
     my ( $class, @tools ) = ( @_ );
    my $theme;
    $theme = shift @tools if @tools % 2;
    $theme = $Theme unless $theme; # same default everywhere
 #   my $driver = {};
#       $driver = AI::MicroStructure::Driver->new;

    # defer croaking until name() is actually called
    bless { theme => $theme, tools => { @tools }, meta => {}}, $class;



    #if(defined($driverarg) && join("" ,@_)  =~/couch|cache|berkeley/){




}

sub _rearrange{
    my $self = shift;
    $self->{'payload'} = shift if @_;
    return %$self;
}

# CLASS METHODS
sub add_theme {
    my $class  = shift;
    my %themes = @_;

    for my $theme ( keys %themes ) {
        croak "The theme $theme already exists!" if exists $META{$theme};
        my @badnames = grep { !/^[a-z_]\w*$/i } @{$themes{$theme}};
        croak "Invalid names (@badnames) for theme $theme"
          if @badnames;

        my $code = << "EOC";
package AI::MicroStructure::$theme;
use strict;
use AI::MicroStructure::List;
our \@ISA = qw( AI::MicroStructure::List );
our \@List = qw( @{$themes{$theme}} );
1;
EOC
        eval $code;
        $META{$theme} = 1; # loaded

        # export the metatheme() function
        no strict 'refs';
        my $callpkg = caller;
        *{"$callpkg\::meta$theme"} = sub { $meta->name( $theme, @_ ) };
    }
}

# load the content of __DATA__ into a structure
# this class method is used by the other AI::MicroStructure classes
sub load_data {
    my ($class, $theme ) = @_;
    $data = {};

    my $fh;
    { no strict 'refs'; $fh = *{"$theme\::DATA"}{IO}; }

    my $item;
    my @items;
    $$item = "";

    {
    if(defined($fh)){
        local $_;
        while (<$fh>) {
            /^#\s*(\w+.*)$/ && do {
                push @items, $item;
                $item = $data;
                my $last;
                my @keys = split m!\s+|\s*/\s*!, $1;
                $last = $item, $item = $item->{$_} ||= {} for @keys;
                $item = \( $last->{ $keys[-1] } = "" );
                next;
            };
            $$item .= $_;
        }
    }
}
    # clean up the items
    for( @items, $item ) {
        $$_ =~ s/\A\s*//;
        $$_ =~ s/\s*\z//;
        $$_ =~ s/\s+/ /g;
    }
    
    if($debug) {
      print Dumper $data;
    }
    
    return $data;
}

# main function
sub metaname { $meta->name( @_ ) };

# corresponding method
sub name {
    my $self = shift;
    my ( $theme, $count );

    if (@_) {
        ( $theme, $count ) = @_;
        ( $theme, $count ) = ( $self->{theme}, $theme )
          if $theme =~ /^(?:0|[1-9]\d*)$/;
    }
    else {
        ( $theme, $count ) = ( $self->{theme}, 1 );
    }

    if( ! exists $self->{meta}{$theme} ) {
        if( ! $META{$theme} ) {
            eval "require AI::MicroStructure::$theme;";
            croak "MicroStructure list $theme does not exist!" if $@;
            $META{$theme} = 1; # loaded
        }
        $self->{meta}{$theme} =
          "AI::MicroStructure::$theme"->new( %{ $self->{tools} } );
    }

    $self->{meta}{$theme}->name( $count );
}

# other methods
sub themes { wantarray ? ( sort keys %META ) : scalar keys %META }
sub has_theme { $_[1] ? exists $META{$_[1]} : 0 }
sub configure_driver { $_[1] ? exists $META{$_[1]} : 0 }
sub count {
    my $self = shift;
    my ( $theme, $count );

    if (@_) {
        ( $theme, $count ) = @_;
        ( $theme, $count ) = ( $self->{theme}, $theme )
          if $theme =~ /^(?:0|[1-9]\d*)$/;
    }


     if( ! exists $self->{meta}{$theme} ) {
         return scalar ($self->{meta}{$theme}->new);
    }

    return 0;
}


sub trim
{
    my $string = shift;
  $string =  "" unless  $string;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    $string =~ s/\t//;
    $string =~ s/^\s//;
    return $string;
}


sub getBundle {

    my $self = shift;



my @themes = grep { !/^(?:any)/ } AI::MicroStructure->themes;
my @metas;
my @search=[];
for my $theme (@themes) {
    no strict 'refs';
    eval "require AI::MicroStructure::$theme;";

    my %isa = map { $_ => 1 } @{"AI::MicroStructure::$theme\::ISA"};
    if( exists $isa{'AI::MicroStructure::Locale'} ) {
        for my $lang ( "AI::MicroStructure::$theme"->languages() ) {
            push @metas,
                ["AI::MicroStructure::$theme"->new( lang => $lang ),$lang];


        }
    }
    elsif( exists $isa{'AI::MicroStructure::MultiList'} ) {
        for my $cat ( "AI::MicroStructure::$theme"->categories(), ':all' ) {
            push @metas,
                [ "AI::MicroStructure::$theme"->new( category => $cat ),$cat];
        }
    }
    else {
        push @metas, ["AI::MicroStructure::$theme"->new(),''];
    }
}

my  $all ={};

for my $test (@metas) {
    my $meta = $test->[0];
    my %items;
    my $items = $meta->name(0);
    $items{$_}++ for $meta->name(0);
    my $key=sprintf("%s",$meta->theme);
    $all->{$key}=[$test->[1],$meta->name($items)];

}



 return $all;






}


sub save_cat {
  my $data = shift;
  my $dat;  
  my $ret = "";

  
  foreach my $key(sort keys %{$data} ) {
      next unless($_);
      #ref $hash->{$_} eq "HASH"
      if(ref $data->{$key} eq "HASH"){
        $ret .= "\n".save_cat($data->{$key});     
      }else{
        $dat = $data->{$key};
        $dat =~ s/ /\n /g;
        
        $ret .= "# ".($key=~/names|default/?$key:"names ".$key);
        $ret .= "\n ".$dat."\n";
      }
  
  }
  
  return $ret;

}

sub save_default {

my $dat;
my @file = grep{/$Theme/}map{File::Glob::bsd_glob( File::Spec->catfile( $_, qw( AI MicroStructure *.pm ) ) )}@INC;
#  print Dumper [@ARGV,$data,$Theme,@file];
  
  if(@file){
  open(SELF,"+<$file[0]") || die $!;
  
#  print Dumper <SELF>;
  while(<SELF>){last if /^__DATA__/}
  
  truncate(SELF,tell SELF);
    
  print SELF save_cat($data);
        
  truncate(SELF,tell SELF);
  close SELF;
  }
 
}
sub openData{


while(<DATA>){
  chomp; 
  if($_=~/^#\s*(\w+.*)$/) {
      @a=split(" ",$1);
      if($#a){ 
            $data->{$a[0]}->{$a[1]}="";        
      }else{
            $data->{$1}="";
      }
      $item=$1 unless($#a);
      
  }else{

      my @keys = split m!\s+|\s*/\s*!,$_;
      foreach(sort @keys){
        if($#a){
        $data->{$a[0]}->{$a[1]} .= " $_" unless($_ eq "");
        }else{
        $data->{$item} .= " $_" unless($_ eq "");
        }
      }
          
  };

}

return $data;
}


END{
save_default() unless(!$write);
}


1;

__DATA__
1
