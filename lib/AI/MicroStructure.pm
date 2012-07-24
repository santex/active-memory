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
our %MICRO;
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

our ($new,$debug, $write,$drop) =(0,0,0,0);

if( grep{/\bnew\b/} @ARGV ){ $new = 1; cleanArgs("new"); }
if( grep{/\bdebug\b/} @ARGV ){$debug = 1; cleanArgs("debug"); };
if( grep{/\bwrite\b/} @ARGV ){ $write = 1; cleanArgs("write");  };
if( grep{/\bdrop\b/} @ARGV ){ $drop = 1; cleanArgs("drop");  };


our $ThemeName = $ARGV[0]; # default theme

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
              grep { $_->[0] !~ /^([A-Z]|foo|new)/ }    # remove the non-theme subclasses
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



$MICRO{$_} = 0 for keys %{{__PACKAGE__->find_themes(@INC)} };
$MODS{$_} = $_ for keys %{{__PACKAGE__->find_modules(@INC)} };
$search = join("|",keys %MICRO);
#if( grep{/$search/} @ARGV ){ $Theme = $ARGV[0] unless(!$ARGV[0]); }

# fetch the list of standard themes

#print Dumper keys %MICRO;
sub getComponents(){

  my $x= sprintf("%s",Dumper keys %MICRO);

  return $x;
}


# the functions actually hide an instance
my $micro = AI::MicroStructure->new($Theme);

# END OF INITIALISATION

# support for use AI::MicroStructure 'stars'
# that automatically loads the required classes
sub import {
    my $class = shift;

    my @themes = ( grep { $_ eq ':all' } @_ )
      ? ( 'stars', grep { !/^(?:stars|:all)$/ } keys %MICRO ) # 'stars' is still first
      : @_;

    $Theme = $themes[0] if @themes;
    $micro = AI::MicroStructure->new( $Theme );

    # export the metaname() function
    no strict 'refs';
    my $callpkg = caller;
    *{"$callpkg\::metaname"} = \&metaname;    # standard theme

    # load the classes in @themes
    for my $theme( @themes ) {
        eval "require AI::MicroStructure::$theme; import AI::MicroStructure::$theme;";
        croak $@ if $@;
        *{"$callpkg\::meta$theme"} = sub { $micro->name( $theme, @_ ) };
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
        croak "The theme $theme already exists!" if exists $MICRO{$theme};
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
        $MICRO{$theme} = 1; # loaded

        # export the metatheme() function
        no strict 'refs';
        my $callpkg = caller;
        *{"$callpkg\::meta$theme"} = sub { $micro->name( $theme, @_ ) };
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
sub metaname { $micro->name( @_ ) };

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
        if( ! $MICRO{$theme} ) {
            eval "require AI::MicroStructure::$theme;";
            croak "MicroStructure list $theme does not exist!" if $@;
            $MICRO{$theme} = 1; # loaded
        }
        $self->{meta}{$theme} =
          "AI::MicroStructure::$theme"->new( %{ $self->{tools} } );
    }

    $self->{meta}{$theme}->name( $count );
}

# other methods
sub themes { wantarray ? ( sort keys %MICRO ) : scalar keys %MICRO }
sub has_theme { $_[1] ? exists $MICRO{$_[1]} : 0 }
sub configure_driver { $_[1] ? exists $MICRO{$_[1]} : 0 }
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
    my $self = shift;
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
    my $micro = $test->[0];
    my %items;
    my $items = $micro->name(0);
    $items{$_}++ for $micro->name(0);
    my $key=sprintf("%s",$micro->theme);
    $all->{$key}=[$test->[1],$micro->name($items)];

}



 return $all;






}


sub save_cat {

  my $self = shift;
  my $data = shift;
  my $dat;
  my $ret = "";


  foreach my $key(sort keys %{$data} ) {
      next unless($_);
      #ref $hash->{$_} eq "HASH"
      if(ref $data->{$key} eq "HASH"){
        $ret .= "\n".$self->save_cat($data->{$key});
      }else{
        $dat = $data->{$key};
        $dat =~ s/ /\n/g;
        $dat =~ s/\n\n/\n/g;
        $dat =~ s/->\n|[0-9]\n//g;

        $ret .= "# ".($key=~/names|default|[0-9]/?$key:"names ".$key);
        $ret .= "\n ".$dat."\n";
      }

  }

  return $ret;

}

sub save_default {

  my $self = shift;
  my $data = shift;
  my $line = shift;
  my $dat = {};
  my @in = ();
  my $active=0;
  $line = $Theme unless($line);

  foreach(@{$data->{rows}->{"coordinate"}}){

    if($_ eq $line){ $active=1; }

    if(1+$line eq $_){ $active=0; }

    if($active==1){
      $_=~s/,//g;
      $_ = $self->trim($_);
      $dat->{names}->{$_}=$_ unless(defined($dat->{names}->{$_}));
    }

}

foreach(@{$data->{rows}->{"search"}}){

    if($_ eq $line){  $active=1; }


    if(1+$line eq $_){ $active=0; }

    if($active==1){
      $_=~s/,//g;
      $_ = $self->trim($_);
      $dat->{names}->{$_}=$_ unless(defined($dat->{names}->{$_}));
    }

}

@in = values %{$dat->{names}};
$dat->{names} = join(" ",@in);
$dat->{names} =~ s/$line(.*?)\-\>(.*?) [1-9] /$1 $2/g;
$dat->{names} =~ s/  / /g;
my @file = grep{/$Theme/}map{File::Glob::bsd_glob( File::Spec->catfile( $_, qw( AI MicroStructure *.pm ) ) )}@INC;


  if(@file){
  open(SELF,"+<$file[0]") || die $!;

  while(<SELF>){last if /^__DATA__/}

    truncate(SELF,tell SELF);

    print SELF $self->save_cat($dat);

    truncate(SELF,tell SELF);
    close SELF;
  }

}
sub openData{

my $self = shift;
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

sub getBlank {

  my $self = shift;
  my $theme = shift;


my $usage = "";

$usage = "#!/usr/bin/perl -W\npackage AI::MicroStructure::$theme;\n";
$usage .= << 'EOT';
use strict;
use AI::MicroStructure::List;
our @ISA = qw( AI::MicroStructure::List );
__PACKAGE__->init();
1;
__DATA__
# default
EOT


}

sub save_new {

my $self = shift;
my $ThemeName = shift;
my $data = shift;

$ThemeName = lc $self->trim(`micro`) unless($ThemeName);
my @file = grep{/any/}map{File::Glob::bsd_glob( File::Spec->catfile( $_, qw( AI MicroStructure *.pm ) ) )}@INC;
  my $fh;
  if(@file){
   $file[1]=$file[0];
   $ThemeName = lc $ThemeName;
  $file[1] =~ s/any/$ThemeName/g;

  open($fh,">$file[1]") || die $!;

  print $fh $self->getBlank($ThemeName);

  close $fh;
  }
  $Theme = $ThemeName;
  push @INC,$file[1];

  return 1;
}



sub drop {

my $self = shift;
my $ThemeName = shift;

my @file = grep{/$ThemeName/}map{File::Glob::bsd_glob( File::Spec->catfile( $_, qw( AI MicroStructure *.pm ) ) )}@INC;
my $fh = shift @file;

  `rm $fh`;

  #push @INC,$file[1];

  return 1;
}




END{


if($drop == 1) {

   $micro->drop($ThemeName);

}

if($new==1){


  use Term::ReadKey;
  use JSON;

  my $data = decode_json( `micro-sense $ThemeName words`);
  my $char;
  my $line;
  my $senses=@{$data->{"senses"}};
     $senses= 0 unless($senses);


  printf("%s\n
  \033[0;34m
  Type: the number you choose 1..$senses
  \033[0m",$micro->usage($ThemeName,$senses,$data));

  chomp($line = <STDIN>) unless($line);

  if($line>0 && $line<=$senses){

    $micro->save_new($ThemeName,$data,$line);

    $micro->save_default($data,$line);
#    $micro->add_theme($Theme);
    printf "\ncool!!!!\n";
    exit 0;

  }else{

    printf "your logic is today impaired !!!\n";
    exit 0;

  }


  $micro->save_default();
  }

  if($write == 1) {
     $micro->save_default();
  }


#

}


sub usage {

 my $self = shift;


 my $search = shift;
 my $senseNr = shift;
 my $data = shift;


my $usage = << 'EOT';

               .--'"""""--.>_
            .-'  o\\b.\o._o.`-.
         .-'.- )  \d888888888888b.
        /.'   b  Y8888888888888888b.
      .-'. 8888888888888888888888888b
     / o888 Y Y8888888888888888888888b
     / d888P/ /| Y"Y8888888888888888888b
   J d8888/| Y .o._. "Y8888888888888Y" \
   |d Y888b|obd88888bo. """Y88888Y' .od8
   Fdd 8888888888888888888bo._'|| d88888|
   Fd d 88\ Y8888Y "Y888888888b, d888888P
   d-b 8888b Y88P'     """""Y888b8888P"|
  J  8\88888888P    `m.        """""   |
  || `8888888P'       "Ymm._          _J
  |\\  Y8888P  '     .mmm.YM)     .mMF"'
  | \\  Y888J     ' < (@)>.- `   /MFm. |
  J   \  `YY           ""'   ::  MM @)>F
   L  /)  88                  :  |  ""\|
   | ( (   Yb .            '  .  |     L
   \   bo  8b    .            .  J     |        <0>_
    \      "' .      .    .    .  L   F         <1>_
     o._.:.    .        .  \mm,__J/  /          <2>_
     Y8::'|.            /     `Y8P  J           <3>_
     `|'  J:   . .     '   .  .   | F           <4>_
      |    L          ' .    _:    |            <5>_
      |    `:        . .:oood8bdb. |            1>_
      F     `:.          "-._   `" F            2>_
     /       `::.           """'  /             3>_
    /         `::.          ""   /              4>_
_.-d(          `:::.            F               5>_
-888b.          `::::.     .  J                 6>_
Y888888b.          `::::::::::'                 7>_
Y88888888bo.        `::::::d                    8>_
`"Y8888888888boo.._   `"dd88b.                  9>_

"""""""""""""""""""""""""""""""""""""""""""""""

EOT


$usage =~ s/<0>_/The word $search/g;
$usage =~ s/<1>_/has $senseNr concept's/g;
$usage =~ s/<2>_/we need to find out the which one/g;
$usage =~ s/<3>_/to use for our new,/g;
$usage =~ s/<4>_/micro-structure/g;
$usage =~ s/<5>_//g;
my @row = ();
my $ii=0;
foreach my $sensnrx (sort keys %{$data->{"rows"}->{"senses"}})
{

#    print Dumper  $data;

    my $row = $data->{"rows"}->{"senses"}->{$sensnrx};
    my $txt="";

     foreach(@{$row->{"basics"}}[1..2]){
      $txt .= " $_";
    }
    $usage =~ s/$sensnrx>_/($sensnrx):$txt/g;
}

  foreach my $ii (0..16){
    $usage =~ s/ $ii>_//g;
  }


return $usage;
}

1;

__DATA__
count=0;
for i in `perl -MAI::MicroStructure -le 'print  for AI::MicroStructure->themes';`; do
echo "@@@@@@@@@@<SET>@@@@@@@@@@@@<"$count">@@@@@@@@@<"$i">@@@@@@@@@";
count=$(expr $count + 1);
perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(",", $m->name(scalar $m));';
perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(",",$m->name(scalar $m));
print join(",",$m->categories());';
done
