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

package XML::Ant::BuildFile::Project;

BEGIN {
    $XML::Ant::BuildFile::Project::VERSION = '0.204';
}

# ABSTRACT: consume Ant build files

use English '-no_match_vars';
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Has::Sugar::Minimal;
use MooseX::Types::Moose qw(ArrayRef HashRef Str);
use MooseX::Types::Path::Class 'File';
use Path::Class;
use Readonly;
use namespace::autoclean;
with 'XML::Rabbit::RootNode';

subtype 'FileStr', as Str;
coerce 'FileStr', from File, via {"$ARG"};
has '+_file' => ( isa => 'FileStr', coerce => 1 );

{
## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)

    has name => (
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => '/project/@name',
    );

    has _properties => (
        lazy        => 1,
        isa         => HashRef [Str],
        traits      => ['XPathValueMap'],
        xpath_query => '//property[@name and @value]',
        xpath_key   => './@name',
        xpath_value => './@value',
        default     => sub { {} },
    );

    has filelists => (
        isa         => 'ArrayRef[XML::Ant::BuildFile::Project::FileList]',
        traits      => ['XPathObjectList'],
        xpath_query => '//filelist[@id]',
    );

    has targets => (
        isa         => 'HashRef[XML::Ant::BuildFile::Project::Target]',
        traits      => [qw(XPathObjectMap Hash)],
        xpath_query => '/project/target[@name]',
        xpath_key   => './@name',
        handles     => {
            target_names => 'keys',
            get_target   => 'get',
            has_target   => 'exists',
            num_targets  => 'count',
        },
    );
}

has properties => ( is => ro, isa => HashRef [Str], default => sub { {} } );

around properties => sub {
    my ( $orig, $self ) = @ARG;
    return {
        'os.name'          => $OSNAME,
        'basedir'          => file( $self->_file )->dir->stringify(),
        'ant.file'         => $self->_file,
        'ant.project.name' => $self->name,
        %{ $self->_properties },
        %{ $self->$orig() },
    };
};

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Project - consume Ant build files

=head1 VERSION

version 0.204

=head1 SYNOPSIS

    use XML::Ant::BuildFile::Project;

    my $project = XML::Ant::BuildFile::Project->new( file => 'build.xml' );
    print 'Project name: ', $project->name, "\n";
    print "File lists:\n";
    for my $list_ref (@{$project->file_lists}) {
        print 'id: ', $list_ref->id, "\n";
        print join "\n", @{$list_ref->files};
        print "\n\n";
    }

=head1 DESCRIPTION

This class uses L<XML::Rabbit|XML::Rabbit> to consume Ant build files using
a L<Moose|Moose> object-oriented interface.

=head1 ATTRIBUTES

=head2 file

On top of L<XML::Rabbit|XML::Rabbit>'s normal behavior, this class will also
coerce L<Path::Class::File|Path::Class::File> objects to the strings expected
by L<XML::Rabbit::Role::Document|XML::Rabbit::Role::Document>.

=head2 name

Name of the Ant project.

=head2 filelists

Array reference of
L<XML::Ant::BuildFile::Project::FileList|XML::Ant::BuildFile::Project::FileList>s.

=head2 targets

Hash reference of
L<XML::Ant::BuildFile::Project::Target|XML::Ant::BuildFile::Project::Target>s
from the build file.

=head2 properties

Read-only hash reference to properties set by the build file.  This also
contains the following predefined properties as per the Ant documentation:

=over

=item os.name

=item basedir

=item ant.file

=item ant.project.name

=back

=head1 METHODS

=head2 target_names

Returns a list of the target names from the build file.

=head2 get_target

Given a target name, return the corresponding
L<XML::Ant::BuildFile::Project::Target|XML::Ant::BuildFile::Project::Target>
object.

=head2 has_target

Given a target name, returns true or false if the target exists.

=head2 num_targets

Returns a count of the number of targets in the build file.

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
