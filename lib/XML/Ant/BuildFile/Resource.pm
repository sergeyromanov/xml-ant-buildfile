package XML::Ant::BuildFile::Resource;

# ABSTRACT: Role for Ant build file resources

use strict;
use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(Maybe Str);
use namespace::autoclean;
with 'XML::Ant::BuildFile::Role::InProject';

=attr resource_name

Name of the task's XML node.

=cut

has resource_name => ( ro, lazy,
    isa      => Str,
    init_arg => undef,
    default  => sub { $ARG[0]->node->nodeName },
);

=attr id

C<id> attribute of this resource.

=attr as_string

Every role consumer must implement the C<as_string> method.

=attr content

L<XML::Ant::BuildFile::Resource|XML::Ant::BuildFile::Resource> provides a
default C<content> attribute, but it only returns C<undef>.  Consumers should
use the C<around> method modifier to return something else in order to
support resources with C<refid> attributes

=cut

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

=method BUILD

After a resource is constructed, it adds its L<id|/id> and
L<string representation|/as_string> to the
L<XML::Ant::Properties|XML::Ant::Properties> singleton with C<toString:>
prepended to the C<id>.

=cut

sub BUILD {
    my $self = shift;
    if ( $self->id ) {
        XML::Ant::Properties->set(
            'toString:' . $self->id => $self->as_string );
    }
    return;
}

1;

__END__

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
