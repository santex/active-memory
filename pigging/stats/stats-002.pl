no warnings;
use Statistics::FactorAnalysis;

    # Data is entered as a reference to a LoL. In this case each nested LIST corresponds to a separate variable - thus 'format' option is set to 'variable'. 
    my $data = [
                    [qw/ 1038 369  622  1731 1109 1274 517  2043 1106 201  665  593  1117 563  2448 2201 1036 2715 700  593  394  1097 212  /],
                    [qw/ 1348 1483 749  1658 401  952  1039 1488 791  1344 488  591  744  1472 1076 1475 784  1170 384  450  1035 938  1179 /],
                    [qw/ 4472 4388 2174 3527 5587 3454 2560 6247 2238 2778 4399 1750 4738 2918 6680 3141 3872 6634 2017 3458 1922 3374 2768 /],
                    [qw/ 2627 3407 2299 3094 2721 2705 2814 2804 2155 2500 2503 2701 3058 2914 2940 2596 2723 2710 3022 2557 2652 2920 2687 /],
                    [qw/ 6466 3596 153  3335 1921 3255 437  4486 2769 755  91   155  480  1954 5697 5327 1263 9577 52   268  68   2797 122  /],
                    [qw/ 2366 3984 300  837  1304 1909 3800 1994 2135 2089 5148 1956 1513 2160 1943 1918 2036 4800 1100 816  937  1327 918  /],
                    [qw/ 6862 5746 4220 5739 5646 4848 7089 5160 5514 6083 5187 4491 5154 6029 5870 4923 5287 5901 4055 4765 6213 3894 4694 /],
            ];

    # Create Statistics::FactorAnalysis object with checking of variable distributions.
    my $fac = Statistics::FactorAnalysis->new(dist_check => 1);

    # Set compulsory format option - can be set in constructor as with any Moose attribute.
    $fac->format('variable');

    # Set compulsory LoL option. Points to reference of LoL of the data.
    $fac->LoL($data); 

    # Load the data. 
    $fac->load_data;

    # Loading complained so log transform data.
    use Math::Cephes qw(:explog);
    for my $row (@{$data}) { for my $col (@{$row}) { $col = log10($col); }}

    # Re-load data.
    $fac->load_data;
