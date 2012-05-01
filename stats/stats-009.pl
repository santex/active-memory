    use Math::GSL::Linalg::SVD;

    # Create object.
    my $svd = Math::GSL::Linalg::SVD->new( { verbose => 1 } );

    my $data = [ 
                    [qw/  9.515970281313E-01  1.230695618728E-01 -1.652767938310E-01 /],
                    [qw/ -1.788010086499E-01  3.654739881179E-01  8.526964090247E-02 /],
                    [qw/  4.156708817272E-02  5.298288357316E-02  7.130047145031E-01 /],
               ];

    # Load data.
    $svd->load_data( { data => $data } );

    # Perform singular value decomposition using the Golub-Reinsch algorithm (this is the default - see METHODS).
    # To perform eigen decomposition pass 'eign' as algorithm argument - see METHODS.
    $svd->decompose( { algorithm => q{gd} } );

    # Pass results - see METHODS for more details.
    my ($S_vec_ref, $U_mat_ref, $V_mat_ref, $original_data_ref) = $svd->results;

    # Print elements of vector S.
    print qq{\nPrint diagonal elements in vector S\n};  
    for my $s (@{$S_vec_ref}) { print qq{$s, }; }

    # Print elements of matrix U.
    print qq{\nPrint matrix U\n};  
    for my $r (0..$#{$U_mat_ref}) {
        for my $c (0..$#{$U_mat_ref->[$r]}) { print qq{$U_mat_ref->[$r][$c], } }; print qq{\n}; }

    # Print elements of matrix V.
    print qq{\nPrint matrix V\n};  
    for my $r (0..$#{$V_mat_ref}) {
        for my $c (0..$#{$V_mat_ref->[$r]}) { print qq{$V_mat_ref->[$r][$c], } }; print qq{\n}; }
