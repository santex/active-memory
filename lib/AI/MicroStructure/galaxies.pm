package AI::MicroStructure::galaxies;
use strict;
use AI::MicroStructure::MultiList;
our @ISA = qw( AI::MicroStructure::MultiList );
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
            map { AI::MicroStructure::RemoteList::clean($_) }
            grep { ! /^List_|_Groups$/ }
            map { s/[-\s']/_/g; s/[."]//g; $_ }
            $_[0]
            =~ m{^<li>(?:<[^>]*>)?(.*?)(?:(?: ?[-,(<]| aka | see ).*)?</li>}mig
    },
    ,
);

__PACKAGE__->init();


1;

__DATA__
version=0
# names nearest
  Andromeda
  Leo_I
  Leo_II
  Cassiopeia
  Pisces
  Phoenix
  Hydra
  Sagittarius
  Barycentric_coordinates
  Pegasus
  Canes_Venatici_I
  Canes_Venatici_II
  Sculptor
  Carina
  dwarf_galaxy
  Draco
  Virgo
  Indus
  Sculptor
  Aquarius
  Grus
  Capricornus
# names local_group
  Galaxy_10R
  Galaxy_11
  Galaxy_15
  Galaxy_17
  Galaxy_18
  Galaxy_25
  Galaxy_26
  Galaxy_27
  Galaxy_28
  Galaxy_3C
  Galaxy_4R
