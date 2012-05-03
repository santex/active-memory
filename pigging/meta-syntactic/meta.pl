          use Acme::MetaSyntactic; # loads the default theme
           print metaname();

           # this sets the default theme and loads Acme::MetaSyntactic::shadok
           my $meta = Acme::MetaSyntactic->new( 'shadok' );

           print $meta->name();          # return a single name
           my @names = $meta->name( 4 ); # return 4 distinct names (if possible)

           # you can temporarily switch theme
           # (though it shifts your metasyntactical paradigm in other directions)
           my $foo = $meta->name( 'foo' );       # return 1 name from theme foo
        
           # but why would you need an instance variable?
           use Acme::MetaSyntactic qw( batman robin );

           # the first loaded theme is the default (here batman)
           print metaname;
           my @names = metaname( 4 );

           print join ',', metabatman(3), metarobin;

           # the convenience functions are only exported
           # - via the Acme::MetaSyntactic import list
           # - when an individual theme is used
           print join $/, metabatman( 5 );

        

