use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'AI::MicroStructure',
    AUTHOR              => 'Hagen "santex" Geissler <santex@cpan.org>',
    VERSION_FROM        => 'lib/AI/MicroStructure.pm',
    ABSTRACT_FROM       => 'lib/AI/MicroStructure/',
    PL_FILES            => {},
    PREREQ_PM => {
'Test::More' => 0,
'File::Glob' => 0,
'List::Util' => 0,
'JSON'=>0,
'POE'=>0,
'CouchDB::Client'=>0,
'Getopt::Long'=>0,
'Curses' => 0,
'Search::ContextGraph' => 0,
'Rose::DB::Object' => 0,
'Term::ShellUI'=>0,
'File::Stat'=>0,
'POE::Component::Server::HTTP'=>0,
'POE::Component::Server::TCP' => 0,
'Search::ContextGraph' => 0,
'Cwd' => 0,
'CGI'=>0,
'Data::Freq'=>0,
'Test::Simple' => 0.44,
'JSON::Any' => 1.17,

    },
    EXE_FILES  => [
'scripts/microfy',
'scripts/micro-cli',
'scripts/micro-main',
'scripts/micro-steemer',
'scripts/micro-wikiend',
'scripts/micro-wnet',
'scripts/micro',
'scripts/micro-bashcommand',
'scripts/micro-dict',
'scripts/micro-rename',
'scripts/micro-tojson',
'scripts/micro-wikilist',
'scripts/micro-sense',
'scripts/micro-wnwikilist',
'scripts/am-try'
],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'AI-MicroStructure-*' },
);




