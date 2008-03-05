use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Catalyst::View::Download',
    AUTHOR              => 'Travis Chase <gaudeon@cpan.org>',
    VERSION_FROM        => 'lib/Catalyst/View/Download.pm',
    ABSTRACT_FROM       => 'lib/Catalyst/View/Download.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Catalyst::Runtime' => 0,
        'Text::CSV' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Catalyst-View-Download-*' },
);
