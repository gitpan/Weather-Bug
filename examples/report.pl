#!/usr/bin/perl

use lib '../lib';
use Weather::Bug;

my $weather = get_live_weather(shift || 'FRDRC', shift || 0);

die("Couldn't fetch weather!\n") unless $weather;

printf(qq{
    Weather report from %s (%s):
    
                  Current  Minimum  Maximum  Rate
    Temperature:  %-7s  %-7s  %-7s  %s
    Humidity:     %-7s  %-7s  %-7s  %s
    Daily Precip: %-7s           %-5s/h  %s
    Pressure:     %-7s  %-7s  %-7s  %s
    
    Wind:         %-2s %-3s   Gust:    %-2s %-3s
    Feels Like:   %-7s  Dew Pt:  %s
    
},
    @$weather{qw/ location   last_updated
                 temp       min_temp       max_temp        temp_change
                 humidity   min_humidity   max_humidity    humidity_change
                 precip                    max_precip_rate precip_rate
                 pressure   min_pressure   max_pressure    pressure_change
                 wind_speed wind_direction max_wind_speed  max_wind_direction
                 heat_index dew_point
               /}
);
