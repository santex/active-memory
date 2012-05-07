        use Search::ContextGraph;


         my $cg = Search::ContextGraph->new();

         # first you add some documents, perhaps all at once...

         my %docs = (
           'first'  => [ 'elephant', 'snake' ],
           'second' => [ 'camel', 'pony' ],
           'third'  => { 'snake' => 2, 'constrictor' => 1 },
         );

         $cg->bulk_add( %docs );

         # or in a loop...

         foreach my $title ( keys %docs ) {
      #          $cg->add( $title, $docs{$title} );
         }

         #     or from a file...

       #  my $cg = Search::ContextGraph->load_from_dir( "./myfiles" );

         # you can store a graph object for later use

         $cg->store( "stored.cng" );

         # and retrieve it later...

        # my $cg = ContextGraph->retrieve( "stored.cng" );


         # SEARCHING

         # the easiest way

         my @ranked_docs = $cg->simple_search( 'peanuts' );


         # get back both related terms and docs for more power

         my ( $docs, $words ) = $cg->search('snake');


         # you can use a document as your query

         my ( $docs, $words ) = $cg->find_similar('First Document');


         # Or you can query on a combination of things

         my ( $docs, $words ) =
           $cg->mixed_search( { docs  => [ 'First Document' ],
                                terms => [ 'snake', 'pony' ]}
                            );


         # Print out result set of returned documents
         foreach my $k ( sort { $docs->{$b} <=> $docs->{$a} }
             keys %{ $docs } ) {
             print "Document $k had relevance ", $docs->{$k}, "\n";
         }



         # Reload it
        my $new = Search::ContextGraph->retrieve( "filename" );

