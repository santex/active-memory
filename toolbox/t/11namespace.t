use Test::More tests => 1;
use Acme::MetaSyntactic::donmartin;

# check that metaname is not exported into Acme::MetaSyntactic::List
ok(
    !exists $Acme::MetaSyntactic::List::{metaname},
    "metaname not exported to AMS::List"
);
