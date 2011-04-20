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

package XML::Ant::BuildFile::Element::Arg;

BEGIN {
    $XML::Ant::BuildFile::Element::Arg::VERSION = '0.214';
}

# ABSTRACT: Argument element for a task in an Ant build file

use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Maybe Str);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use XML::Ant::Properties;
use namespace::autoclean;
with 'XML::Rabbit::Node';

for my $attr (qw(value file path pathref line prefix suffix)) {
    has "_$attr" => ( ro,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => "./\@$attr",
    );
}

has _args => ( ro, lazy_build,
    isa => ArrayRef [ Maybe [Str] ],
    traits  => ['Array'],
    handles => { args => 'elements' },
);

sub _build__args
{    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    return [ $self->_value ] if $self->_value;
    return [ split / \s /, $self->_line ] if $self->_line;
    {
        ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
        return [
            XML::Ant::Properties->apply(
                '${toString:' . $self->_pathref . '}'
            )
            ]
            if $self->_pathref;
    }
    return [];
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Element::Arg - Argument element for a task in an Ant build file

=head1 VERSION

version 0.214

=head1 SYNOPSIS

    package My::Ant::Task;
    use Moose;
    with 'XML::Ant::BuildFile::Task';

    has arg_objects => (
        isa         => 'ArrayRef[XML::Ant::BuildFile::Element::Arg]',
        traits      => ['XPathObjectList'],
        xpath_query => './arg',
    );

    sub all_args {
        my $self = shift;
        return map {$_->args} @{ $self->arg_objects };
    }

=head1 DESCRIPTION

This is an incomplete class to represent C<< <arg/> >> elements in a
L<build file project|XML::Ant::BuildFile::Project>.

=head1 METHODS

=head2 args

Returns a list of arguments contained in the element.  Currently
handles C<< <arg/> >> elements with the following attributes:

=over

=item value

=item line

=item pathref

=back

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
