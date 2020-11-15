# NAME

Perl test POD coverage change

# VERSION

version 0.001

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

Wraps Test::Pod::Coverage and Pod::Checker modules to support undocumented subs and statistics on changed coverage.

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
