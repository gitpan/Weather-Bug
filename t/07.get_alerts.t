use Test::More tests => 2;

use warnings;
use strict;

use Weather::Bug;
use FindBin;
use lib "$FindBin::Bin/lib";
use MockLWPSimple;
use Test::Group;

my $wxbug = Weather::Bug->new( -key => 'FAKELICENSEKEY', -getsub => \&MockLWPSimple::get );

my @alerts = $wxbug->get_alerts( 77096 );

is( scalar( @alerts ), 1, 'Right number of alerts.' );

my $index = 0;
foreach my $a (@alerts)
{
    alert_ok( $a, "Alert $index" );
    ++$index;
}

# -------
# Utility functions to simplify the testing.
sub alert_ok
{
    my $a = shift;
    my $name = shift || 'alert_ok';

    test $name => sub {
        isa_ok( $a, 'Weather::Bug::Alert' );
        ok( length $a->type() > 0, "Type '@{[ $a->type() ]}' not valid" );
        ok( length $a->title() > 0, "Title '@{[ $a->title() ]}' not valid" );
    };
}

