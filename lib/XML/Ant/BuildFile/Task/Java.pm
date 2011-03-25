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

package XML::Ant::BuildFile::Task::Java;

BEGIN {
    $XML::Ant::BuildFile::Task::Java::VERSION = '0.206';
}

# ABSTRACT: Java task node in an Ant build file

use Carp;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Str);
use MooseX::Types::Path::Class 'File';
use Path::Class;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use namespace::autoclean;
with 'XML::Ant::BuildFile::Task';

my %xpath_attr = (
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    classname  => './@classname',
    _jar       => './@jar',
    _args_attr => './@args',
);

while ( my ( $attr, $xpath ) = each %xpath_attr ) {
    has $attr => ( ro,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => $xpath,
    );
}

has jar => ( ro, lazy,
    isa => File,
    default =>
        sub { file( $ARG[0]->project->apply_properties( $ARG[0]->_jar ) ) },
);

has _args_ref => ( ro,
    isa => ArrayRef [Str],
    traits      => [qw(XPathValueList Array)],
    xpath_query => './arg',
    handles     => { _all_args => 'elements', _filter_args => 'map' },
);

has _args => ( ro,
    lazy_build,
    isa => ArrayRef [Str],
    traits  => ['Array'],
    handles => {
        args        => 'elements',
        arg         => 'get',
        arg_line    => [ join => q{ } ],
        map_args    => 'map',
        filter_args => 'grep',
        find_arg    => 'first',
        num_args    => 'count',
    },
);

sub _build_args { ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    my $self = shift;

    my @nested_args = $self->_filter_args(
        sub {
            given ( shift->node ) {
                when ( $ARG->hasAttribute('value') ) {
                    return $ARG->getAttribute('value');
                }
                when ( $ARG->hasAttribute('line') ) {
                    return split / \s /, $ARG->getAttribute('line');
                }
            }
        }
    );

    return [ split( / \s /, $self->_args_attr ), @nested_args ];
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Task::Java - Java task node in an Ant build file

=head1 VERSION

version 0.206

=head1 SYNOPSIS

    use XML::Ant::BuildFile::Project;
    my $project = XML::Ant::BuildFile::Project->new( file => 'build.xml' );
    my @foo_java = $project->target('foo')->tasks('java');
    for my $java (@foo_java) {
        print $java->classname || "$java->jar";
        print "\n";
    }

=head1 DESCRIPTION

This is an incomplete class for
L<Ant Java task|http://ant.apache.org/manual/Tasks/java.html>s in a
L<build file project|XML::Ant::BuildFile::Project>.

=head1 ATTRIBUTES

=head2 classname

A string representing the Java class that's executed.

=head2 jar

A L<Path::Class::File|Path::Class::File> for the jar file being executed.

=head1 METHODS

=head2 args

Returns a list of all arguments passed to the Java class.

=head2 arg

Given one or more index numbers, returns a list of those positional arguments.

=head2 arg_line

Returns a string of all the arguments joined together, separated by spaces.

=head2 map_args

Returns a list of arguments transformed by the given code reference.

=head2 filter_args

Returns a list of arguments for which the given code reference returns C<true>.

=head2 find_arg

Returns the first argument for which the given code reference returns C<true>.

=head2 num_args

Returns a count of all arguments.  Note that space-separated arguments such
as those produced by C<< <java args="..."/> >> and C<< <arg line="..."/> >>
will be split apart and count as separate arguments.

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
