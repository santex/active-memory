use Statistics::MVA;
use Statistics::MVA::BayesianDiscrimination;

use Statistics::Distributions::Ancova;

my $anc = Statistics::Distributions::Ancova->new ( { significance => 0.005, input_verbosity => 1, output_verbosity => 1 } );




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

# Pass the data but directly specifying the values of prior probability for X and Y to use as an anonymous array.
my $bld = Statistics::MVA::BayesianDiscrimination->new({priors => [ 0.25, 0.75 ] },$ins_a,$ins_b);


# Pass the values as an ARRAY reference by calling in LIST context - see L</output>.
my ($prior_x, $constant_x, $matrix_x, $prior_y, $constant_y, $matrix_y) = $bld->output;

# Perform discriminantion analyis for a specific observation and print result to STDOUT.
$bld->discriminate([qw/184 114 59/]);

# Call in LIST context to obtain results directly - see L</discriminate>.
my ($val_x, $p_x, $post_p_x, $val_y, $p_y, $post_p_y, $type) = $bld->discriminate([qw/194 124 49/]);
