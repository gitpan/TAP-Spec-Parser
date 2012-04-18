package TAP::Spec::Plan::SkipAll;
# ABSTRACT: A TAP plan indicating that all tests were skipped
our $VERSION = '0.07_99'; # VERSION
our $AUTHORITY = 'cpan:ARODLAND'; # AUTHORITY
use Mouse;
use namespace::autoclean;
extends 'TAP::Spec::Plan';


has 'reason' => ( 
  is => 'rw',
  isa => 'Str',
  required => 1,
);


sub number_of_tests { 0 }


sub as_tap {
  my ($self) = @_;

  return "1..0 skip " . $self->reason . "\n";
}

__PACKAGE__->meta->make_immutable;

__END__
=pod

=head1 NAME

TAP::Spec::Plan::SkipAll - A TAP plan indicating that all tests were skipped

=head1 VERSION

version 0.07_99

=head1 ATTRIBUTES

=head2 reason

B<Required>: The reason for skipping all tests.

=head1 METHODS

=head2 $plan->number_of_tests

Returns 0 (all tests were skipped)

=head2 $plan->as_tap

TAP representation.

=head1 AUTHOR

Andrew Rodland <arodland@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Andrew Rodland.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

