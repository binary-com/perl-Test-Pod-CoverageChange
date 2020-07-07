#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Test::Pod::CoverageChange' ) || print "Bail out!
";
}

diag( "Testing Test::Pod::CoverageChange $Test::Pod::CoverageChange::VERSION, Perl $], $^X" );
