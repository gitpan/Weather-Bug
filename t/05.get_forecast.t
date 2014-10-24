use Test::More tests => 4 + 13;

use warnings;
use strict;

use Weather::Bug;
use FindBin;
use lib "$FindBin::Bin/lib";
use MockLWPSimple;
use Test::Group;
use TestHelper;

my $wxbug = Weather::Bug->new( -key => 'FAKELICENSEKEY', -getsub => \&MockLWPSimple::get );

my $forecast = $wxbug->get_forecast( 77096 );

isa_ok( $forecast, 'Weather::Bug::SevenDayForecast' );
is( $forecast->type(), 'detailed', 'Type is correct' );
datetime_ok( $forecast->date(), 'date',
    { ymd => '2008-07-18', hms => '20:32:00', tz => 'floating' } );
isa_ok( $forecast->location(), 'Weather::Bug::Location' );

my $index = 0;
foreach my $s (@{ $forecast->forecasts() })
{
    forecast_ok( $s, "Forecast $index" );
    ++$index;
}

# -------
# Utility functions to simplify the testing.
sub forecast_ok
{
    my $f = shift;
    my $name = shift || 'forecast_ok';

    test $name => sub {
        isa_ok( $f, 'Weather::Bug::Forecast' );
        ok( (length $f->title() > 0), 'title' );
        ok( (length $f->short_title() > 0), 'short_title' );
        like( $f->imageurl(), qr[^http://.*?\.gif], 'imageurl' );
        ok( (length $f->description() > 0), 'description' );
        ok( (length $f->prediction() > 20), 'prediction' );
        my $high = $f->high();
        my $low = $f->low();
        isa_ok( $high, 'Weather::Bug::Temperature', 'high temp' );
        isa_ok( $low, 'Weather::Bug::Temperature', 'low temp' );
        ok( (!$low->is_null() or !$high->is_null()), 'Either high or low cannot be null' );
        if( !$high->is_null() and !$low->is_null() )
        {
            ok( ($low->f() <= $high->f()), 'High is higher than low.' );
        }
    };
}

