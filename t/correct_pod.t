use strict;
use warnings;

# use lib "t";
use Test::More tests => 2;
use Test::Builder::Tester;
use Module::Path 'module_path';

my $test_module = "t::CorrectPod";
my $test_module_path = 't/CorrectPod.pm';

BEGIN {
    use_ok( 'Test::Pod::CoverageChange' );
}

subtest 'Module has perfect pod' => sub {
    test_out("ok 1 - Pod coverage on $test_module");
    test_out("ok 2 - Pod structure is OK in the file $test_module_path.");
    Test::Pod::CoverageChange::check($test_module_path);
    test_test( "Pods are completely correct." );
};
