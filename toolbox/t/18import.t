use Test::More tests => 2;
use Acme::MetaSyntactic::batman ();
use Acme::MetaSyntactic::haddock ();

# metabatman should not exist
eval { metabatman(1) };
like(
    $@,
    qr/^Undefined subroutine &main::metabatman called/,
    "Function not exported"
);

# metahaddock should not exist
eval { metahaddock(1) };
like(
    $@,
    qr/^Undefined subroutine &main::metahaddock called/,
    "Function not exported"
);
