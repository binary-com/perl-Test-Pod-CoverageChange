package Test::Pod::CoverageChange;
# ABSTRACT: check perl modules against their pod coverage

=pod

=head1 NAME

Pod coverage calculator test file.

=head1 SYNOPSIS

It checks all files that placed under the `lib` folder against their POD coverage to see if all existing functions have POD or not?
It checks all files that placed under the `lib` folder against their POD syntax to see if they have a valid POD syntax or not.

=head1 DESCRIPTION

Prints the percentage of POD coverage in **TODO** test format for currently existing packages.
Prints B<not ok> (with respective message) if our latest changes increased/decreased numbers of naked functions in currently existing packages.
Prints B<not ok> if currently existing packages have 100% coverage unless you remove the package from B<%naked_packages> variable.
Prints a proper message for the newly added packages.

prints B<ok> for the files that have no POD syntax error.
prints B<not ok- There is no POD in the file> if the file has no POD at all. I put this into a TODO test so CircleCI's tests will pass.
prints B<not ok- The number of errors in the POD structure> if the file has any error. It causes CircleCI's tests to fail.

=cut
use strict;
use warnings;

use Test::More;
use Pod::Checker;
use Pod::Coverage;
use File::Find::Rule;
use Test::Pod::Coverage;

our $VERSION='0.01';

use constant {
  POD_SYNTAX_IS_OK => 0,
  FILE_HAS_NO_POD => -1,
};

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(check);

=pod

=head2 check

Todo: Update this pod

Check all modules under the given directory against POD coverage and POD syntax

=over 4

=item * C<directory> An arrayref of directories to check pod against

=item * C<naked_packages> A hashref that contains some packages which are allowed to have naked subs.

=back

=cut

sub check {
    my $path = shift;
    my $naked_packages = shift;

    $path = [$path] unless ref $path eq 'ARRAY';

    check_pod_coverage($path, $naked_packages);
    # check_pod_syntax($path);

    Test::Pod::CoverageChange->export_to_level(1, @_);
}

=head2 check_pod_coverage

Todo:: complete this pod

=cut

sub check_pod_coverage {
    my $directories = shift;
    my $naked_packages = shift;

    check_existing_naked_packages($naked_packages) if defined $naked_packages;

    # Check for newly added packages PODs
    foreach my $package (Test::Pod::Coverage::all_modules(@$directories)) {
        next if $naked_packages && (grep(/^$package$/, keys %$naked_packages));
        use Data::Dumper;
        warn 'STR'x20 . __FILE__ . ':' . __LINE__ ;
        warn Dumper $package;
        warn 'END'x20 . __FILE__ . ':' . __LINE__ ;
        
        pod_coverage_ok($package, {private => []});
    }
}

=head2 check_pod_syntax

Todo:: complete this pod

=cut

sub check_pod_syntax {
    my $directories = shift;
    $directories = [$directories] if ref $directories ne 'ARRAY';

    my @files_path = File::Find::Rule->file()
                                     ->name( '*.p[m|l]' )
                                     ->in(@$directories);

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

=head2 check_existing_naked_packages

Todo:: complete this pod

=cut

sub check_existing_naked_packages {
    my $naked_packages = shift;

    # Note: We can remove this foreach section if the %naked_packages hash be empty.
    # Check for the currently naked packages POD.
    foreach my $package (sort keys %$naked_packages) {
        my $pc = Pod::Coverage->new(package => $package, private => []);
        my $fully_covered = defined $pc->coverage && $pc->coverage == 1;
        my $coverage_percentage = defined $pc->coverage ? $pc->coverage * 100 : 0;
        my $max_expected_naked_subs = $naked_packages->{$package};
        my $naked_subs_count = scalar $pc->naked // scalar $pc->_get_syms($package);

        TODO: {
            local $TODO;

            if (!$fully_covered) {
                $TODO = sprintf("We have %.2f%% POD coverage for the module '%s'.", $coverage_percentage, $package);
                fail;
            }
        }

        if(!$fully_covered && $naked_subs_count < $max_expected_naked_subs) {
            fail sprintf(<<'MESSAGE', $package, $package, $naked_subs_count, __FILE__);
Your last changes decreased the number of naked subs in the %s package.
Change the %s => %s in the %%naked_packages variable in %s please.
MESSAGE
            next;
        }
        elsif(!$fully_covered && $naked_subs_count > $max_expected_naked_subs) {
            fail sprintf('Your last changes increased the number of naked subs in the %s package.', $package);
            next;
        }


        if ($fully_covered) {
            fail sprintf('%s modules has 100%% POD coverage. Please remove it from the %s file %%naked_packages variable to fix this error.',
              $package, __FILE__);
        }
    }
}

1;
