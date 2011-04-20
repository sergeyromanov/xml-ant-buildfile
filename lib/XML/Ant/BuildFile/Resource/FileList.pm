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

package XML::Ant::BuildFile::Resource::FileList;

BEGIN {
    $XML::Ant::BuildFile::Resource::FileList::VERSION = '0.214';
}

# ABSTRACT: file list node within an Ant build file

use Modern::Perl;
use English '-no_match_vars';
use Path::Class;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef HashRef Str);
use MooseX::Types::Path::Class qw(Dir File);
use XML::Ant::Properties;
use namespace::autoclean;

has directory => ( ro, required, lazy_build, isa => Dir, init_arg => undef );

sub _build_directory {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self      = shift;
    my $directory = $self->_dir_attr;

    if ( not state $recursion_guard) {
        $recursion_guard = 1;
        $directory       = XML::Ant::Properties->apply($directory);
        undef $recursion_guard;
    }
    return dir($directory);
}

has _files => ( ro,
    lazy_build,
    isa => ArrayRef [File],
    traits   => ['Array'],
    init_arg => undef,
    handles  => {
        files        => 'elements',
        map_files    => 'map',
        filter_files => 'grep',
        find_file    => 'first',
        file         => 'get',
        num_files    => 'count',
        as_string    => [ join => q{ } ],
    },
);

sub _build__files
{    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    my @file_names;

    if ( defined $self->_file_names ) {
        push @file_names, @{ $self->_file_names };
    }
    if ( defined $self->_files_attr_names ) {
        push @file_names, split / [,\s]* /, $self->_files_attr_names;
    }

    if ( not state $recursion_guard) {
        $recursion_guard = 1;
        @file_names = map { XML::Ant::Properties->apply($ARG) } @file_names;
        undef $recursion_guard;
    }

    return [ map { $self->_prepend_dir($ARG) } @file_names ];
}

sub _prepend_dir {
    my ( $self, $file_name ) = @ARG;
    return $self->directory->subsumes( file($file_name) )
        ? file($file_name)
        : $self->directory->file($file_name);
}

has content =>
    ( ro, lazy, isa => ArrayRef [File], default => sub { $ARG[0]->_files } );

with 'XML::Ant::BuildFile::Resource';

{
## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)

    has _dir_attr => ( ro, required,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => './@dir',
    );

    has _file_names => ( ro,
        isa => ArrayRef [Str],
        traits      => ['XPathValueList'],
        xpath_query => './file/@name',
    );

    has _files_attr_names => ( ro,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => './@files',
    );
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Resource::FileList - file list node within an Ant build file

=head1 VERSION

version 0.214

=head1 SYNOPSIS

    use XML::Ant::BuildFile::Project;

    my $project = XML::Ant::BuildFile::Project->new( file => 'build.xml' );
    for my $list_ref (@{$project->file_lists}) {
        print 'id: ', $list_ref->id, "\n";
        print join "\n", @{$list_ref->files};
        print "\n\n";
    }

=head1 DESCRIPTION

See L<XML::Ant::BuildFile::Project|XML::Ant::BuildFile::Project> for a complete
description.

=head1 ATTRIBUTES

=head2 directory

L<Path::Class::Dir|Path::Class::Dir> indicated by the C<< <filelist> >>
element's C<dir> attribute with all property substitutions applied.

=head1 METHODS

=head2 files

Returns an array of L<Path::Class::File|Path::Class::File>s within
this file list with all property substitutions applied.

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
