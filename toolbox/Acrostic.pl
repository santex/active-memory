#!/usr/bin/perl
use strict;

# This program generates acrostics. It first generates a large array, and switches the appropriate cells of the array to 1s to create squares,
# filled in sections, letters, and numbers. It writes the results to an image file in XBM format (chosen because of the ease of writing to such files).

# It is driven principally by a command line interface using which you enter rows of letters. Given
# the value of the final number it fills in all the rest for you (note that if you have enough memory, and can generate all eight rows at once,
# it isn't necessary to have this input: it's easy to figure out what the number is algorithmically). This program is a major memory hog (seemingly
# inevitably -- anyone have any ideas?)

# I am a rookie programmer. There are probably about a billion things wrong with this program, and I would appreciate any (constructive) advice users of the program
# could give me.  

### INITIALIZE VARIABLES

our($hldstring,$str,$numyrows,$numdigs,$numxrows,$col,$row,$boxnums,$orboxnum,$c,$wholecommand,@commandarray,$istart,@strs,$name,@grid,%numbers,%letters,$xcorn,$ycorn);

$numyrows = 8;     # number of rows in the acrostic
$numxrows = 5;    # number of columns in the acrostic 

our $xdim = 7*$numxrows;  # number of elements across the array
our $ydim = 7*$numyrows; # number of elements down the array

our @commands;

InitializeGrid();         
LoadTables();

$col = $row = 40;

### GET INPUT

# first get the final number, then ask for the row data

print("The acrostic is a grid of 27 squares by $numyrows squares. Please \nfirst enter the last number value in the $numyrows-line block: ");

$boxnums = <STDIN>;
chomp($boxnums);
$orboxnum = $boxnums;   #store the original number of boxes in an array. This is so the file can create image files with meaningful titles (see
                        #below, in the CONVERT AND WRITE TO FILE SECTION

print("\n\n"."Now please enter the letters corresponding to each square from left to right.\nIndicate a black square with a \"_\". After each eight characters have been entered press"."\n"."return to advance to the next line. If you make a mistake you will have an opportunity to correct\nit before the program begins.\n\n> ");

while(<STDIN>){
  $commands[$row] = $_;
  chomp($commands[$row]);
  if(length($commands[$row]) > 27){
				print("Too many characters. Please enter the line again.\n> ");
  } elsif(length($commands[$row]) < 27){
    print("Too few characters. Please enter the line again.\n");
  } elsif(length($commands[$row]) == 27){
    $commands[$row] =~ tr/[a-z]/[A-Z]/;
    if( $commands[$row] =~ /[^A-Z_]/){
        print("Sorry. Only letters and \"_\" are permitted to be entered. Please enter line again.\n> ");
        next;
    }
    print("\n"."You entered: ".$commands[$row]."\n\n> ");
    $row++;
    if($row == $ydim / 72){
	print("\n");
        last;
    }
  }
}

AskAfter();
foreach $c (@commands){
     $wholecommand .= $c;
}

### PASS DRAWING INSTRUCTIONS
@commandarray = split('',$wholecommand);
$ycorn = $ydim - 72;
$xcorn = 1872;
$istart = ($ydim / 72) * 27 - 1;
for (my $i = $istart ; $i >= 0 ; $i--){
    if($commandarray[$i] =~ /_/){
	FillBlack($xcorn,$ycorn);
        if($xcorn == 0){
          $xcorn = 1872; 
          $ycorn -= 72;
        } else {
          $xcorn -= 72;
        }
    } elsif($commandarray[$i] =~ /[A-Z]/){
        MakeSquare($xcorn,$ycorn); 
        print($commandarray[$i].$boxnums," XCORN: $xcorn YCORN: $ycorn","\n");
        if($boxnums <10) {
            $boxnums = "0".$boxnums;
        }
        GenerateCoor($xcorn,$ycorn,$commandarray[$i].$boxnums);
        $boxnums--;
        if($xcorn == 0){
          $xcorn = 1872; 
          $ycorn -= 72;
        } else {
          $xcorn -= 72;
        }
    }
}
print("Done.\n\n Writing image to file...");

### CONVERT AND WRITE TO FILE

@strs = FlattenGrid();
PrepareFile();
GenerateCoor();
MakeSquare(10,2);
$name = "$orboxnum"."to"."$boxnums";
open (O,">$name.xbm");
print O "\#define test_width $xdim\n\#define test_height $ydim\nstatic unsigned char test_bits[] = {";
print O $hldstring;    
print O "};";    
close(O);       
print("\a\nDone.\n"); 

### SUBROUTINES

sub InitializeGrid {
    for (my $i = 0 ; $i <= $ydim - 1 ; $i++){
	for (my $j = 0 ; $j <= $xdim - 1; $j++) {
	    $grid[$i][$j] = 0;	    
	}
    }
}


### Array-handling subroutines : these take data from drawing routines and prepare it for processing


sub WriteGrid {                              ### WriteGrid takes instructions from various drawing subroutines (e.g. those for squares, filled squares, letters & numbers)
    my $x = shift;                           ### and passes them to CheckCommands to make sure they're legal before sending them to DoCommands for final processing
    my $y = shift;    
    my $instruction = shift;
    $instruction =~ s/(?:\{|\})//g;
    CheckCommands($x,$y,$instruction);    
}

sub CheckCommands {
  my $chcksum = 0;  
  my $x = shift;  
  my $y = shift;  
  my $instruction = shift;  
  my $tmpsum1 = 0;  
  my $tmpsum2 = 0;  
  my @grid;
  @commands = split(',',$instruction);  
  foreach $c (@commands) {
      $c =~ s/(?:\{|\})//g;
      ($tmpsum1,$tmpsum2) = $c =~ /(\d+)\w(\d+)/;      ### parse the instructions from the letter and number tables
      $chcksum += ($tmpsum2 - $tmpsum1);               ### make sure that the instructions it has received encompass an entire 72-pixel width; otherwise there's problems
   }
   if($chcksum != 72) {
      print("Incomplete Line!: $c\n");       
      die;       
   } else {
       my $commandstring = join(',',@commands);
       DoCommands($x,$y,$commandstring);       
   }
}


sub DoCommands {
    our $rowcount;
    my($num1,$num2);
    my $char = 0;    
    my $bit = 0;    
    my $num = 0;    
    my $xc = shift;    
    my $yc = shift;    
    my $string = shift;
    $xc = 0;    
    my @commands = split(',',$string);
    foreach $c (@commands){
	($num1,$char,$num2) = $c =~ /(\d+)(\w)(\d+)/;	          #
	if($char =~ /w/i){					  #
	    $bit = 0;	                                          #
	} elsif ($char =~ /b/i) {      				  #      Here's where the writing to the array takes place
	    $bit = 1;	            				  #
	} 							  #
	for (my $i = $num1 ; $i <= $num2 -1 ; $i++){
	    $grid[$yc][$xc + $i] = $bit;	    
	}
    }
    $rowcount = $yc;
}

sub FlattenGrid {                                          ### turn the array into a bunch of strings suitable for passing to the file 
    my $c = 0;
    $str = '';    
    for (my $i = 0 ; $i <= $ydim ; $i++){
	for (my $j = 0 ; $j <= $xdim ; $j++) {
	    $str .= $grid[$i][$j];	  
     $c++;  
	}
    }
    my @strs = split('',$str);
    return(@strs);    
}


sub PrepareFile {
   my ($a,$s,$tmp); 
   my $i = 0;   
   our(@strs);   
   $a = "0x";    
   my $count = 0;
   #fill in the data
   while ($i <= length($str)){
     if($count == 9){
	$hldstring .= "\015\012\040\040\040";                     ### make a new line in the XBM data to facilitate reading
	$count = 0;
     }
     my $tmpbit0 = $strs[$i];
     my $tmpbit1 = $strs[$i+1];
     my $tmpbit2 = $strs[$i+2];
     my $tmpbit3 = $strs[$i+3];
     my $tmpbit4 = $strs[$i+4];
     my $tmpbit5 = $strs[$i+5];
     my $tmpbit6 = $strs[$i+6];
     my $tmpbit7 = $strs[$i+7];
     my $tmpbyte = $tmpbit7.$tmpbit6.$tmpbit5.$tmpbit4.$tmpbit3.$tmpbit2.$tmpbit1.$tmpbit0;
     $tmp = unpack("H8",pack("C",oct("0b".$tmpbyte)));
     $tmp =~ tr/[a-z]/[A-Z]/;
     $tmp = $a."$tmp,\040";
     $hldstring .= $tmp;        
     $i += 8;	
     $count++;
    }
    $hldstring =~ s/, $//;

}

### square and filled square generation subroutines

sub MakeSquare {
    my $xb = shift; # Beginning x and
    my $yb = shift; # y coordinates
    my $xnext = $xb + 1;
    my $xe = $xb + 72; # Ending x and
    my $ye = $yb + 72; # y coordinates
    my $xeless = $xe - 1; # x coordinate right before the end
    WriteGrid($xb,$yb,"{$xb}b{$xe}");   # top line is black
    for (my $i = $yb + 1 ; $i <= $ye - 2 ; $i++){
        WriteGrid($xb,$i,"{$xb}b"."$xnext".","."$xnext"."w{$xeless},{$xeless}b{$xe}"); #middle lines have black on either side
    }
    WriteGrid($xb,$ye - 1,"{$xb}b{$xe}");  # bottom line is black
}

sub FillBlack {
    my $xb = shift; # Beginning x and
    my $yb = shift; # y coordinates
    my $xe = $xb + 72; # Ending x and
    my $ye = $yb + 72; # y coordinates
    my $xeless = $xe - 1; # x coordinate right before the end
    for (my $i = $yb ; $i <= $ye - 1 ; $i++){
        WriteGrid($xb,$i,"{$xb}b{$xe}"); 
    }
}


### Letter and Number Generation Subroutines

sub GenerateCoor{   ### combine number and letter data into a single line
    our @lastc;
    my ($letter,$number,$numberdata,$olda,@sects,$s,$n,$lastlet,$numnumlines,$xbmore,@letterdata,@temp,@numberdata,@dgs,$i,$d,$c,@tmpnumdat,$t,$numletlines);
    my $xb = shift;
    my $yb = shift;
    my $keystring = shift; # for example: "A9"
    my $lastnum;
    my $clast;
    ($letter,$number) = $keystring =~ /(\w)(\d+)/;
    $letter =~ tr/[A-Z]/[a-z]/;
    my $letterdata = $letters{$letter};   #letterdata
    if($number =~ /^\d{1}$/){                           # if it's just one digit then no problem                
        $numberdata = $numbers{$number};
        @letterdata = split(';',$letterdata);           # parse the drawing instructrions from the table
        @numberdata = split(';',$numberdata);
        $numdigs = 1;
    } elsif($number =~ /\d{2,3}/){
        @letterdata = split(';',$letterdata);
        @dgs = split('',$number);
        $numdigs = $#dgs + 1;
        $i = 0;
        foreach $d (@dgs){
            $c = 0;
            $tmpnumdat[$i] = $numbers{$d};
            @temp = split(';',$tmpnumdat[$i]);
            foreach $t (@temp) {                        
                $numberdata[$c] .= $t.",";
                $c++;
            }
            foreach $n (@numberdata){
                $n =~ s/ //g;
            }        
            
            ($lastnum) = $tmpnumdat[$i] =~ /^.*?(?:w|b)(..).{0,1}$/;
            $i++;
        }
    }

    $numletlines = $#letterdata;
    $numnumlines = $#numberdata;
    my $lxb = $xb + 5;                            #  beginning x value for letter (for formatting)
    my $lyb = $yb + 3;                            #  beginning y value for letter 
    my $nxb = $xb + 54;                           #  beginning x value for number 
    my $nxe = $nxb + 18;                          #  beginning y value for number 
    my $lxe = $xb + 10;                           #  ending x value for letter
    my $xe = $xb + 72;                            #  get the ending x coordinate within the relative space of the 72x72 grid
   $xbmore = $xb+1;
    my $lye = $yb + 6;
    my $xless = $xe - 1;
    if($numdigs == 1){
        for (my $i = 0 ; $i <= $numletlines ; $i++){
            $letterdata[$i] =~ s/(\d+)/$1+$lxb/ge;
            $numberdata[$i] =~ s/(\d+)/$1+$nxb/ge;
            ($lastlet) = $letterdata[$i] =~ /^.*?(?:w|b)(..).{0,1}$/;
            ($lastnum) = $numberdata[$i] =~ /^.*?(?:w|b)(..).{0,1}$/;
            my $commandstring = "$xb"."b"."$xbmore".",1w$lxb,".$letterdata[$i].",$lastlet"."w$nxb".",$numberdata[$i]".",$lastnum"."w"."$xless".",$xless"."b"."$xe";
            $commandstring =~ s/ //g;
            WriteGrid($xb,$lyb,$commandstring);
            $commandstring = '';
            $lyb++;
        }
    } elsif($numdigs > 1){
        for (my $i = 0 ; $i <= $numnumlines ; $i++){
            @sects = split(',',$numberdata[$i]);
            $numberdata[$i] = '';
            $clast = 0;
            foreach $s (@sects) {                                           # combine the data from different numbers into a single line
                ($a,$b,$c) = $s =~ /(\d{1,2})(\w)(\d{1,2})/;
		if($a == $clast){
			$numberdata[$i] .= $s.",";
			$clast = $c;
			next;
		} 
		if($a != $clast){
			$olda = $a;                                        # make sure that the beginning coordinates of each new number match with the ending coordinates
			$a += ($clast - $a);                               # of the previous one
			$c += ($clast - $olda);
			$clast = $c;    
			$numberdata[$i] .= $a.$b.$c.",";
			next;
		}
            }
            $letterdata[$i] =~ s/(\d+)/$1+$lxb/ge;
            $numberdata[$i] =~ s/(\d+)/$1+$nxb/ge;
	    $letterdata[$i] =~ s/ //g;	    
	    $numberdata[$i] =~ s/ //g;
	    if($letterdata[$i] =~ /^$/){
		$letterdata[$i] = '5w10';		
	    }
            ($lastnum) = $numberdata[$i] =~ /^.*?(?:w|b)(\d+),$/;
            my $commandstring = "$xb"."b"."$xbmore,"."$xbmore"."w$lxb,".$letterdata[$i].",$lxe"."w$nxb".",$numberdata[$i]"."$lastnum"."w"."$xless".",$xless"."b"."$xe";
            WriteGrid($xb,$lyb,$commandstring);
            $lastnum = 0;
            $lyb++;
        }
    }
    undef @numberdata;                                                    # clear @numberdata for the next pass around the block
}
    

### I/O Subroutines

sub AskAfter {
    print("Please check your input. If you need to make any corrections type in the number of\nthe line at the prompt \">\". Otherwise type \"OK\" at the prompt and press return.\n\n");
    my $i = 1;
    foreach $c (@commands){
       print("ROW $i: $c\n");
       $i++;
    }
    PrintPrompt();
}

sub PrintPrompt {
       print "\n>";
       my $inp = <STDIN>;
       if($inp =~ /OK/i){
          print("\nProcessing...");
       } elsif($inp =~ /(\d+)/){
          print("\n".$commands[$1-1]."\n");
          ChangeInput($1-1);
       }
}

sub ChangeInput {
    my $rownum = shift;
    print("Change to: ");
    my $inp = <STDIN>;
    chomp($inp);
    $inp =~ tr/[a-z]/[A-Z]/;
    if(CheckLineInput($inp) == 1){
          PrintPrompt();
    } elsif(CheckLineInput($inp) == 0){
           $commands[$rownum] = $inp;
           print("\nRow ".($rownum+1)." changed to ".$commands[$rownum].".\n\n");
           AskAfter();
    }
}

sub CheckLineInput {
    my $input = shift;
    chomp($input);
    if(length($input) > 27){
				     print("Too many characters. Please enter the line again.\n");
    } elsif(length($input) < 27){
         print("Too few characters. Please enter the line again.\n");
    } elsif(length($input) == 27){
         if( $input =~ /[^A-Z_]/){
              print("Sorry. Only letters and \"_\" are permitted to be entered. Please enter line number and change again.\n");
              return(1);
              last;
          }
         return(0);
         last;
    } 
}

#### LOAD TABLES:
#### ------------
#### This is where the data for the numbers and letters are kept. In order to make it easier to read and to correct I 
#### used a format in which all numbers and letters were composed of bits on a 5x9 grid. Drawing on each line of this grid
#### is determined by a sequence of instructions delineated by commas ; each line of instructions is separated from the next
#### by a semicolon. Each instruction begins and ends with a number, and has a letter in between. If the letter is 'w' the pixel is
#### white, and if 'b' then black. The starting number determines where the white/black pixel(s) starts, and the final number determines
#### where it ends. All lines of instructions must have 0 as their starting coordinate and 5 as their ending coordinate, otherwise, the 
#### CheckCommands() subroutine will generate an error. 

sub LoadTables {
    %numbers = ('0' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w3,3b5 ; 0b1,1w2,2b3,3w4,4b5 ; 0b2,2w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                '1' => '0w2,2b3,3w5 ; 0w1,1b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w1,1b4,4w5',
                '2' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0w4,4b5 ; 0w4,4b5 ;0w3,3b4,4w5 ; 0w2,2b3,3w5 ; 0w1,1b2,2w5 ; 0b1,1w5 ; 0b5',
                '3' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0w4,4b5 ; 0w2,2b4,4w5 ; 0w4,4b5 ; 0w4,4b5 ; 0w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                '4' => '0w3,3b4,4w5 ; 0w2,2b4,4w5 ; 0w1,1b2,2w3,3b4,4w5 ; 0b1,1w3,3b4,4w5 ; 0b5 ; 0w3,3b4,4w5 ; 0w3,3b4,4w5 ; 0w3,3b4,4w5 ; 0w3,3b4,4w5',
                '5' => '0b5 ; 0b1,1w5 ; 0b1,1w5 ; 0b4,4w5 ; 0w4,4b5 ; 0w4,4b5 ; 0w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                '6' => '0w2,2b4,4w5 ; 0w1,1b2,2w5 ; 0b1,1w5 ; 0b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                '7' => '0b5 ; 0w4,4b5 ; 0w4,4b5 ; 0w3,3b4,4w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5',
                '8' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5 ; 0b1,1w4,4b5 ;  0b1,1w4,4b5 ;  0b1,1w4,4b5 ;  0b1,1w4,4b5 ;  0w1,1b4,4w5',
                '9' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b5 ; 0w4,4b5 ; 0w3,3b4,4w5 ; 0w1,1b3,3w5'
                );
                
    %letters = ('a' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5',
                'b' => '0b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b4,4w5',
                'c' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                'd' => '0b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b4,4w5 ',
                'e' => '0b5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b4,4w5; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b5',
                'f' => '0b5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b4,4w5; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5',
                'g' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w3,3b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                'h' => '0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5',
                'i' => '0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5',
                'j' => '0w4,4b5 ; 0w4,4b5 ; 0w4,4b5 ; 0w4,4b5 ; 0w4,4b5 ; 0w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                'k' => '0b1,1w4,4b5 ; 0b1,1w3,3b4,4w5 ; 0b1,1w2,2b3,3w5 ; 0b2,2w5 ; 0b1,1w5 ; 0b2,2w5 ; 0b1,1w2,2b3,3w5 ; 0b1,1w3,3b4,4w5 ; 0b1,1w4,4b5',
                'l' => '0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b5',
                'm' => '0b1,1w4,4b5 ; 0b2,2w3,3b5 ; 0b1,1w2,2b3,3w4,4b5 ; 0b1,1w2,2b3,3w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5',
                'n' => '0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b2,2w4,4b5 ; 0b1,1w2,2b3,3w4,4b5 ; 0b1,1w3,3b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5',
                'o' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                'p' => '0b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ;  0b1,1w4,4b5 ; 0b4,4w5 ; 0b1,1w5 ; 0b1,1w5 ;  0b1,1w5 ;  0b1,1w5',
                'q' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1, 1b4, 4w5 ; 0w3, 3b5',
                'r' => '0b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5',
                's' => '0w1,1b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w5 ; 0b1,1w5 ; 0w1,1b4,4w5 ; 0w4,4b5 ; 0w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                't' => '0b5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5',
                'u' => '0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b4,4w5',
                'v' => '0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b2,2w3,3b4,4w5 ; 0w1,1b2,2w3,3b4,4w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5',
                'w' => '0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w2,2b3,3w4,4b5 ; 0b2,2w3,3b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5',
                'x' => '0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b2,2w3,3b4,4w5 ; 0w2,2b3,3w5 ; 0w1,1b2,2w3,3b4,4w5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5',
                'y' => '0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0b1,1w4,4b5 ; 0w1,1b2,2w3,3b4,4w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5 ; 0w2,2b3,3w5',
                'z' => '0b5 ; 0w4,4b5 ; 0w4,4b5 ; 0w3,3b4,4w5 ; 0w2,2b3,3w5 ; 0w1,1b2,2w5 ; 0b1,1w5 ; 0b1,1w5 ; 0b5'
            )
}
    
=head1 NAME

Acrostic.pl

=head1 DESCRIPTION

- a small script to generate graphic images (in XBM format) of acrostic grids based upon a sequence of letters (corresponding to letters in the acrostic) and underscores ('_': to indicate black squares) at a command prompt. 

=pod SCRIPT CATEGORIES

CPAN/Graphics
Fun/Educational

=cut
