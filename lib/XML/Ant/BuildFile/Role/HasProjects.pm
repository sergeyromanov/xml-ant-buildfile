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

package XML::Ant::BuildFile::Role::HasProjects;

BEGIN {
    $XML::Ant::BuildFile::Role::HasProjects::VERSION = '0.213';
}

# ABSTRACT: Compose a collection of Ant build file projects

use strict;
use Carp;
use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'HashRef';
use MooseX::Types::Path::Class 'Dir';
use Path::Class;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use TryCatch;
use XML::Ant::BuildFile::Project;
use namespace::autoclean;

has working_copy => ( rw, required, coerce,
    isa           => Dir,
    documentation => 'directory containing content',
);

has projects => ( rw,
    lazy_build,
    isa => HashRef ['XML::Ant::BuildFile::Project'],
    traits  => ['Hash'],
    handles => {
        project       => 'get',
        project_files => 'keys',
    },
);

sub _build_projects {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    my %projects;
    $self->working_copy->recurse(
        callback => _make_ant_finder_callback( \%projects ) );
    return \%projects;
}

sub _make_ant_finder_callback {
    my $projects_ref = shift;

    return sub {
        my $path = shift;

        # skip directories and non-XML files
        return if $path->is_dir or $path !~ / [.]xml \z/i;

        my @dir_list = $path->dir->dir_list;
        for ( 0 .. $#dir_list ) {    # skip symlinks
            return if -l file( @dir_list[ 0 .. $ARG ] )->stringify();
        }
        return if 'CVS' ~~ @dir_list or '.svn' ~~ @dir_list;   # skip SCM dirs

        # look for matching XML files but only carp if parse error
        my $error;
        try {
            ## no critic (ValuesAndExpressions::ProhibitAccessOfPrivateData)
            $projects_ref->{"$path"}
                = XML::Ant::BuildFile::Project->new( file => $path );
        }
        catch($error) { carp $error };
        return;
    };
}

1;

__END__

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Role::HasProjects - Compose a collection of Ant build file projects

=head1 VERSION

version 0.213

=head1 SYNOPSIS

    package My::Package;
    use Moose;
    with 'XML::Ant::BuildFile::Role::HasProjects';

    sub frobnicate_projects {
        my $self = shift;
        $self->working_copy('/dir/to/search');
        print "Found these projects:\n";
        print "$_\n" for @{$self->project_files};
    }

    1;

=head1 DESCRIPTION

This L<Moose::Role|Moose::Role> helps you compose a collection of Ant
project files found in a directory of source code.  The directory is searched
recursively for files ending in F<.xml>, skipping any symbolic links as well
as F<CVS> and Subversion F<.svn> directories.

=head1 ATTRIBUTES

=head2 working_copy

A L<Path::Class::Dir|Path::Class::Dir> to search for L</projects>.

=head2 projects

Reference to an array of
L<XML::Ant::BuildFile::Project|XML::Ant::BuildFile::Project>s in the
current C<working_copy> directory.

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
