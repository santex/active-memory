#!/usr/bin/perl -X
package AI::MicroStructure::Fitnes;
use strict;
use warnings;
use JSON;
use Data::Dumper;
use Statistics::MVA::HotellingTwoSample;
use Algorithm::BaumWelch;
use Statistics::Distributions::Ancova;
use Statistics::MVA::BayesianDiscrimination;
use Statistics::MVA::HotellingTwoSample;
use Statistics::Contingency;




use vars qw(
  $configure
	$pi
	$driver
	);




sub import {
	##$self->{log} .= sprintf "import called with @_\n";
	local $configure = @_; # shame that Getopt::Long isn't structured better!
	use Getopt::Long ();


  


	Getopt::Long::GetOptions( '-',
		'driver=f'=>\$driver,
		'configure=f'=>\$configure,
		) or croak("bad import arguments");

    
} # end subroutine import definition


sub new {
  
  my($class,$args) = @_;
 
  my $self = bless { cache => [] }, $class;
  $configure = $args;
  $self->{"log"}="";  
  $self->import;
  $self->connectStats;

 
  return $self;
}




sub initialize {
  my $self = shift();
 %$self= @_;

}


sub defaultDriver {

  my $self = shift;

    return $configure;
  
  }


  
sub connectStats{


  my $self = shift;



   if( scalar keys %$configure < 8){

      
   }else{
   
      $self->{configure} = $configure;
   }
  

my $anc = Statistics::Distributions::Ancova->new ( { significance => 0.005, input_verbosity => 1, output_verbosity => 1 } );
         use Statistics::Descriptive;
         my $stat = Statistics::Descriptive::Full->new();
         $Statistics::Descriptive::Tolerance = 1e-10;

         $stat->add_data(1,2,3,40);
         my $mean = $stat->mean();
         my $var  = $stat->variance();
       my $tm   = $stat->trimmed_mean(0.25000);
  
  # The observation series see http://www.cs.jhu.edu/~jason/.
  my $obs_series = [qw/ obs2 obs3 obs3 obs2 obs3 obs2 obs3 obs2 obs2 
  obs3 obs1 obs3 obs3 obs1 obs1 obs1 obs2 obs1 
  obs1 obs1 obs3 obs1 obs2 obs1 obs1 obs1 obs2 
  obs3 obs3 obs2 obs3 obs2 obs2
  /];

  # The emission matrix - each nested array corresponds to the probabilities of a single observation type.
  my $emis = { 
  obs1 =>  [0.3, 0.3], 
  obs2 =>  [0.3, 0.4], 
  obs3 =>  [0.4, 0.3], 
  };

  # The transition matrixi - each row and column correspond to a particular state e.g. P(state1_x|state1_x-1) = 0.9...
  my $trans = [ 
  [0.9, 0.1], 
  [0.1, 0.9], 
  ];

  # The probabilities of each state at the start of the series.
  my $start = [0.5, 0.5];

  # Create an Algorithm::BaumWelch object.
  my $ba = Algorithm::BaumWelch->new;

  # Feed in the observation series.
  $ba->feed_obs($obs_series);

  # Feed in the transition and emission matrices and the starting probabilities.
  $ba->feed_values($trans, $emis, $start);

  # Alternatively you can randomly initialise the values - pass it the number of hidden states - 
  # i.e. to determine the parameters we need to make a first guess).
  # $ba->random_initialise(2);

  # Perform the algorithm.
  $ba->baum_welch;

  # Use results to pass data. 
  # In VOID-context prints formated results to STDOUT. 
  # In LIST-context returns references to the predicted transition & emission matrices and the starting parameters.
  $ba->results;





    # we have two groups of data each with 4 variables and 9 observations.
    my $data_x = [ 
                    [qw/ 292 222 52 57/],
                    [qw/ 100 227 51 45/],
                    [qw/ 272 218 49 36/],
                    [qw/ 101 221 17 47/],
                    [qw/ 181 208 12 35/],
                    [qw/ 111 118 51 54/],
                    [qw/ 288 321 51 49/],
                    [qw/ 286 219 52 45/],
                    [qw/ 262 225 47 44/],
                 ];
    my $data_y = [
                    [qw/ 286 107 29 62/],
                    [qw/ 311 122 29 63/],
                    [qw/ 272 131 52 86/],
                    [qw/ 182  88 23 69/],
                    [qw/ 211 118 61 57/],
                    [qw/ 323 127 51 79/],
                    [qw/ 385 332 70 63/],
                    [qw/ 373 127 85 60/],
                    [qw/ 408  95 57 71/],
                 ];
    
    # Create a Statistics::MVA::HotellingTwoSample object and pass the data as two Lists-of-Lists within an anonymous array.
    my $mva = Statistics::MVA::HotellingTwoSample->new([ $data_x, $data_y ]);




my @all_categories = 0..3;
 my $s = new Statistics::Contingency(categories => \@all_categories);
 
foreach(@all_categories) {
my $assigned_categories = $_; 
my $correct_categories=sprintf "%d" ,$_+rand 10;
  $s->add_result($assigned_categories, $correct_categories);
 }
 

 
$self->{log} .= sprintf $s->stats_table; # Show several stats in table form

 my $stats = $s->category_stats;
 my $show = {};
 
  while (my ($cat, $value) = each %$stats) {
    $show->{$cat} = $value;
  }
  
  



while (my ($cat, $value) = each %$stats) {
 $self->{log} .= sprintf "Category '$cat': \n"; $self->{log} .= sprintf "  Accuracy: $value->{accuracy}\n";
 $self->{log} .= sprintf "  Precision: $value->{precision}\n";
 $self->{log} .= sprintf "  F1: $value->{F1}\n";
}







my $data_X = [
  [qw/ 191 131 53/],
  [qw/ 185 134 50/],
  [qw/ 200 137 52/],
  [qw/ 173 127 50/],
  [qw/ 171 128 49/],
  [qw/ 160 118 47/],
  [qw/ 188 134 54/],
  [qw/ 186 129 51/],
  [qw/ 174 131 52/],
  [qw/ 163 115 47/],
];

my $data_Y = [
  [qw/ 186 107 49/],
  [qw/ 211 122 49/],
  [qw/ 201 144 47/],
  [qw/ 242 131 54/],
  [qw/ 184 108 43/],
  [qw/ 211 118 51/],
  [qw/ 217 122 49/],
  [qw/ 223 127 51/],
  [qw/ 208 125 50/],
  [qw/ 199 124 46/],
];


# Pass the data as a list of the two LISTS-of-LISTS above (termed X and Y). The module by default assumes equal prior probabilities.
my $bld = Statistics::MVA::BayesianDiscrimination->new($data_X,$data_Y);
 $bld->output;

# Pass the data but telling the module to calculate the prior probabilities as the ratio of observations for the two groups (e.g. P(X) X_obs_num / Total_obs.
$bld = Statistics::MVA::BayesianDiscrimination->new({priors => 1 },$data_X,$data_Y);
$bld->output;

# Create an Ancova object and set significance value of p = 0.05 for statistical test. See METHODS for optional named arguments and default values.
$anc = Statistics::Distributions::Ancova->new ( { significance => 0.005, input_verbosity => 1, output_verbosity => 1 } );

# Example using k=3 groups. Data includes our dependent variable of interest (Y) and covariant data (X) that is used to eliminate obscuring effects of covariance.
my @Drug_A_Y =  ('29','27','31','33','32','24','16');
my @Drug_A_X = ('53','64','55','67','55','45','35');
my @Drug_B_Y = ('39','34','20','35','57','28','32','17');
my @Drug_B_X = ('24','19','13','18','25','16','16','13');
my @Drug_C_Y = ('12','21','26','17','25','9','12');
my @Drug_C_X = ('5','12','12','9','12','3','3');

# Data is sent to object as nested HASH reference. Individual group names are option, but to distinguish IV/DV, the names Y and X for the variables are compulsory.
my $h_ref = { 'group_A' =>  {
                        Y => \@Drug_A_Y,
                        X => \@Drug_A_X,
                },
    'group_B' =>  { 
                        Y => \@Drug_B_Y,
                        X => \@Drug_B_X,
                },
    'group_C' =>  {
                        Y => \@Drug_C_Y,
                        X => \@Drug_C_X,
                },
    };

# Feed the object the data pass data HASH reference with named argument 'data'.
$anc->load_data ( { data => $h_ref } );

# Perform analysis
$anc->ancova_analysis;

# To access results use results method. The return of this method is context dependent (see METHODS).
# To$self->{log} .= sprintf a report to STDOUT call results in VOID context.
$anc->results();

#print Dumper $mva;


}

1;
