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

package XML::Ant::BuildFile::Task::Concat;

BEGIN {
    $XML::Ant::BuildFile::Task::Concat::VERSION = '0.213';
}

# ABSTRACT: concat task node in an Ant build file

use English '-no_match_vars';
use Moose;
use MooseX::Types::Moose 'Str';
use MooseX::Has::Sugar;
use MooseX::Types::Path::Class 'File';
use Path::Class;
use XML::Ant::Properties;
use namespace::autoclean;
extends 'XML::Ant::BuildFile::ResourceContainer';
with 'XML::Ant::BuildFile::Task';

has _destfile =>
    ( ro,
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    isa         => Str,
    traits      => ['XPathValue'],
    xpath_query => './@destfile',
    );

has destfile => ( ro, lazy,
    isa => File,
    default =>
        sub { file( XML::Ant::Properties->apply( $ARG[0]->_destfile ) ) },
);

1;

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Task::Concat - concat task node in an Ant build file

=head1 VERSION

version 0.213

=head1 SYNOPSIS

    package My::Ant;
    use Moose;
    with 'XML::Rabbit::Node';

    has paths => (
        isa         => 'ArrayRef[XML::Ant::BuildFile::Task::Concat]',
        traits      => 'XPathObjectList',
        xpath_query => './/concat',
    );

=head1 DESCRIPTION

This is a L<Moose|Moose> type class meant for use with
L<XML::Rabbit|XML::Rabbit> when processing C<< <concat/> >> tasks in an Ant
build file.

=head1 ATTRIBUTES

=head2 destfile

The file to concatenate into as a L<Path::Class::File|Path::Class::File>
object.

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
