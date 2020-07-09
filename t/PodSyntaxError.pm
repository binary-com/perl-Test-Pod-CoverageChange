#!/usr/bin/perl
package t::PodSyntaxError;

use warnings;
use strict;

=head2 foo

This pod has a syntax error. (=over has no =back to close)

=over 4

=item * C<P> a sample parameter

=cut

sub foo {}

=head2 bar

=over 4

=item * first item

=cut

sub bar {}
sub baz {}

1;
