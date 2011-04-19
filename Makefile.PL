
use strict;
use warnings;

BEGIN { require 5.012; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'consume Ant build files',
  'AUTHOR' => 'Mark Gardner <mjgardner@cpan.org>',
  'BUILD_REQUIRES' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'Scalar::Util' => '0',
    'Test::More' => '0.94',
    'Test::Most' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'XML-Ant-BuildFile',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'XML::Ant::BuildFile',
  'PREREQ_PM' => {
    'Carp' => '0',
    'English' => '0',
    'Modern::Perl' => '0',
    'Module::Pluggable' => '0',
    'Moose' => '2.0000',
    'Moose::Role' => '0',
    'Moose::Util::TypeConstraints' => '0',
    'MooseX::Has::Sugar' => '0',
    'MooseX::Has::Sugar::Minimal' => '0',
    'MooseX::Singleton' => '0',
    'MooseX::Types::Moose' => '0',
    'MooseX::Types::Path::Class' => '0',
    'Path::Class' => '0',
    'Readonly' => '0',
    'Regexp::DefaultFlags' => '0',
    'TryCatch' => '0',
    'XML::Rabbit' => '0.0.4',
    'XML::Rabbit::Node' => '0.0.4',
    'XML::Rabbit::RootNode' => '0',
    'namespace::autoclean' => '0',
    'utf8' => '0'
  },
  'VERSION' => '0.208',
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



