use strict;
use warnings;

use Dir::Self;
use lib __DIR__ . '/..';
use Test::More;
use Test::Builder::Tester;
use Module::Path 'module_path';

use Test::Pod::CoverageChange;
use t::Nopod;
use t::CorrectPod;
use t::PodSyntaxError;
use t::PartiallyCoveredPod;

# Initializing variables
my $test_module            = "t::Nopod";
my $test_module_path       = ['t/CorrectPod.pm', 't/Nopod.pm', 't/PartiallyCoveredPod.pm'];
my $current_test_file_path = 't/multiple_module_test.t';
my $main_module_path       = module_path('Test::Pod::CoverageChange');

subtest 'every modules will check in the process' => sub {
    test_out(
        "not ok 1 # TODO & SKIP You have 0.00% POD coverage for the module 't::Nopod'.",
        "not ok 2 # TODO & SKIP You have 33.33% POD coverage for the module 't::PartiallyCoveredPod'.",
        "not ok 3 - Your last changes increased the number of naked subs in the t::PartiallyCoveredPod package.",
        "ok 4 - Pod coverage on t::CorrectPod",
        "ok 5 - Pod structure is OK in the file t/CorrectPod.pm.",
        "not ok 6 # TODO & SKIP There is no POD in the file t/Nopod.pm.",
        "ok 7 - Pod structure is OK in the file t/PartiallyCoveredPod.pm.",
    );
    test_diag(
        "  Failed test 'Your last changes increased the number of naked subs in the t::PartiallyCoveredPod package.'",
        "  at $main_module_path line 131."
    );

    Test::Pod::CoverageChange::pod_coverage_syntax_ok($test_module_path, {'t::Nopod' => 3, 't::PartiallyCoveredPod' => 1});
    test_test("Handles multiple modules at once");
    done_testing;
};

subtest 'modules order does not matter' => sub {
    my $tests_modules_paths = ['t/PartiallyCoveredPod.pm', 't/CorrectPod.pm', 't/Nopod.pm'];
    Test::Pod::CoverageChange::pod_coverage_syntax_ok($tests_modules_paths, {'t::Nopod' => 3, 't::PartiallyCoveredPod' => 2});
    done_testing;
};

done_testing;
