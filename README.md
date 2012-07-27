active-memory
===================


## Get going 

  ☞ [Pictures] 
  
```
  active-memory/docs/img
  are some pictures i made durring use &  developing 
```  
  
  ☞ [One liners]  

  (if all installed including dependencies calls spock) 

``````
echo #CREATES micro-structure planet;     
sudo micro new planet;
```
```
echo #Loads 1 element from micro-structure planet to the terminal;
micro planet;
```
```
echo  #Loads 10 element from micro-structure planet to the terminal;      
micro planet 10;      
```
```
echo #DELETES the structure; 
sudo micro drop planet; 
      
```

```  
echo #LOOPS OVER ALL; 
count=0;
for i in `perl -MAI::MicroStructure -le 'print  for AI::MicroStructure->themes';`; do
echo "@@@@<SET>@@@@<"$count">@@@@<"$i">@@@@";
count=$(expr $count + 1);
perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(" ",$m->name(scalar $m));
print join("\n",$m->categories());';
done
```

start of with (creates a new micro-structure called planet)
only one level ontology for now!!!) but goes for nearly all 
english words (proper words)


```
sudo micro new planet;
```

invokes the concept selection you can get all possible concepts there :) from Spock

```
sudo micro new planet
  
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
   \   bo  8b    .            .  J     |        
    \      "' .      .    .    .  L   F         has 3 concept's
     o._.:.    .        .  \mm,__J/  /          we need to find out the which one
     Y8::'|.            /     `Y8P  J           to use for our new,
     `|'  J:   . .     '   .  .   | F           micro-structure,
      |    L          ' .    _:    |            
      |    `:        . .:oood8bdb. |            (1): astronomy any of the nine large celestial bodies in the solar system that revolve around the sun and shine by reflected light; mercury, venus, earth, mars, jupiter, saturn, uranus, neptune, and pluto in order of their proximity to the sun; viewed from the constellation hercules, all the planets rotate around the sun in a counterclockwise direction
      F     `:.          "-._   `" F            (2): a person who follows or serves another
     /       `::.           """'  /             (3): any celestial body other than comets or satellites
    /         `::.          ""   /              
_.-d(          `:::.            F               
-888b.          `::::.     .  J                 
Y888888b.          `::::::::::'                 
Y88888888bo.        `::::::d                    
`"Y8888888888boo.._   `"dd88b.                  
                                                




"""""""""""""""""""""""""""""""""""""""""""""""


  Type: the number you choose 1..3
  1
$VAR1 = '
cool!!!!
';
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ micro planet 10
major_planet
gas_giant
morning_star
daystar
superior_planet
hesperus
terrestrial_planet
vesper
jovian_planet
inferior_planet

  
```  
  


#### Implementation
  → [my frontend lab!](http://algoservice.com:5984/wikilist/micro/idx-002.html)



## Documentation

  genetically organised data in a semantic environment

  Sorry for this poor Documentation it will grow accordingly to the state of the
  project, currently all efforts go into securing the cornerstones required to
  change the way we accessing data, and the way data is stored itself.
  I understand by reference that it is almost impossible to understand what this
  project is about so i have to default to this silly anecdote of the rat in the 
  mase, searching the exit and the eagle which fly s above.
  You also could describe it as an extreme form of the semantic web which might
  be the beginning of this development.

  


#### Motivation behind the project

  ☞ [short term goal] 
    
  To implement the properties of the concept into a generic db environment.
  to reduce the distance to information and increasing vissibility of data.
  Accessing the full potential of data networks in a passive way 
  

  ☞ [long  term goal]
    
    creating better data from data automatically fitness regulated
    
    (data procreation)

    (data symbiosis)
    

  ☞ [anticipated emergence]

  ☞ [UI-LAB active-memory-front](https://github.com/santex/active-memory-front)

  ☞ [CORE   active-memory      ](https://github.com/santex/active-memory)

  ☞ [PDF info](https://github.com/santex/active-memory/raw/master/start-here.pdf)


#### Important algorithms

  ☞ [Unknown data](https://github.com/santex/active-memory/raw/master/unknown-data.pdf)
    done

  ☞ [AI Micro Structure](https://github.com/santex/active-memory/raw/master/doc/image/artee-1.png)
    blue-print done / implementation open

  ☞ [Data & Time to get it](https://github.com/santex/active-memory/raw/master/doc/image/query-surface.jpg)
    proof of concept is implemented great stuff,
    based on what I more or less discovered by exident, i have started this project.

#### Some additional Knowledge Networks which add passive context

 * [Word net] done
 * [PDF/Text] running
 * [20.000 TV-Shows] running
 * [Wiki] open
 * [Bit-torrent] open

### # Status

  Not finished, any help is welcome



## Runing it


```

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
#use AI::MicroStructure::IOMicroy;



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
```

#### Implementation
  → [my frontend lab!](http://quantup.com)



```
#!/usr/local/bin/perl -lw
{sub b{ return pack("B64",shift
);}; @n=qw(01110011 01100001 01101110
01110100 01100101 01111000); foreach
(@n){$d=b($_);print $d; push @fin,$d;}
print split//,':Its okay to program in Perl
OOOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
OOOOMMMMMMMMMMMMMM/   \MMMMMMMMMMMMMMMMMMMMMM
OOOOMMMMMMMMMMMMM{ - - }MMMMMMMMMMMMMMMMMMMMM
OOOOMMMMMMMMMMMMM(  _  )MMMMMMMMMMMMMMMMMMMMM
OOOOMMMMMMMMMMMMM_\   /_MMMMMMMMMMMMMMMMMMMMM
OOOOMMMMMMMMMMMM/     / \MMMMMMMMMMMMMMMMMMMM
OOOOMMMMMMMMMMM/___/\/___\MMMMMMMMMMMMMMMMMMM
OOOOMMMMMMMM__(____||_____)__MMMMMMMMMMMMMMMM
OOOOMMMMMMM(                 )MMMMMMMMMMMMMMM
OOOOOMMMMMMMMM\\___________//MMMMMMMMMMMMMMMM
OOOOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
',[@fin]};
```

on the bash 

```
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
       \   bo  8b    .            .  J     |     The word prion
        \      "' .      .    .    .  L   F      has 1 concept's
         o._.:.    .        .  \mm,__J/  /       we need to find out the which one
         Y8::'|.            /     `Y8P  J        to use for our new,
         `|'  J:   . .     '   .  .   | F        micro-structure
          |    L          ' .    _:    |         
          |    `:        . .:oood8bdb. |         (1): microbiology an infectious protein particle similar to a virus but lacking nucleic acid; thought to be the agent responsible for scrapie and other degenerative diseases of the nervous system      
          F     `:.          "-._   `" F        
         /       `::.           """'  /         
        /         `::.          ""   /          
    _.-d(          `:::.            F           
 .-'.-888b.          `::::.     .  J            
'   Y888888b.          `::::::::::'             
    `Y88888888bo.        `::::::d               
     `"Y8888888888boo.._   `"dd88b.             
 . '     `"Y8888888888888bood8888P `-._          
             `"Y8888888888888888P      `-._      
          - .    ""Y88888888888P        ` .`-.
     -  -   -   __.   ""Y8888P'             . `.
              _           ""'                 . `.
"""""""""""""""""""""""""""""""""""""""""""""""""

```


The word prion




```
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
       \   bo  8b    .            .  J     |     The word chaos
        \      "' .      .    .    .  L   F      has 4 concept's
         o._.:.    .        .  \mm,__J/  /       we need to find out the which one
         Y8::'|.            /     `Y8P  J        to use for our new,
         `|'  J:   . .     '   .  .   | F        micro-structure
          |    L          ' .    _:    |         
          |    `:        . .:oood8bdb. |         (1): a state of extreme confusion and disorder       
          F     `:.          "-._   `" F         (2): the formless and disordered state of matter before the creation of the cosmos 
         /       `::.           """'  /          (3): Greek mythology the most ancient of gods; the personification of the infinity of space preceding creation of the universe
        /         `::.          ""   /           (4): physics a dynamical system that is extremely sensitive to its initial conditions
    _.-d(          `:::.            F           
 .-'.-888b.          `::::.     .  J            
'   Y888888b.          `::::::::::'             
    `Y88888888bo.        `::::::d               
     `"Y8888888888boo.._   `"dd88b.             
 . '     `"Y8888888888888bood8888P `-._          
             `"Y8888888888888888P      `-._      
          - .    ""Y88888888888P        ` .`-.
     -  -   -   __.   ""Y8888P'             . `.
              _           ""'                 . `.
"""""""""""""""""""""""""""""""""""""""""""""""""




  
  Type: the number you choose 1..4
  4 

cool!!!!hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos new
chaos
Use of uninitialized value $_ in concatenation (.) or string at /usr/local/share/perl/5.14.2/AI/MicroStructure.pm line 639.
Use of uninitialized value $_ in concatenation (.) or string at /usr/local/share/perl/5.14.2/AI/MicroStructure.pm line 639.

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
       \   bo  8b    .            .  J     |     The word chaos
        \      "' .      .    .    .  L   F      has 4 concept's
         o._.:.    .        .  \mm,__J/  /       we need to find out the which one
         Y8::'|.            /     `Y8P  J        to use for our new,
         `|'  J:   . .     '   .  .   | F        micro-structure
          |    L          ' .    _:    |         
          |    `:        . .:oood8bdb. |         (1): a state of extreme confusion and disorder       
          F     `:.          "-._   `" F         (2): the formless and disordered state of matter before the creation of the cosmos 
         /       `::.           """'  /          (3): Greek mythology the most ancient of gods; the personification of the infinity of space preceding creation of the universe
        /         `::.          ""   /           (4): physics a dynamical system that is extremely sensitive to its initial conditions
    _.-d(          `:::.            F           
 .-'.-888b.          `::::.     .  J            
'   Y888888b.          `::::::::::'             
    `Y88888888bo.        `::::::d               
     `"Y8888888888boo.._   `"dd88b.             
 . '     `"Y8888888888888bood8888P `-._          
             `"Y8888888888888888P      `-._      
          - .    ""Y88888888888P        ` .`-.
     -  -   -   __.   ""Y8888P'             . `.
              _           ""'                 . `.
"""""""""""""""""""""""""""""""""""""""""""""""""




  
  Type: the number you choose 1..4
  1

cool!!!!hagen@sante12:~/myperl/AI-MicroStructure-0.0micro chaos 
hugger-mugger
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos 
pandemonium,
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos 
topsy-turvyness
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos 
topsy-turvyness
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos 
pandemonium,
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos 
bedlam,
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos 
bedlam,
hagen@sante12:~/myperl/AI-MicroStructure-0.01$ sudo micro chaos 
topsy-turvydom,
```


#### Copyright

  Copyright (C) 2009-2012 Hagen "santex" Geissler