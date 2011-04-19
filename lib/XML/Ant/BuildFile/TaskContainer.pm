#
# This file is part of XML-Ant-BuildFile
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.012;
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

package XML::Ant::BuildFile::TaskContainer;

BEGIN {
    $XML::Ant::BuildFile::TaskContainer::VERSION = '0.209';
}

# ABSTRACT: Container for XML::Ant::BuildFile::Task plugins

use English '-no_match_vars';
use Moose;
use Module::Pluggable (
    sub_name    => 'task_plugins',
    search_path => 'XML::Ant::BuildFile::Task',
    require     => 1,
);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)

sub BUILD {
    my $self = shift;

    ## no critic (ValuesAndExpressions::ProhibitMagicNumbers)
    my %isa_map = map { lc( ( split /::/ => $ARG )[-1] ) => $ARG }
        $self->task_plugins;
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

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::TaskContainer - Container for XML::Ant::BuildFile::Task plugins

=head1 VERSION

version 0.209

=head1 SYNOPSIS

    package XML::Ant::BuildFile::Task::Foo;
    use Moose;
    extends 'XML::Ant::BuildFile::TaskContainer';

=head1 DESCRIPTION

Base class for containers of multiple
L<XML::Ant::BuildFile::Task|XML::Ant::BuildFile::Task> plugins.

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
