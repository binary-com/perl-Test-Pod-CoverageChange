# NAME

Wraps Test::Pod::Coverage to support undocumented subs and statistics on changed coverage

# VERSION

version 0.0001

# SYNOPSIS


It checks all files that placed under the `lib` folder against their POD syntax to see if they have a valid POD syntax or not.

# DESCRIPTION

Prints C<ok> for the files that have no POD syntax error.
Prints C<not ok>- There is no POD in the file - if the file has no POD at all.
Prints C<not ok>- The number of errors in the POD structure - if the file has any error.

# AUTHOR

Deriv Services Ltd. C<< DERIV@cpan.org >>.

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by binary.com.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
