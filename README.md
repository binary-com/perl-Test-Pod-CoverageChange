# NAME

Test::Pod::CoverageChange - Test Perl files for POD coverage and syntax changes

# SYNOPSIS

    use Test::Pod::CoverageChange qw(pod_coverage_syntax_ok);

    pod_coverage_syntax_ok('lib', {
        MyModule::Bar => 3,  ## expected to have 3 naked subs
        MyModule::Foo => 10, ## expected to have 10 naked subs
        MyModule::Baz => 1,  ## expected to have 1 naked subs
        MyModule::Qux => 5,  ## expected to have 5 naked subs
    }, [
        We::Ignore::ThisModule,
        We::Also::Ignore::This::Module
    ],[
        'a_sub_name_to_ignore'
        qr/regexes are also acceptable/
    ]);

# DESCRIPTION

`Test::Pod::CoverageChange` is a helper combining [Test::Pod::Coverage](https://metacpan.org/pod/Test%3A%3APod%3A%3ACoverage) and
[Pod::Checker](https://metacpan.org/pod/Pod%3A%3AChecker) to test for both POD coverage and syntax changes for a module
distribution at once, via a single call to ["pod\_coverage\_syntax\_ok"](#pod_coverage_syntax_ok).

Possible results

- **passes** if the file has no POD syntax or coverage error.
- **fails** if latest changes increased/decreased numbers of naked subs for the packages that have allowed naked subs.
- **fails** if a package allowed to have naked subs has 100% POD coverage.
- **fails** if a file in a given path has POD syntax error or has no POD.

Ignores packages that passed as ignored package in the c&lt;$ignored\_package> argument into the pod\_coverage\_syntax\_ok sub.

## pod\_coverage\_syntax\_ok

Checks all the modules under a given directory against POD coverage and POD syntax

- `$path` - path or arrayref of directories to check (recursively)

    example: \['lib', 'other directory'\] | 'lib'

- `$allowed_naked_packages` - hashref of number of allowed naked subs, keyed by package name (optional)

    example: {Package1 => 2, Package2 => 1, Package3 => 10}

- `$ignored_packages` - arrayref of packages that will be ignored in the checks (optional)

    example: \['MyPackage1', 'MyPackage2', 'MyPackage3'\]

- `$ignored_subs` - arrayref of subnames or regexes that will be ignored in the checks (optional)

    example: \['a\_sub\_name', qr/a regex/\]

## \_check\_pod\_coverage

Checks POD coverage for all the modules that exist under the given directory.
Passes the `$allowed_naked_packages` to ["\_check\_allowed\_naked\_packages" in Test::Pod::CoverageChange](https://metacpan.org/pod/Test%3A%3APod%3A%3ACoverageChange#check_allowed_naked_packages).
Ignores the packages in the `$ignored_packages` parameter.

- `$path` - path or arrayref of directories to check (recursively)
- `$allowed_naked_packages` - hashref of number of allowed naked subs, keyed by package name (optional)
- `$ignored_packages` - arrayref of packages that will be ignored in the checks (optional)

## \_check\_pod\_syntax

Check POD syntax for all the modules that exist under the given directory.

- `$path` - path or arrayref of directories to check (recursively)
- `$ignored_packages` - arrayref of packages that will be ignored in the checks (optional)

## \_check\_allowed\_naked\_packages

Checks passed allowed\_naked\_packages against existing package files.

- `$allowed_naked_packages` - hashref of number of allowed naked subs, keyed by package name (optional)
- `$ignored_packages` - a list of packages that will be ignored in our checks, supports arrayref (optional)

Possible results

- **todo fail** if the numbers of existing naked subs are equal to passed value.
- **fails** if the number of existing naked subs are not equal to the passed value.
- **fails** if a package has 100% POD coverage and it passed as a [$allowed\_naked\_package](https://metacpan.org/pod/%24allowed_naked_package).
