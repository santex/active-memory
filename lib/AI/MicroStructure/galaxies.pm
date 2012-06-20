package AI::MicroStructure::galaxies;
use strict;
use AI::MicroStructure::MultiList;
our @ISA = qw( AI::MicroStructure::MultiList );
__PACKAGE__->init();

our %Remote = (
    source => {
        nearest => 'http://en.wikipedia.org/wiki/List_of_galaxies',
        polar_ring  => 'http://en.wikipedia.org/wiki/List_of_polar-ring_galaxies',
        local_group=>'http://en.wikipedia.org/wiki/Local_Group',
        spiral=>'http://en.wikipedia.org/wiki/List_of_spiral_galaxies',
        quasar=>'http://en.wikipedia.org/wiki/List_of_quasars',	
        supercluster=>'http://en.wikipedia.org/wiki/List_of_galaxy_superclusters',
        cluster=>'http://en.wikipedia.org/wiki/List_of_galaxy_clusters',
    },
    extract => sub {
        return 
            map { AI::MicroStructure::RemoteList::tr_accent($_) }
            map { AI::MicroStructure::RemoteList::tr_utf8_basic($_) }
            grep { ! /^List_|_Groups$/ }
            map { s/[-\s']/_/g; s/[."]//g; $_ }
            $_[0]
            =~ m{^<li>(?:<[^>]*>)?(.*?)(?:(?: ?[-,(<]| aka | see ).*)?</li>}mig
    },
    ,
);


1;

__DATA__
# names nearest
# names polar_ring
# names spiral_galaxies
# names local_group
