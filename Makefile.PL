
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Reference implementation of the TAP specification',
  'AUTHOR' => 'Andrew Rodland <arodland@cpan.org>',
  'BUILD_REQUIRES' => {
    'Carp' => '0',
    'Path::Class' => '0',
    'Test::More' => '0',
    'YAML::Any' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'TAP-Spec-Parser',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'TAP::Spec::Parser',
  'PREREQ_PM' => {
    'Mouse' => '0',
    'Mouse::Util::TypeConstraints' => '0',
    'Regexp::Grammars' => '1.008',
    'namespace::autoclean' => '0'
  },
  'VERSION' => '0.02',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



