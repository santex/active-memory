use Data::Dumper;
use Statistics::MVA::HotellingTwoSample;


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

print Dumper $mva;
