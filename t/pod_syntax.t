use strict;
use warnings;

use Test::More;
use Test::PodSyntax;
use Test::Builder::Tester;
use Test::Builder::Tester tests => 1;

    my $desc;
    test_pass($desc);
    Test::PodSyntax::check('t');
    test_test($desc);

done_testing();
