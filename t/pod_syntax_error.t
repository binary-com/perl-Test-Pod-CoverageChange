use strict;
use warnings;

use Dir::Self;
use lib __DIR__ . '/..';
use Test::More;
use Test::Builder::Tester;
use Module::Path 'module_path';

use Test::Pod::CoverageChange;
use t::PodSyntaxError;

subtest 'Module has a pod syntax error' => sub {
    my $test_module = "t::PodSyntaxError";
    my $test_module_path = 't/PodSyntaxError.pm';
    my $main_module_path = module_path('Test::Pod::CoverageChange');

    test_out("not ok 1 - Pod coverage on $test_module");
    test_out("not ok 2 - There are 1 errors in the POD structure in the t/PodSyntaxError.pm.");
    test_diag("  Failed test 'Pod coverage on t::PodSyntaxError'");
    test_diag("  at $main_module_path line 129.");
    test_diag("Coverage for $test_module is 33.3%, with 2 naked subroutines:");
    test_err("# 	baz");
    test_err("# 	foo");
    test_diag("  Failed test 'There are 1 errors in the POD structure in the $test_module_path.'");
    test_diag("  at $main_module_path line 97.");
    warn "\n*** PLEASE IGNORE THE NEXT WARNING AND ERROR MESSAGES THEY ARE PARTS OF TESTING.";
    Test::Pod::CoverageChange::pod_coverage_syntax_ok($test_module_path);
    test_test( "Handles files with no pod at all" );
    done_testing;
};

done_testing;
