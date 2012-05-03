
    use Statistics::PCA::Varimax;

           # Each nested array ref corresponds to the loadings for a single factor.
           my $loadings = [
                               [qw/  0.28681878905  0.69807334810  0.74438876316  0.47052419229  0.68079195447  0.49817011866  0.86049803480  0.64178962603 0.29784558460 /],
                               [qw/  0.07560334830  0.15335493657 -0.40959477002  0.52231277744 -0.15586396086 -0.49832262559 -0.11502014276  0.32160898539 0.59537280152 /],
                               [qw/ -0.84084848877 -0.08371208961  0.02047721303 -0.13507580587  0.14832508991  0.25345619152 -0.01159349490 -0.04396749541 0.53340721684 /],
                          ];

           # Calculate the rotated loadings and orthogonal matrix.
           my ($rotated_loadings_ref, $orthogonal_matrix_ref) = &rotate($loadings);

           print qq{\nRotated Loadings:\n};
           for my $c (0..$#{$rotated_loadings_ref->[0]}) { for my $r (0..$#{$rotated_loadings_ref}) {
               #print qq{$rotated_loadings_ref->[$r][$c], and r: $r and c: $c\t} }; print qq{\n};
               print qq{$rotated_loadings_ref->[$r][$c]\t} }; print qq{\n};
               }

           print qq{\nOrthogonal Matrix:\n};
           for my $r (0..$#{$orthogonal_matrix_ref}) { for my $c (0..$#{$orthogonal_matrix_ref->[$r]}) {
               print qq{$orthogonal_matrix_ref->[$r][$c]\t} }; print qq{\n};
               }

