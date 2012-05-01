use Statistics::Distributions::Ancova;

# Create an Ancova object and set significance value of p = 0.05 for statistical test. See METHODS for optional named arguments and default values.
my $anc = Statistics::Distributions::Ancova->new ( { significance => 0.005, input_verbosity => 1, output_verbosity => 1 } );

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
# To print a report to STDOUT call results in VOID context.
$anc->results();
