use warnings;
use strict;
# use lib "/home/git/regentmarkets/perl-Test-Pod-CoverageChange/t";
use lib "t";
use Test::More;# tests=>2;
use Test::Builder::Tester;
use Test::MockModule;
use Module::Path 'module_path';

BEGIN {
    use_ok( 'Test::Pod::CoverageChange' );
    use_ok('t::Nopod');
}

subtest 'Module with no pod, unexpected' => sub {
    my $test_module = "t::Nopod";
    my $test_module_path = 't/Nopod.pm';
    my $main_module_path = module_path('Test::Pod::CoverageChange');

    test_out("not ok 1 - Pod coverage on $test_module");
    test_diag("  Failed test 'Pod coverage on $test_module'", "  at $main_module_path line 91.", "$test_module: couldn't find pod");
    test_out("not ok 2 # TODO There is no POD in the file $test_module_path.");
    test_out("#   Failed (TODO) test at $main_module_path line 118.");
    Test::Pod::CoverageChange::check($test_module_path);
    test_test("Handles files with a pod error");
};

done_testing();
