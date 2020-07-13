use strict;
use warnings;

use Test::More;
use Test::Builder::Tester;
use Module::Path 'module_path';

BEGIN {
    use_ok( 'Test::Pod::CoverageChange' );
    use_ok('t::Nopod');
}

# Initializing variables
my $test_module = "t::Nopod";
my $test_module_path = 't/Nopod.pm';
my $main_module_path = module_path('Test::Pod::CoverageChange');

subtest 'Module with no pod, unexpected' => sub {
    test_out("not ok 1 - Pod coverage on $test_module");
    test_out("not ok 2 # TODO There is no POD in the file $test_module_path.");
    test_out("#   Failed (TODO) test at $main_module_path line 162.");
    test_diag("  Failed test 'Pod coverage on $test_module'");
    test_diag("  at $main_module_path line 118.");
    test_diag("$test_module: couldn't find pod");
    Test::Pod::CoverageChange::check($test_module_path);
    test_test("Handles files with a pod error");
};

subtest 'We can expect module naked sub' => sub {
    Test::Pod::CoverageChange::check($test_module_path, {'t::Nopod' => 3});
};

subtest 'Ignore some tests' => sub {
    Test::Pod::CoverageChange::check($test_module_path, {}, ['t::Nopod']);
    pass('Bad Pods ignored successfully.');
};

done_testing();
