package Test::Pod::CoverageChange;
# ABSTRACT: Test Perl files for POD coverage and syntax changes

use strict;
use warnings;

our $VERSION = '0.001';
# AUTHORITY

use utf8;

=encoding utf8

=head1 NAME

Test::Pod::CoverageChange - Test Perl files for POD coverage and syntax changes

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

C<Test::Pod::CoverageChange> is a helper combining L<Test::Pod::Coverage> and
L<Pod::Checker> to test for both POD coverage and syntax changes for a module
distribution at once, via a single call to L</pod_coverage_syntax_ok>.

C<passes> if the file have no POD syntax or coverage error.
C<fails> if latest changes increased/decreased numbers of naked sub for the packages that have allowed naked subs.
C<fails> if a package allowed to have naked subs has 100% POD coverage.
C<fails> if a file in a given path has POD syntax error or has no POD.

Ignores to check every package that we pass as C<$ignored_package>

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

Checks all modules under a given directory against POD coverage and POD syntax

=over 4

=item * C<$path> - path or arrayref of directories to check (recursively)

example: ['lib', 'other directory'] | 'lib'

=item C<$allowed_naked_packages> These packages are allowed to have naked subs equal to specified numbers. (optional)

example: {Package1 => 2, Package2 => 1, Package3 => 10}

=item C<$ignored_packages> - A list of packages that will be ignored in our checks, supports arrayref. (optional)

example: ['MyPackage1', 'MyPackage2', 'MyPackage3']

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
Passes the $allowed_naked_packages to the L<Test::Pod::CoverageChange::check_allowed_naked_packages>.
Ignores the packages in the C<$ignored_packages> parameter.

=over 4

=item * C<$path> - path or arrayref of directories to check (recursively)

=item C<$allowed_naked_packages> These packages are allowed to have naked subs equal to specified numbers. (optional)

=item C<$ignored_packages> - A list of packages that will be ignored in our checks, supports arrayref. (optional)

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

=item C<$ignored_packages> - A list of packages that will be ignored in the checks, supports arrayref. (optional)

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

Checks passed allowed_naked_packages against existing package files.

=over 4

=item C<$allowed_naked_packages> These packages are allowed to have naked subs equal to specified numbers. (optional)

=item C<$ignored_packages> - A list of packages that will be ignored in our checks, supports arrayref. (optional)

=back

C<todo fail> if the numbers of existing naked subs are equal to passed value.
C<fails> if the numbers of existing naked subs are more/less than the passed value.
C<fails> if a package has 100% POD coverage and it passed as a L<$allowed_naked_package>.

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
