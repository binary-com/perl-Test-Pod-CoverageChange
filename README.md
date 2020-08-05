# NAME

Wraps Test::Pod::Coverage to support undocumented subs and statistics on changed coverage

# VERSION

version 0.001

# SYNOPSIS

It checks all files that placed under a given path against their POD syntax and coverage
to see if they have a valid POD syntax or not.

# DESCRIPTION

It will generate **ok** if the file have no POD syntax or coverage error.
If the file has no POD at all, it will generate a failing TODO test.
If the file has any POD error it will generate a C<not ok> fail test and pointing to the number of errors in the POD structure.

# AUTHOR

Deriv Services Ltd. C<< DERIV@cpan.org >>.

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by deriv.com.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
