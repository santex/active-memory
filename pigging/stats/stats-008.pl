   # we have several groups of data each with 3 variables
    my $data_X = [
        [qw/ 191 131 53/],
        [qw/ 200 137 52/],
        [qw/ 173 127 50/],
        [qw/ 160 118 47/],
        [qw/ 188 134 54/],
        [qw/ 186 129 51/],
        [qw/ 163 115 47/],
    ];

    my $data_Y = [
        [qw/ 211 122 49/],
        [qw/ 201 144 47/],
        [qw/ 242 131 54/],
        [qw/ 184 108 43/],
        [qw/ 223 127 51/],
        [qw/ 208 125 50/],
        [qw/ 199 124 46/],
    ];
    
    my $data_Z = [
        [qw/ 185 134 50/],
        [qw/ 171 128 49/],
        [qw/ 174 131 52/],
        [qw/ 186 107 49/],
        [qw/ 211 118 51/],
        [qw/ 217 122 49/],
    ];

    use Statistics::MVA::Bartlett;
 
    # Create a Statistics::MVA::Bartlett object and pass it the data as a series of Lists-of-Lists within an anonymous array. 
    my $bart1 = Statistics::MVA::Bartlett->new([$data_X, $data_Y, $data_Z]);

    # Access the output using the bartlett_mva method. In void context it prints a report to STDOUT.
    $bart1->bartlett_mva;

    # In LIST-context it returns the relevant parameters.
    my ($chi, $df, $p) = $bart1->bartlett_mva;
