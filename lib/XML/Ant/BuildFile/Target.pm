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
    $XML::Ant::BuildFile::Target::VERSION = '0.206';
}

# ABSTRACT: target node within an Ant build file

use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Str);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use XML::Ant::BuildFile::Task::Java;
use namespace::autoclean;
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

sub BUILD {
    my $self = shift;

    my %isa_map = map { lc( ( split /::/ => $ARG )[-1] ) => $ARG }
        $self->project->task_plugins;
    $self->meta->add_attribute(
        _tasks => (
            traits      => [qw(XPathObjectList Array)],
            xpath_query => join( q{|} => map {".//$ARG"} keys %isa_map ),
            isa_map     => \%isa_map,
            handles     => {
                all_tasks    => 'elements',
                task         => 'get',
                filter_tasks => 'grep',
                num_tasks    => 'count',
            },
        )
    );
    return;
}

sub tasks {
    my ( $self, @names ) = @ARG;
    return $self->filter_tasks( sub { $ARG->task_name ~~ @names } );
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Target - target node within an Ant build file

=head1 VERSION

version 0.206

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

=head1 METHODS

=head2 all_tasks

Returns an array of task objects contained in this target.

=head2 task

Given an index number returns that task from the target.

=head2 filter_tasks

Returns all task objects for which the given code reference returns C<true>.

=head2 num_tasks

Returns a count of the number of tasks in this target.

=head2 BUILD

Automatically run after object construction to set up task object support.

=head2 tasks

Given one or more task names, returns a list of task objects.

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
