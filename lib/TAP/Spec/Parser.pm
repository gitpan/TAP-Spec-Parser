package TAP::Spec::Parser;
BEGIN {
  $TAP::Spec::Parser::VERSION = '0.03';
}
# ABSTRACT: Reference implementation of the TAP specification
use strict;
use warnings;

use TAP::Spec::TestSet ();

my $tap_grammar = do {
use Regexp::Grammars 1.008;

qr~
# Main production
<testset>

# Definitions from first grammar section

# Testset         = Header (Plan Body / Body Plan) Footer
<objtoken: TAP::Spec::TestSet=testset> 
  <header> (?: <plan> <body> | <body> <plan> ) <footer>

# Header          = [Comments] [Version]
<objtoken: TAP::Spec::Header=header> 
  <[leading_junk=junk_line]>*?
  <comments>? <version>?
  <[trailing_junk=junk_line]>*?

# Footer          = [Comments]
<objtoken: TAP::Spec::Footer=footer> 
  <[leading_junk=junk_line]>*?
  <comments>?
  <[trailing_junk=junk_line]>*?

# Body            = *(Comment / TAP-Line)
<objtoken: TAP::Spec::Body=body> 
  (?: <[lines=comment]> | <[lines=tap_line]> | <[lines=junk_line]> )*

# TAP-Line        = Test-Result / Bail-Out
<token: tap_line> 
  <MATCH=test_result>
| <MATCH=bail_out>

# Version         = "TAP version" SP Version-Number EOL ; ie. "TAP version 13"
<objtoken: TAP::Spec::Version=version> 
  (?i:TAP <.sp> version) <.sp> <version_number> <.eol>

# Version-Number  = Positive-Integer
<token: version_number> 
  <MATCH=positive_integer>

# Plan            = ( Plan-Simple / Plan-Todo / Plan-Skip-All ) EOL
<token: plan> 
  (?: <MATCH=plan_simple> | <MATCH=plan_todo> | <MATCH=plan_skip_all> ) <.eol>

# Plan-Simple     = "1.." Number-Of-Tests
<objtoken: TAP::Spec::Plan::Simple=plan_simple>
  1.. <number_of_tests>

# Plan-Todo       = Plan-Simple "todo" 1*(SP Test-Number) ";"  ; Obsolete
<objtoken: TAP::Spec::Plan::Todo=plan_todo>
  <plan_simple> (?i:todo) (?: <.sp> <[skipped_tests=test_number]> )+ ;
  (?{ 
    $MATCH{number_of_tests} = $MATCH{plan_simple}{number_of_tests};
    delete $MATCH{plan_simple};
  })

# Plan-Skip-All   = "1..0" SP "skip" SP Reason
<objtoken: TAP::Spec::Plan::SkipAll=plan_skip_all>
  1..0 <.sp> (?i:skip) <.sp> <reason>

# Reason          = String
<token: reason>
  <MATCH=string>

# Number-Of-Tests = 1*DIGIT               ; The number of tests contained in this stream
<token: number_of_tests>
  \d+

# Test-Number     = Positive-Integer      ; The sequence of a test result
<token: test_number>
  <MATCH=positive_integer>

# Test-Result     = Status [SP Test-Number] [SP Description]
#                    [SP "#" SP Directive [SP Reason]] EOL
<objtoken: TAP::Spec::TestResult=test_result>
  <status> (?: <.sp> <number=test_number> )? (?: <.sp> <description> )?
  (?: 
    <.sp> \# <.sp> <directive> 
    (?: <.sp> <reason>)? 
  )? <.eol>

<objtoken: TAP::Spec::JunkLine=junk_line>
  <text=(.*?)> <.eol>

# Status          = "ok" / "not ok"       ; Whether the test succeeded or failed
<token: status>
  (?i:ok) <MATCH=(?{ "ok" })>
| (?i:not\ ok) <MATCH=(?{ "not ok" })>

# Description     = Safe-String           ; A description of this test.
<token: description>
  <MATCH=safe_string>

# Directive       = "SKIP" / "TODO"
<token: directive>
  (?i:SKIP) <MATCH=(?{ "SKIP" })>
| (?i:TODO) <MATCH=(?{ "TODO" })>

# Bail-Out        = "Bail out!" [SP Reason] EOL
<objtoken: TAP::Spec::BailOut=bail_out>
  (?i:Bail out!) (?: <.sp> <reason>)? <.eol>

# Comment         = "#" String EOL
<objtoken: TAP::Spec::Comment=comment>
  \# <text=string> <.eol>

# Comments        = 1*Comment
<token: comments>
  <[MATCH=comment]>+

# EOL              = LF / CRLF             ; Specific to the system producing the stream
<token: eol>
  \n
| \r\n

# Safe-String      = 1*(%x01-09 %x0B-0C %x0E-22 %x24-FF)  ; UTF8 without EOL or "#"
<token: safe_string>
  [\x01-\x09\x0b-\x0c\x0e-\x22\x24-\xff]+

# String           = 1*(Safe-String / "#")                ; UTF8 without EOL
<token: string>
  (?: <.safe_string> | \# )+

# Positive-Integer = ("1" / "2" / "3" / "4" / "5" / "6" / "7" / "8" / "9") *DIGIT
<token: positive_integer>
  [1-9][0-9]*

# Because of BNF "SP" and because backslash-space in regex is ugly :)
<token: sp>
  \x20
~x;
};


sub parse_from_string {
  my ($self, $input) = @_;
  $input =~ /$tap_grammar/ or return;
  return $/{testset};
}


sub parse_from_handle {
  my ($self, $fh) = @_;
  my $data = do { local $/; <$fh> };
  return $self->parse_from_string($data);
}

1;

__END__
=pod

=head1 NAME

TAP::Spec::Parser - Reference implementation of the TAP specification

=head1 VERSION

version 0.03

=head1 METHODS

=head2 $parser->parse_from_string($input)

Return a parse the given string, and return a L<TAP::Spec::TestSet> if it can
be parsed as TAP, or C<undef> otherwise.

=head2 $parser->parse_from_handle($fh)

As C<parse_from_string>, but read from a filehandle instead. This isn't
a streaming interface, just a convenience method that slurps the handle
and calls C<parse_from_string>.

=head1 AUTHOR

  Andrew Rodland <arodland@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Andrew Rodland.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

