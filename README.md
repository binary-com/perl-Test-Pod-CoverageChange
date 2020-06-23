# perl-Test-Pod-CoverageChange
Wraps Test::Pod::Coverage to support undocumented subs and statistics on changed coverage

# NAME

Test::PodCoverage
Test::PodSyntax

# VERSION

version 0.0001

# SYNOPSIS

    use Test::PodCoverage qw(check);

    Test::PodCoverage::check('lib', {
        MyModule::File1 => 3,
        MyModule::File2 => 1,
        MyModule::File3 => 4,
    });
    

    use Test::PodSyntax qw(check);

    Test::PodCoverage::check('lib');

# DESCRIPTION

This Perl module check a given set of folders against the POD coverage and the POD syntax.

# METHODS

## check

The only method that both modules have is the `check` method.

**Parameters**

=head2 Test::PodCoverage::check($directories, $naked_packages);

=over 4

=item * C<directories> Is a mandatory parameter that can be a `string` or an `arrayref` of directories to check pod against.

=item * C<naked_packages> Is an optional parameter that contains some packages which are allowed to have naked subs.

=back

=head2 Test::PodSyntax::check($directories);

=over 4

=item * C<directories>

It's a set of directories that we want to check POD syntax in,
It can be a `comma separated string` or an `arrayref of strings`.

=back

**Response:**

    [{
        street   => '370 Townsend St',
        city     => 'San Francisco',
        state    => 'CA',
        zipcode  => '94107-1607',
    }]

# AUTHOR

Ramin Sadeghnasab <ramin@firstsource.tech>

# CONTRIBUTOR

Ramin Sadeghnasab <ramin@firstsource.tech>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Ramin Sadeghnasab.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
