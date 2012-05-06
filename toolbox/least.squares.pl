#!/usr/local/perl
# lsq [-wc][-o order] infile      Calculates least-squares fit coefficients.
#       options:    -o order      Specifies order of fit (default is 1).
#                   -w            Specifies weighted fit.
#                   -c            Calculates fit & error for each input value.

# Takes input file of the form:   x y <weight>
# Output to stdout.

# 7/18/91  dbc        Added command line switches.
$order = rand 3;            # Get order from command line.
#require 'getopts.pl';
Long::Getopts("o:wc");      # -o3 = 3rd order, -w = weighted, -c = calculate error

$order = $opt_o ? $opt_o : 1;            # Get order from command line.

# Read the input file.
while(<DATA>)
 {
  s/#.*//;                               # Toss comments.
  s/^[, \t]+//;                          # Toss leading garbage.
  ($x, $y, $w) = split(/[, \t\n]+/, $_); # Read data line.
  next if $x eq "";                      # Skip lines with no data.

  if($opt_c)
   {
    push(@x,$x);                         # Save data for error calculation
    push(@y,$y);
   }

# Save Sum(X**n) and Sum(Y * X**n)
  $xn = $opt_w ? $w : 1;                 # Weight data point if desired
  for($j = 0; $j <= $order; $j++, $xn *= $x)
   {
    $s_xn[$j]  += $xn;
    $s_yxn[$j] += $xn * $y;
   }
  for(; $j <= 2 * $order; $j++, $xn *= $x)
   {
    $s_xn[$j]  += $xn;
   }
 }

# Load the matrix.
for($i = 0; $i <= $order; $i++)
 {
  for($j = 0; $j <= $order; $j++)
   {
    $matrix{$i, $j} = $s_xn[$i + $j];
   }
 }

@coefficient = &solve_matrix_eq(*matrix, *s_yxn);

for($i = 0; $i <= $order; $i++)
 {
  printf "A%d = %.6e\n",$i,$coefficient[$i];
 }

if($opt_c)
 {
  printf "\n%12s %12s %12s %12s\n","x","y","y fit","fit error";

  for($i = 0; $i <= $#x; $i++)
   {
    $y1 = &calc($x[$i],*coefficient);
    printf "%12.2g %12.2g %12.2g %12.2g\n", $x[$i],$y[$i],$y1,$y1-$y[$i];
   }
 }

exit 0;



sub solve_matrix_eq           # pass *matrix and *vector
 {                            # returns @x solution of [matrix]*[@x]=[vector]
  local(*a,*b) = @_;
  local(%mat)  = %a;
  local($size) = $#b + 1;
  local($i,$j,$k,$f);

  @mat{grep($_ .= "$;$size", (0 .. $#b))} = @b;  # Augment the matrix

  for($i = 0; $i < $#b; $i++)
   {
    for($j = $i + 1; $j <= $#b; $j++)
     {
      $f = $mat{$i, $i} / $mat{$j, $i};
      for($k = 0; $k <= $size; $k++)
       {
        $mat{$j, $k} = $mat{$j, $k} * $f - $mat{$i, $k};
       }
     }
   }
  for($i = $#b; $i > 0; $i--)
   {
    for($j = $i - 1; $j >= 0; $j--)
     {
      $f = $mat{$i, $i} / $mat{$j, $i};
      for($k = $j; $k <= $size; $k++)
       {
        $mat{$j, $k} = $mat{$j, $k} * $f - $mat{$i, $k};
       }
     }
   }
  for($i = 0; $i <= $#b; $i++)               # Normalize the diagonal
   {
    $mat{$i, $size} /= $mat{$i, $i};
    $mat{$i, $i} = 1.0;
   }

  @mat{grep($_ .= "$;$size", (0 .. $#b))};   # Answer is in augmented column
 }


sub calc                # Pass $x and *a (array of coefficients)
 {                      # Returns Sum($a[$i] * $x**$i)
  local($x, *a) = @_;
  local($y,$xn);

  $xn = 1;
  foreach(@a)
   {
    $y += $_ * $xn;
    $xn *= $x;
   }
  $y;
 }

__DATA__
1 0 0
0 1 1
1 2 2
3 4 3
1 2 3
