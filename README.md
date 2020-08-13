# NAME

Wraps Test::Pod::Coverage and Pod::Checker modules to support undocumented subs and statistics on changed coverage.

# VERSION

version 0.001

# SYNOPSIS

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

# DESCRIPTION

- **passes** if the file have no POD syntax or coverage error.
- **fails** if latest changes increased/decreased numbers of naked sub for the packages that have allowed naked subs.
- **fails** if a package allowed to have naked subs has 100% POD coverage.
- **fails** if a file in a given path has POD syntax error or has no POD.

# AUTHOR

Deriv Services Ltd. C<< DERIV@cpan.org >>.

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by deriv.com.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
