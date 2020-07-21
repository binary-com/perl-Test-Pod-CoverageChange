use strict;
use warnings;

use Test::More;
use Test::Builder::Tester;
use Dir::Self;
use lib __DIR__ . '/..';

use Test::Pod::CoverageChange;

my $test_module = "t::CorrectPod";
my $test_module_path = 't/CorrectPod.pm';

subtest 'Module has perfect pod' => sub {
    test_out("ok 1 - Pod coverage on $test_module");
    test_out("ok 2 - Pod structure is OK in the file $test_module_path.");
    Test::Pod::CoverageChange::check($test_module_path);
    test_test( "Pods are completely correct." );
    done_testing;
};

done_testing;
