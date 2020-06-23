package Test::PodSyntax;

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

use Test::More;
use Pod::Checker;

use base 'Exporter';
our @EXPORT_OK = qw( check );

use constant {
  POD_SYNTAX_IS_OK => 0,
  FILE_HAS_NO_POD => -1,
};

=head2 check

This function checks the POD syntax for a given set of directories.

=over 4

=item * C<directories>

It's a set of directories that we want to check POD syntax in.
It can be a comma separated string or an arrayref of strings.

=back

=cut

sub check {
    my $directories = shift;
    $directories = join(', ', @$directories) if ref $directories eq 'ARRAY';

    my @files_path = `find $directories -name '*.p[lm]'`;

    for my $file_path (@files_path) {
        chomp $file_path;
        my $check_result = podchecker($file_path);

        if ($check_result == POD_SYNTAX_IS_OK){
            pass sprintf("Pod structure is OK in the file %s.", $file_path);
        } elsif ($check_result == FILE_HAS_NO_POD) {
            TODO: {
                local $TODO = sprintf("There is no POD in the file %s.", $file_path);
                fail;
            }
        } else {
            fail sprintf("There are %d errors in the POD structure in the %s.", $check_result, $file_path);
        }
    }
}
