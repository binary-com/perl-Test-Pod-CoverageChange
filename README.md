# perl-Test-Pod-CoverageChange
Wraps Test::Pod::Coverage to support undocumented subs and statistics on changed coverage

# NAME

WebService::SmartyStreets

# VERSION

version 0.0105

# SYNOPSIS

    use WebService::SmartyStreets;

    my $ss = WebService::SmartyStreets->new(
        auth_id     => 'abc123',
        auth_token  => 'zyx456',
    );

    $ss->verify_address(...);

# DESCRIPTION

This module provides bindings for the
[SmartyStreets](http://smartystreets.com/products/liveaddress-api) API.

[![Build Status](https://travis-ci.org/aanari/WebService-SmartyStreets.svg?branch=master)](https://travis-ci.org/aanari/WebService-SmartyStreets)

# METHODS

## new

Instantiates a new WebService::SmartyStreets client object.

    my $ss = WebService::SmartyStreets->new(
        auth_id    => $auth_id,
        auth_token => $auth_token,
        timeout    => $retries,    # optional
        retries    => $retries,    # optional
    );

**Parameters**

- - `auth_id`

    _Required_
     

    A valid SmartyStreets auth id for your account.

- - `auth_token`

    _Required_
     

    A valid SmartyStreets auth token for your account.

- - `timeout`

    _Optional_
     

    The number of seconds to wait per request until timing out.  Defaults to `10`.

- - `retries`

    _Optional_
     

    The number of times to retry requests in cases when SmartyStreets returns a 5xx response.  Defaults to `0`.

## verify\_address

Validates an address given.

**Request:**

    verify_address(
        street  => '370 Townsend St',
        city    => 'San Francisco',
        state   => 'CA',
        zipcode => '94107',
    );

**Response:**

    [{
        street   => '370 Townsend St',
        city     => 'San Francisco',
        state    => 'CA',
        zipcode  => '94107-1607',
    }]

**Exceptions:**

- - `WebService::SmartyStreets::Exception::AddressNotFound`

    Address Not Found.

- - `WebService::SmartyStreets::Exception::AddressMissingInformation`

    The address you entered was found but more information is needed to match to a specific address.

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/aanari/WebService-SmartyStreets/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Ali Anari <ali@anari.me>

# CONTRIBUTOR

Naveed Massjouni <naveedm9@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ali Anari.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
