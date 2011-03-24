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

package XML::Ant::BuildFile::Project::FileList;

BEGIN {
    $XML::Ant::BuildFile::Project::FileList::VERSION = '0.205';
}

# ABSTRACT: file list node within an Ant build file

use English '-no_match_vars';
use Path::Class;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef HashRef Str);
use MooseX::Types::Path::Class qw(Dir File);
use namespace::autoclean;
with 'XML::Rabbit::Node' => { -version => '0.0.4' };

has project => (
    isa         => 'XML::Ant::BuildFile::Project',
    traits      => ['XPathObject'],
    xpath_query => q{/},
    handles     => ['properties'],
);

{
## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)

    my %xpath_attr = ( _dir_attr => './@dir', id => './@id' );
    while ( my ( $attr, $xpath ) = each %xpath_attr ) {
        has $attr => ( ro, required,
            isa         => Str,
            traits      => ['XPathValue'],
            xpath_query => $xpath,
        );
    }

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

has directory => ( ro, required, lazy,
    isa      => Dir,
    init_arg => undef,
    default  => sub { dir( $ARG[0]->_property_subst( $ARG[0]->_dir_attr ) ) },
);

has files => ( ro, lazy_build, isa => ArrayRef [File], init_arg => undef );

sub _build_files
{    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    my @file_names;

    if ( defined $self->_file_names ) {
        push @file_names, @{ $self->_file_names };
    }
    if ( defined $self->_files_attr_names ) {
        push @file_names, split / [,\s]* /, $self->_files_attr_names;
    }

    return [ map { $self->directory->file( $self->_property_subst($ARG) ) }
            @file_names ];
}

sub _property_subst {
    my ( $self, $source ) = @ARG;
    my %properties = %{ $self->properties };
    while ( my ( $property, $value ) = each %properties ) {
        $source =~ s/ \$ {$property} /$value/g;
    }
    return $source;
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Project::FileList - file list node within an Ant build file

=head1 VERSION

version 0.205

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

=head2 project

Reference to the L<XML::Ant::BuildFile::Project|XML::Ant::BuildFile::Project>
at the root of the build file containing this file list.

=head2 id

C<id> attribute of this file list.

=head2 directory

L<Path::Class::Dir|Path::Class::Dir> indicated by the C<< <filelist> >>
element's C<dir> attribute with all property substitutions applied.

=head2 files

Reference to an array of L<Path::Class::File|Path::Class::File>s within
this file list with all property substitutions applied.

=head1 METHODS

=head2 properties

Properties hash reference for the build file.

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
