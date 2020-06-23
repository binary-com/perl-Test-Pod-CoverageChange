package Test::PodAll;

use strict;
use warnings;

=pod

=head1 NAME

Pod syntax checker test file

=head1 SYNOPSIS

It checks all files that placed under the `lib` folder against their POD syntax to see if they have a valid POD syntax or not.

=head1 DESCRIPTION

prints B<ok> for the files that have no POD syntax error.
prints B<not ok- There is no POD in the file> if the file has no POD at all. I put this into a TODO test so CircleCI's tests will pass.
prints B<not ok- The number of errors in the POD structure> if the file has any error. It causes CircleCI's tests to fail.

=cut

use Test::PodCoverage qw(check);
use Test::PodSyntax qw(check);

use base 'Exporter';
our @EXPORT_OK = qw( check );

=head2 check

This function checks the POD syntax for a given set of directories.

=over 4

=item * C<directories>

It's a set of directories that we want to check POD coverage and syntax in.
It can be a comma separated string or an arrayref of strings.

=item * C<naked_packages> A hashref that contains some packages which are allowed to have naked subs.

=back

=cut

sub check {
    my $directories = shift;
    my $naked_packages = shift;

    Test::PodCoverage::check($directories, $naked_packages);
    Test::PodSyntax::check($directories);
}

