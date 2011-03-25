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

package XML::Ant::BuildFile::Target;

BEGIN {
    $XML::Ant::BuildFile::Target::VERSION = '0.205';
}

# ABSTRACT: target node within an Ant build file

use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Str);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use namespace::autoclean;
with 'XML::Rabbit::Node' => { -version => '0.0.4' };

has project => (
    isa         => 'XML::Ant::BuildFile::Project',
    traits      => ['XPathObject'],
    xpath_query => q{/},
);

{
## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    has name => (
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => './@name',
    );

    has _depends => (
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => './@depends',
        predicate   => '_has_depends',
    );
}

has dependencies => ( ro, lazy_build, isa => ArrayRef [__PACKAGE__] );

sub _build_dependencies {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    return if not $self->_has_depends or not $self->_depends;

    return [
        map { $self->project->get_target($ARG) } split /,/,
        $self->_depends,
    ];
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Target - target node within an Ant build file

=head1 VERSION

version 0.205

=head1 SYNOPSIS

    use XML::Ant::BuildFile::Project;

    my $project = XML::Ant::BuildFile::Project->new( file => 'build.xml' );
    for my $target ( values %{$project->targets} ) {
        print 'got target: ', $target->name, "\n";
    }

=head1 DESCRIPTION

See L<XML::Ant::BuildFile::Project|XML::Ant::BuildFile::Project> for a complete
description.

=head1 ATTRIBUTES

=head2 project

Reference to the L<XML::Ant::BuildFile::Project|XML::Ant::BuildFile::Project>
at the root of the build file containing this target.

=head2 name

Name of the target.

=head2

If the target has any dependencies, this will return them as an array reference
of L<XML::Ant::BuildFile::Target|XML::Ant::BuildFile::Target>
objects.

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
