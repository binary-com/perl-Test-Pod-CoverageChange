use strict;
use warnings;

use Test::PodSyntax;

use Test::More;
use Test::Builder;
use Test::Builder::Tester;

my $desc;
test_out("not ok 1 - There are 1 errors in the POD structure in the t/test-packages/Syntax/HasError/SimplePackageWithPodSyntaxError.pm.");
test_err("#   Failed test 'There are 1 errors in the POD structure in the t/test-packages/Syntax/HasError/SimplePackageWithPodSyntaxError.pm.'
#   at /home/git/regentmarkets/test-pod-coverage-syntax/lib/Test/PodSyntax.pm line 69.");
Test::PodSyntax::check('t/test-packages/Syntax/HasError');
test_test($desc);

test_out("ok 1 - Pod structure is OK in the file t/test-packages/Syntax/NoError/SimplePackageWithCorrectPodSyntax.pm.");
Test::PodSyntax::check('t/test-packages/Syntax/NoError');
test_test($desc, 'this is the description');

done_testing();
