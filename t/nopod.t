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
    my $mock_tet_pod_coverage = Test::MockModule->new('Test::Pod::Coverage');
    $mock_tet_pod_coverage->mock( 'all_modules', sub {
        return ('Nopod');
    });
    my $path = module_path('Test::Pod::CoverageChange');

    test_out("not ok 1 - Pod coverage on Nopod");
    test_diag("  Failed test 'Pod coverage on Nopod'", "  at $path line 91.", "Nopod: couldn't find pod");
    test_out("not ok 2 # TODO There is no POD in the file t/Nopod.pm.");
    test_out("#   Failed (TODO) test at $path line 118.");
    Test::Pod::CoverageChange::check('t/Nopod.pm');
    test_test( "Handles files with no pod at all" );
};

# subtest 'Module with no pod, unexpected' => sub {
#     fail('Should add some more tests');
# };

done_testing();
