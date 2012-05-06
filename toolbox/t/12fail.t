use Test::More tests => 1;

require Acme::MetaSyntactic;
eval { import Acme::MetaSyntactic 'xyzzy'; };
like( $@, qr!^Can't locate Acme/MetaSyntactic/xyzzy.pm in \@INC!,
      "No such theme");

