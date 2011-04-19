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

package XML::Ant::BuildFile::Task;

BEGIN {
    $XML::Ant::BuildFile::Task::VERSION = '0.211';
}

# ABSTRACT: Role for Ant build file tasks

use strict;
use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use namespace::autoclean;
with 'XML::Ant::BuildFile::Role::InProject';

has task_name => ( ro, lazy,
    isa      => Str,
    init_arg => undef,
    default  => sub { $ARG[0]->node->nodeName },
);

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Task - Role for Ant build file tasks

=head1 VERSION

version 0.211

=head1 SYNOPSIS

    package XML::Ant::BuildFile::Task::Foo;
    use Moose;
    with 'XML::Ant::BuildFile::Task';

    after BUILD => sub {
        my $self = shift;
        print "I'm a ", $self->task_name, "\n";
    };

    1;

=head1 DESCRIPTION

This is a role shared by tasks in an
L<XML::Ant::BuildFile::Project|XML::Ant::BuildFile::Project>.

=head1 ATTRIBUTES

=head2 task_name

Name of the task's XML node.

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
