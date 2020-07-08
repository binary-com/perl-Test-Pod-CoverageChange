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
    use_ok( 'Nopod');
}

subtest 'Module with no pod, unexpected' => sub {
    my $path = module_path('Test::Pod::CoverageChange');

    test_out("not ok 1 - Pod coverage on t::Nopod");
    test_diag("  Failed test 'Pod coverage on t::Nopod'", "  at $path line 91.", "t::Nopod: couldn't find pod");
    test_out("not ok 2 # TODO There is no POD in the file t/Nopod.pm.");
    test_out("#   Failed (TODO) test at $path line 118.");
    Test::Pod::CoverageChange::check('t/Nopod.pm');
    test_test( "Handles files with no pod at all" );
};

done_testing();
