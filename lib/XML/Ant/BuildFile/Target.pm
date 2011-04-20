#
# This file is part of XML-Ant-BuildFile
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.010;
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

package XML::Ant::BuildFile::Target;

BEGIN {
    $XML::Ant::BuildFile::Target::VERSION = '0.214';
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
extends 'XML::Ant::BuildFile::TaskContainer';
with 'XML::Ant::BuildFile::Role::InProject';

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
    return [ map { $self->project->target($ARG) } split /,/,
        $self->_depends ];
}

1;

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Target - target node within an Ant build file

=head1 VERSION

version 0.214

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

=head2 name

Name of the target.

=head2 dependencies

If the target has any dependencies, this will return them as an array reference
of L<XML::Ant::BuildFile::Target|XML::Ant::BuildFile::Target>
objects.

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc XML::Ant::BuildFile

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

L<http://search.cpan.org/dist/XML-Ant-BuildFile>

=item *

RT: CPAN's Bug Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=XML-Ant-BuildFile>

=item *

AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/XML-Ant-BuildFile>

=item *

CPAN Ratings

L<http://cpanratings.perl.org/d/XML-Ant-BuildFile>

=item *

CPAN Forum

L<http://cpanforum.com/dist/XML-Ant-BuildFile>

=item *

CPANTS Kwalitee

L<http://cpants.perl.org/dist/overview/XML-Ant-BuildFile>

=item *

CPAN Testers Results

L<http://cpantesters.org/distro/X/XML-Ant-BuildFile.html>

=item *

CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=XML-Ant-BuildFile>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at L<https://github.com/mjgardner/xml-ant-buildfile/issues>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/mjgardner/xml-ant-buildfile>

  git clone git://github.com/mjgardner/xml-ant-buildfile.git

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by GSI Commerce.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
