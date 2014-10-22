package TAP::Spec::Comment;
BEGIN {
  $TAP::Spec::Comment::VERSION = '0.03';
}
# ABSTRACT: A comment in a TAP stream
use Mouse;
use namespace::autoclean;


has 'text' => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);


sub as_tap {
  my ($self) = @_;

  return "#" . $self->text . "\n";
}

__PACKAGE__->meta->make_immutable;

__END__
=pod

=head1 NAME

TAP::Spec::Comment - A comment in a TAP stream

=head1 VERSION

version 0.03

=head1 ATTRIBUTES

=head2 text

B<Required>: the comment text.

=head1 METHODS

=head2 $comment->as_tap

TAP representation.

=head1 AUTHOR

  Andrew Rodland <arodland@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Andrew Rodland.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

