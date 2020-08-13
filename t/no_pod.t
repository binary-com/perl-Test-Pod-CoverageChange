use strict;
use warnings;

use Dir::Self;
use lib __DIR__ . '/..';
use Test::More;
use Test::Builder::Tester;
use Module::Path 'module_path';

use Test::Pod::CoverageChange;
use t::Nopod;

# Initializing variables
my $test_module = "t::Nopod";
my $test_module_path = 't/Nopod.pm';
my $main_module_path = module_path('Test::Pod::CoverageChange');

subtest 'Module with no pod, unexpected' => sub {
    test_out("not ok 1 - Pod coverage on $test_module");
    test_out("not ok 2 # TODO & SKIP There is no POD in the file $test_module_path.");
    test_diag("  Failed test 'Pod coverage on $test_module'");
    test_diag("  at $main_module_path line 129.");
    test_diag("$test_module: couldn't find pod");
    Test::Pod::CoverageChange::pod_coverage_syntax_ok($test_module_path);
    test_test("Handles files with a pod error");
    done_testing;
};

subtest 'We can expect module naked sub' => sub {
    Test::Pod::CoverageChange::pod_coverage_syntax_ok($test_module_path, {'t::Nopod' => 3});
};

subtest 'Ignore some tests' => sub {
    Test::Pod::CoverageChange::pod_coverage_syntax_ok($test_module_path, {}, ['t::Nopod']);
    pass('Even bad Pods can be ignored successfully.');
};

done_testing;
