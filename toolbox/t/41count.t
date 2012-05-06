use Test::More;
use Acme::MetaSyntactic;

plan tests => 1;

my $count = $Acme::MetaSyntactic::VERSION;
$count =~ y/.//d;
$count += 0; # 0 as of version 0.88
             # 1 as of version 0.85
             # 3 as of version 0.73
             # 4 as of version 0.70
             # 5 as of version 0.55
             # 6 as of version 0.38
             # 7 as of version 0.25

@ARGV = 'MANIFEST';
my @themes = grep {m!^lib/Acme/MetaSyntactic/[a-z]!} <>;

is( scalar @themes, $count, "$count themes" );

