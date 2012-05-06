#!/usr/local/bin/perl

# A Perl script to solve the n-queens problem.
#
# Each argument to &next_queen is a row of the board, and the value is
# the column a queen has already been placed at.  It attempts to add
# another queen to the current row so that it doesn't conflict with the
# previous rows.
#
#       Nick Holloway <alfie@dcs.warwick.ac.uk>, 27th May 1993.

$boardsize      = 8;                            # Number of queens

@columns        = ( 0 .. $boardsize-1 );        # Precomputed for speed.

sub next_queen {
    ( print ( "@_\n" ), return ) if @_ == $boardsize;

    column:
    for $column ( @columns ) {
        next if grep ( $_ == $column, @_ );
        $row = @_;
        next if grep ( $_ == $column-$row--, @_ );
        $row = @_;
        next if grep ( $_ == $column+$row--, @_ );

        &next_queen ( @_, $column );
    }
}

# Find all solutions to the eight queens problem on
# an eight by eight board.
# Jerry LeVan <levan@eagle.eku.edu>

@a = (1) x 15 ; # 15 diagonals (1 => unoccupied)
@b = (1) x 15 ; # 15 antidiagonals ( 1 => unoccupied )
@c = (1) x  8 ; #  8 rows ( 1 => unoccupied )

# Store solution here
@x = (undef,(0) x 8 ) ; # skip the zeroth slot

$pflag     =  1 ;  # true if printing solutions desired
$solutions =  0 ;  # total number of solutions
$boardsize =  8 ;  # size of board
@rows      =  (1 .. $boardsize) ;

sub try {

  local($i)=@_ ; # try to put a queen in the ith column

  for $j (@rows ) { # slide down column looking for safe spot
    # is it safe ?
    if ( $a[$i-$j+7] && $b[$i+$j-2] && $c[$j-1]) {

      # yes, mark diagonal, antidiagonal and row as occupied
      $a[$i-$j+7] = $b[$i+$j-2] = --$c[$j-1] ;

      # record solution
      $x[$i] = $j;

      # if not in last column try to extend this solution
      if( $i <  $boardsize ){   &try( $i + 1 ); }
      else {
        # we have a solution so display it
        ++$solutions ;  &printsol if $pflag ;
      }
      # take this queen off and try next row in this column
      $a[$i - $j + 7] = $b[$i + $j -2] = ++$c[$j-1];
    }
   }
}

sub printsol {
  print join(' ',@x), "\n" ;
}

printf "#*********************************************************************\n";
&next_queen ();
printf "#*********************************************************************\n";

&try(1) ;
printf "#*********************************************************************\n";

print "Exactly $solutions found.\n" ;

