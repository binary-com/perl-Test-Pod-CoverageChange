# perl-Test-Pod-CoverageChange
Wraps Test::Pod::Coverage to support undocumented subs and statistics on changed coverage

# NAME

Test::PodSyntax - check perl modules against their pod syntax

# VERSION

version 0.0001

# SYNOPSIS

It checks all files that placed under the \`lib\` folder against their POD syntax to see if they have a valid POD syntax or not.

# DESCRIPTION

prints **ok** for the files that have no POD syntax error.
prints **not ok- There is no POD in the file** if the file has no POD at all. I put this into a TODO test so CircleCI's tests will pass.
prints **not ok- The number of errors in the POD structure** if the file has any error. It causes CircleCI's tests to fail.

## check

This function checks the POD syntax for a given set of directories.

- `directories`

    It's a set of directories that we want to check POD syntax in.
    It can be a comma separated string or an arrayref of strings.

# NAME

Pod syntax checker test file

# AUTHOR

Ramin Sadeghnasab <ramin@email.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by binary.com.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
