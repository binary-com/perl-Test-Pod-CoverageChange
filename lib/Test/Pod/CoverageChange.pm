use strict;
use warnings;

package Test::Pod::CoverageChange;
# ABSTRACT: check perl modules against their pod coverage

our $VERSION = '0.001';
# AUTHORITY

use utf8;

=encoding utf8

=head1 NAME

Pod coverage calculator test file.

=head1 SYNOPSIS

    use Test::Pod::CoverageChange qw(pod_coverage_syntax_ok);

    Test::Pod::CoverageChange::pod_coverage_syntax_ok('lib', {
        Module::With::3::expected::naked::subs              => 3,
        AnotherModule::With::10::expected::naked::subs      => 10,
        YetAnotherModule::With::1::expected::naked::subs    => 1,
        YetAnotherModule::With::5::expected::naked::subs    => 5,
    }, [
        We::Ignore::ThisModule,
        We::Also::Ignore::This::Module
    ]);

=head1 DESCRIPTION

It checks all files that placed under a given directory against their
POD coverage to see if all existing subs have POD and also
POD syntax to see if is there an POD syntax error or not?

Prints the percentage of POD coverage in B<TODO> test format for the packages that we allowed to have naked subs.
Prints an error message if our latest changes increased/decreased numbers of naked sub for the packages that we allowed to have naked sub.
Prints an error message if a naked allowed package has 100% POD coverage. (We should remove it from the C<%naked_packages> variable list.)
Ignores to check every package that we pass as C<@ignored_package>
Prints a proper message for the newly added packages.

It will generate c<ok> if the file have no POD syntax or coverage error.
If the file has no POD at all, it will generate a failing TODO test.
If the file has any POD error it will generate a C<not ok> fail test and pointing to the number of errors in the POD structure.

=cut

use Test::More;
use Pod::Checker;
use Pod::Coverage;
use File::Find::Rule;
use Test::Pod::Coverage;
use Module::Path qw(module_path);
use List::Util qw(any);

use constant {
    POD_SYNTAX_IS_OK => 0,
    FILE_HAS_NO_POD  => -1,
    FALSE            => 0,
    TRUE             => 1,
};

use Exporter qw(import export_to_level);
our @EXPORT_OK = qw(pod_coverage_syntax_ok);

=head2 pod_coverage_syntax_ok

Check all modules under a given directory against POD coverage and POD syntax

=over 4

=item * C<$path> - path or arrayref of directories to check (recursively)

=item * C<naked_packages> packages that are allowed to have naked subs, supports hashref.

=item * C<ignored_packages> packages that we are going to ignore to check, supports arrayref

=back

=cut

sub pod_coverage_syntax_ok {
    my $path = shift;
    my $allowed_naked_packages = shift // {};
    my $ignored_packages = shift // [];

    $path = [ $path ] unless ref $path eq 'ARRAY';
    $ignored_packages = [ $ignored_packages ] unless ref $ignored_packages eq 'ARRAY';

    check_pod_coverage($path, $allowed_naked_packages, $ignored_packages);
    check_pod_syntax($path, $ignored_packages);
}

=head2 check_pod_coverage

Checks POD coverage for all the modules that exists under a given directory.
Passes the $allowed_naked_packages to the L<Test::Pod::CoverageChange::check_allowed_naked_packages>
Ignores the packages in the C<$ignored_packages> parameter

=over 4

=item C<path> - path to check recursively, supports string or arrayref

example: ['lib', 'other directory'] | 'lib'

=item C<allowed_naked_packages> These packages are allowed to have naked subs equal to specified numbers.

example: {Package1 => 2, Package2 => 1, Package3 => 10}

=item C<ignored_packages> - A list of packages that will be ignored in our checks, supports arrayref. (optional)

example: ['MyPackage1', 'MyPackage2', 'MyPackage3']

=back

=cut

sub check_pod_coverage {
    my $path = shift;
    my $allowed_naked_packages = shift;
    my $ignored_packages = shift;

    check_allowed_naked_packages($allowed_naked_packages, $ignored_packages) if keys %$allowed_naked_packages;

    # Check for newly added packages PODs
    my @ignored_packages = (keys %$allowed_naked_packages, @$ignored_packages);
    foreach my $package (Test::Pod::Coverage::all_modules(@$path)) {
        next if @ignored_packages && (any {$_ eq $package} @ignored_packages);
        pod_coverage_ok($package, { private => [] });
    }
}

=head2 check_pod_syntax

Check POD syntax for all the modules that exists under a given directory.

=over 4

=item * C<$path> - path or arrayref of directories to check (recursively)

example: ['lib', 'other directory'] | 'lib'

=item C<ignored_packages> - A list of packages that will be ignored in our checks, supports arrayref. (optional)

example: ['MyPackage1', 'MyPackage2', 'MyPackage3']

=back

=cut

sub check_pod_syntax {
    my $path = shift;
    my $ignored_packages = shift;
    my $Test_Builder = Test::More->builder;

    my @ignored_packages_full_path = ();
    for (@$ignored_packages) {
        my $file_path = module_path($_);
        push(@ignored_packages_full_path, $file_path) if defined $file_path;
    }

    my @files_path = File::Find::Rule->file()
        ->name('*.p[m|l]')
        ->in(@$path);

    for my $file_path (@files_path) {
        chomp $file_path;
        next if @ignored_packages_full_path && grep (/$file_path/, @ignored_packages_full_path);

        my $check_result = podchecker($file_path);
        if ($check_result == POD_SYNTAX_IS_OK) {
            $Test_Builder->ok(TRUE, sprintf("Pod structure is OK in the file %s.", $file_path));
        }
        elsif ($check_result == FILE_HAS_NO_POD) {
            $Test_Builder->todo_skip(sprintf("There is no POD in the file %s.", $file_path));
        }
        else {
            $Test_Builder->ok(FALSE, sprintf("There are %d errors in the POD structure in the %s.", $check_result, $file_path));
        }
    }
}

=head2 check_allowed_naked_packages

Checks passed allowed_naked_packages against existing package files and prints

=over 4

=item C<path> - path to check recursively, supports string or arrayref

example: ['lib', 'other directory'] | 'lib'

=item C<ignored_packages> - A list of packages that will be ignored in our checks, supports arrayref. (optional)

example: ['MyPackage1', 'MyPackage2', 'MyPackage3']

=back

Prints C<todo fail> message if the numbers of existing naked subs are equal to passed value.
Prints a normal C<fail> message if the numbers of existing naked subs are more/less than the passed value.
Prints a normal C<fail> message if a package has 100% POD coverage and it passed as a naked_package.

=cut

sub check_allowed_naked_packages {
    my $allowed_naked_packages = shift;
    my $ignored_packages = shift;
    my $caller_test_file = (caller(2))[1];
    my $Test_Builder = Test::More->builder;

    # Check for the currently naked packages POD.
    foreach my $package (sort keys %$allowed_naked_packages) {
        next if $ignored_packages && (grep (/^$package$/, @$ignored_packages));

        my $pc = Pod::Coverage->new(package => $package, private => []);
        my $fully_covered = defined $pc->coverage && $pc->coverage == 1;
        my $coverage_percentage = defined $pc->coverage ? $pc->coverage * 100 : 0;
        my $max_expected_naked_subs = $allowed_naked_packages->{$package};
        my $naked_subs_count = scalar $pc->naked // scalar $pc->_get_syms($package);

        if (!$fully_covered) {
            $Test_Builder->todo_skip(sprintf("We have %.2f%% POD coverage for the module '%s'.", $coverage_percentage, $package));
        }

        if (!$fully_covered && $naked_subs_count < $max_expected_naked_subs) {
            $Test_Builder->ok(FALSE, sprintf(<<'MESSAGE', $package, $package, $naked_subs_count, $caller_test_file));
Your last changes decreased the number of naked subs in the %s package.
Change the %s => %s in the %s file please.
MESSAGE
            next;
        }
        elsif (!$fully_covered && $naked_subs_count > $max_expected_naked_subs) {
            $Test_Builder->ok(FALSE, sprintf('Your last changes increased the number of naked subs in the %s package.', $package));
            next;
        }

        if ($fully_covered) {
            $Test_Builder->ok(FALSE, sprintf('%s modules has 100%% POD coverage. Please remove it from the %s file $naked_packages variable to fix this error.',
                $package, $caller_test_file));
        }
    }
}

1;
