use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
                    NAME          => 'Weather::Bug',
                    VERSION_FROM  => 'lib/Weather/Bug.pm',
                    PREREQ_PM     => { HTTP::Request::Common => 0,
                                       LWP::UserAgent => 0 },
    ($] >= 5.005 ? (ABSTRACT_FROM => 'lib/Weather/Bug.pm',
                    AUTHOR        => 'Mike Rosulek <mike@mikero.com>')
                 : ()),
);
