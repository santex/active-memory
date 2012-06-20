use Test::More;
use Data::Dumper;
use AI::MicroStructure ();
use strict;
use JSON;
use strict;

my @themes = AI::MicroStructure->themes;

plan tests => ($#themes * 2)+2;

for my $t (@themes) {
    eval "require AI::MicroStructure::$t";
    is( eval { "AI::MicroStructure::$t"->theme },
        $t, "theme() for AI::MicroStructure::$t" );
    my $a = eval { "AI::MicroStructure::$t"->new };
    is( eval { $a->theme }, $t, "theme() for AI::MicroStructure::$t" );
}



#my $data = AI::MicroStructure->load_data('AI::MicroStructure::test');

#is_deeply(encode_json($data));

__DATA__

# foo1
en
fr
# foo
bar
# names en
1
# names fr
1
