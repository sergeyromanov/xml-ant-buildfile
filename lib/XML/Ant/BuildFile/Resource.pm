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

package XML::Ant::BuildFile::Resource;

BEGIN {
    $XML::Ant::BuildFile::Resource::VERSION = '0.210';
}

# ABSTRACT: Role for Ant build file resources

use strict;
use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(Maybe Str);
use namespace::autoclean;
with 'XML::Ant::BuildFile::Role::InProject';

has resource_name => ( ro, lazy,
    isa      => Str,
    init_arg => undef,
    default  => sub { $ARG[0]->node->nodeName },
);

requires qw(as_string content);

around as_string => sub {
    my ( $orig, $self ) = splice @ARG, 0, 2;
    return $self->$orig(@ARG) if !$self->_refid;

    my $antecedent = $self->project->find_resource(
        sub {
            $ARG->resource_name eq $self->resource_name
                and $ARG->id eq $self->_refid;
        }
    );
    return $antecedent->as_string;
};

{
## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    has id =>
        ( ro, isa => Str, traits => ['XPathValue'], xpath_query => './@id' );
    has _refid => ( ro,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => './@refid',
    );
}

has content => ( ro, lazy_build, isa => Maybe );

around content => sub {
    my ( $orig, $self ) = splice @ARG, 0, 2;
    return $self->$orig(@ARG) if !$self->_refid;

    my $antecedent = $self->project->find_resource(
        sub {
            $ARG->resource_name eq $self->resource_name
                and $ARG->id eq $self->_refid;
        }
    );
    return $antecedent->content;
};

sub BUILD {
    my $self = shift;
    if ( $self->id ) {
        XML::Ant::Properties->set(
            'toString:' . $self->id => $self->as_string );
    }
    return;
}

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Resource - Role for Ant build file resources

=head1 VERSION

version 0.210

=head1 SYNOPSIS

    package XML::Ant::BuildFile::Resource::Foo;
    use Moose;
    with 'XML::Ant::BuildFile::Resource';

    after BUILD => sub {
        my $self = shift;
        print "I'm a ", $self->resource_name, "\n";
    };

    1;

=head1 DESCRIPTION

This is a role shared by resources in an
L<XML::Ant::BuildFile::Project|XML::Ant::BuildFile::Project>.

=head1 ATTRIBUTES

=head2 resource_name

Name of the task's XML node.

=head2 id

C<id> attribute of this resource.

=head2 as_string

Every role consumer must implement the C<as_string> method.

=head2 content

L<XML::Ant::BuildFile::Resource|XML::Ant::BuildFile::Resource> provides a
default C<content> attribute, but it only returns C<undef>.  Consumers should
use the C<around> method modifier to return something else in order to
support resources with C<refid> attributes

=head1 METHODS

=head2 BUILD

After a resource is constructed, it adds its L<id|/id> and
L<string representation|/as_string> to the
L<XML::Ant::Properties|XML::Ant::Properties> singleton with C<toString:>
prepended to the C<id>.

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
