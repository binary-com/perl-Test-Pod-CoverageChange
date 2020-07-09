use strict;
use warnings;

use lib 't';
# use lib "/home/git/regentmarkets/perl-Test-Pod-CoverageChange/t";
use Test::More;
use Test::Builder;
use Test::Builder::Tester;

use Test::Pod::CoverageChange;
use t::CorrectPod;
# use t::PodSyntaxError;


# use_ok( 'Test::Pod::CoverageChange' );
use_ok( 't::CorrectPod' );
# use_ok( 't::PodSyntaxError' );

my $desc;
# test_out("not ok 1 - Pod coverage on t::PodSyntaxError");
# test_out("not ok 2 - There are 2 errors in the POD structure in the t/PodSyntaxError.pm.");
# test_diag("  Failed test 'Pod coverage on t::PodSyntaxError'");
# test_diag("  at /home/git/regentmarkets/perl-Test-Pod-CoverageChange/lib/Test/Pod/CoverageChange.pm line 92.");
# test_diag("t::PodSyntaxError: requiring 't::PodSyntaxError' failed");
# test_diag("  Failed test 'There are 2 errors in the POD structure in the t/PodSyntaxError.pm.'");
# test_diag("  at /home/git/regentmarkets/perl-Test-Pod-CoverageChange/lib/Test/Pod/CoverageChange.pm line 122.");
# Test::Pod::CoverageChange::check('t/CorrectPod.pm', {'t::CorrectPod' => 1});
# test_test(" is working perfectly.");

# test_out("ok 1 - Pod structure is OK in the file t/test-packages/Syntax/NoError/SimplePackageWithCorrectPodSyntax.pm.");
# Test::PodSyntax::check('t/test-packages/Syntax/NoError');
# test_test($desc, 'this is the description');

done_testing();
