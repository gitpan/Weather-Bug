package Weather::Bug;
our $VERSION = '0.01';

use base 'Exporter';
our @EXPORT = our @EXPORT_OK = qw/get_live_weather/;

use HTTP::Request::Common;
use LWP::UserAgent;
use strict;
use warnings;

my @fields = qw/
    last_updated
    date
    temp
    wind_direction
    wind_speed
    max_wind_direction
    max_wind_speed
    precip
    precip_rate
    pressure
    humidity
    UNKNOWN
    max_temp
    min_temp
    site_name
    x
    dew_point
    heat_index
    monthly_rain
    temp_change
    humidity_change
    pressure_change
    location
    x
    x
    x
    max_humidity
    min_humidity
    max_pressure
    min_pressure
    max_precip_rate
    UNKNOWN
    DONE
/;

sub get_live_weather {	
    my ($station, $units) = @_;
    $units ||= 'fmii';

    my $agent = LWP::UserAgent->new(keep_alive => 1,
                                    timeout => 15,
                                   );
    my $response = $agent->send_request(
        GET "http://wisapidata.weatherbug.com/WxDataISAPI/WxDataISAPI.dll?GetJavaData&StationID=$station&Units=$units"
    );

    return undef unless $response->is_success;

    my $raw_data = $response->content;
    return undef unless $raw_data =~ /---DONE---/;

    my %data;
    @data{@fields} = split /\r\n/, $raw_data;
    for (@fields) {
        $data{$_} =~ s{(?: % | mm | \xB0 | \"/h | mm/h | mbar | mbar/h | /h | \" )\Z}{}x;
    }

    $data{wind_chill} = $data{heat_index};	
    delete $data{x};
    delete $data{DONE};

    $data{wind_direction} = angle_to_direction( $data{wind_direction} );
    $data{max_wind_direction} = angle_to_direction( $data{max_wind_direction} );
        
    return wantarray ? %data : \%data;
}

sub angle_to_direction {
    my $angle = shift;
    
    return (qw/N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW/)
        [ (( $angle + 11.25 ) % 360) / 22.5 ];
}


__END__

=head1 NAME

Weather::Bug - Get realtime weather where available

=head1 SYNOPSIS

    use Weather::Bug;

    my $w = get_live_weather( 'KCMI' );
    print "It is $w->{temp} degrees in $w->{location}\n";

=head1 ABOUT

Weather::Bug uses data from aws.com's live Java weather applet. Not all
available stations report live data, however. If the station closest to you
does not report live weather data to aws.com, you are probably better off
using one of the other Weather:: modules from CPAN.

=head2 Disclaimer

This Perl module is not endorsed or supported in any way by AWS Convergence
Technologies. "WeatherBug" is their trademark.

=head1 USAGE

    get_live_weather($station_id [, $units])

Weather::Bug exports only one funcion, C<get_live_weather>. The first argument
is the station ID. You can find the ID of a station near you at this page:

    http://www.aws.com/aws_2001/asp/getLiveWeather.asp

If you get a list of sites, click one to view current conditions. Look at the
URL of the link that says "Live Broadcast JAVA." The part of the URL that
reads "?id=XXXX" is your station ID. For example, my old high school in
Fredericksburg, Iowa, is FRDRC.

The units argument defaults to American, and supports these values:

    0 American
    1 Metric
    2 American, but pressure in millibars

This function returns a reference to a hash in scalar context, or a hash in
list context. The keys of the hash are as follows:

    last_updated
    date
    temp
    wind_direction
    wind_speed
    max_wind_direction
    max_wind_speed
    precip
    precip_rate
    pressure
    humidity
    max_temp
    min_temp
    site_name
    dew_point
    heat_index
    monthly_rain
    temp_change
    humidity_change
    pressure_change
    location
    max_humidity
    min_humidity
    max_pressure
    min_pressure
    max_precip_rate

Be aware that not all stations report all of these items. Units are stripped
from all measurements and rates.

=head1 AUTHOR

Weather::Bug by Mike Rosulek E<lt>mike@mikero.comE<gt>.

=head1 COPYRIGHT

Copyright (c) 2003 Mike Rosulek. All rights reserved. This module is free
software; you can redistribute it and/or modify it under the same terms as Perl
itself.

