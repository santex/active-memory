use Test::More;
use Acme::MetaSyntactic::haddock;
use t::NoLang;

plan tests => 1;

# Windows or not, I do not care
@INC  = grep /\bblib\b/, @INC;
$^O   = 'MSWin32';
$meta = Acme::MetaSyntactic::haddock->new;
is( $meta->lang, 'fr', "Correct default without Win32::Locale" );

