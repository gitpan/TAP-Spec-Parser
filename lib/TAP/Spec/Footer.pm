package TAP::Spec::Footer;
BEGIN {
  $TAP::Spec::Footer::AUTHORITY = 'cpan:ARODLAND';
}
{
  $TAP::Spec::Footer::VERSION = '0.07_991'; # TRIAL
}
# ABSTRACT: Trailing information in a TAP stream
use Mouse;
use namespace::autoclean;

use TAP::Spec::Comment ();


has 'comments' => (
  is => 'rw',
  isa => 'ArrayRef',
  predicate => 'has_comments',
);



has 'leading_junk' => (
  is => 'rw',
  isa => 'ArrayRef',
  predicate => 'has_leading_junk',
);


has 'trailing_junk' => (
  is => 'rw',
  isa => 'ArrayRef',
  predicate => 'has_trailing_junk',
);

sub as_tap {
  my ($self) = @_;

  my $tap = "";

  if ($self->has_leading_junk) {
    $tap .= $_->as_tap for @{ $self->leading_junk };
  }

  if ($self->has_comments) {
    $tap .= $_->as_tap for @{ $self->comments };
  }

  if ($self->has_trailing_junk) {
    $tap .= $_->as_tap for @{ $self->trailing_junk };
  }

  return $tap;
}

__PACKAGE__->meta->make_immutable;

__END__

=pod

=head1 NAME

TAP::Spec::Footer - Trailing information in a TAP stream

=head1 VERSION

version 0.07_991

=head1 ATTRIBUTES

=head2 comments

B<Optional>: An arrayref of footer comments

=head2 leading_junk

B<Optional>: leading junk lines

=head2 trailing_junk

B<Optional>: trailing junk lines

=head1 METHODS

=head2 $footer->as_tap

TAP representation.

=head1 AUTHOR

Andrew Rodland <arodland@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Andrew Rodland.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
