package SimplePackageWithPodSyntaxError;
use strict;
use warnings;

=head2 a_simple_sub

This is a head2 description

=over 4

=item this item has no C<back> to close it. so it throws an error message in syntax checking.

=cut
sub a_simple_sub {
    return 1;
}

