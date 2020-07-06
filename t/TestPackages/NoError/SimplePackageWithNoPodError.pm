package SimplePackageWithCorrectPodSyntax;
use strict;
use warnings;

=pod

=head1 SimplePackageWithCorrectPodSyntax

This package created to help us test the pod syntax checker module.

=cut

=head2 a_simple_sub_with_correct_pod

This is a head2 description

=over 4

=item this item has no C<back> to close it. so it throws an error message in syntax checking.

=back

=cut
sub a_simple_sub_with_correct_pod {
    return 1;
}

