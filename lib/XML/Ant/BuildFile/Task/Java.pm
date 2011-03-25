#
# This file is part of XML-Ant-BuildFile
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

package XML::Ant::BuildFile::Task::Java;

BEGIN {
    $XML::Ant::BuildFile::Task::Java::VERSION = '0.205';
}

# ABSTRACT: Java task node in an Ant build file

use Carp;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use MooseX::Types::Path::Class 'File';
use Path::Class;
use namespace::autoclean;
with 'XML::Ant::BuildFile::Role::InProject';

my %xpath_attr = (
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    classname  => './@classname',
    _jar       => './@jar',
    _args_attr => './@args',
);

while ( my ( $attr, $xpath ) = each %xpath_attr ) {
    has $attr => ( ro,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => $xpath,
    );
}

has jar => ( ro, lazy,
    isa => File,
    default =>
        sub { file( $ARG[0]->project->apply_properties( $ARG[0]->_jar ) ) },
);

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Task::Java - Java task node in an Ant build file

=head1 VERSION

version 0.205

=head1 SYNOPSIS

=head1 DESCRIPTION

This is an incomplete class for
L<Ant Java task|http://ant.apache.org/manual/Tasks/java.html>s in a
L<build file project|XML::Ant::BuildFile::Project>.

=head1 ATTRIBUTES

=head2 classname

A string representing the Java class that's executed.

=head2 jar

A L<Path::Class::File|Path::Class::File> for the jar file being executed.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://github.com/mjgardner/XML-Ant-BuildFile/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by GSI Commerce.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
