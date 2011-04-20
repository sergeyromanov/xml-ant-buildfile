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

package XML::Ant::BuildFile::Task;

BEGIN {
    $XML::Ant::BuildFile::Task::VERSION = '0.214';
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

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Task - Role for Ant build file tasks

=head1 VERSION

version 0.214

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
