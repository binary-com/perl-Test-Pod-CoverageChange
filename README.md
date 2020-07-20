# NAME

Wraps Test::Pod::Coverage to support undocumented subs and statistics on changed coverage

# VERSION

version 0.0001

# SYNOPSIS

It checks all files that placed under the `lib` folder against their POD syntax to see if they have a valid POD syntax or not.

# DESCRIPTION

Prints **ok** for the files that have no POD syntax error.
Prints **not ok- There is no POD in the file** if the file has no POD at all. I put this into a TODO test so CircleCI's tests will pass.
Prints **not ok- The number of errors in the POD structure** if the file has any error. It causes CircleCI's tests to fail.

# AUTHOR

Deriv Services Ltd. C<< DERIV@cpan.org >>.

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by deriv.com.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
