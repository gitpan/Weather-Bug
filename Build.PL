use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Weather::Bug',
    license             => 'perl',
    dist_author         => 'G. Wade Johnson <wade@anomaly.org>',
    dist_version_from   => 'lib/Weather/WeatherBug.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Weather-WeatherBug-*' ],
);

$builder->create_build_script();
