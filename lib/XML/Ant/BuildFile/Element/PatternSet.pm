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

package XML::Ant::BuildFile::Element::PatternSet;

BEGIN {
    $XML::Ant::BuildFile::Element::PatternSet::VERSION = '0.206';
}

# ABSTRACT: Set of patterns in an Ant build file

use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Maybe Str);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use namespace::autoclean;
with 'XML::Ant::BuildFile::Role::InProject';

{
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    my %str_attr = (
        id             => './@id',
        _includes_attr => './@includes',
    );

    while ( my ( $attr, $xpath ) = each %str_attr ) {
        has $attr => ( ro,
            isa         => Str,
            traits      => ['XPathValue'],
            xpath_query => $xpath,
        );
    }

    has _includes_nested => ( ro,
        isa => ArrayRef [Str],
        traits      => ['XPathValueList'],
        xpath_query => './include/@name',
    );
}

has _includes => ( ro, lazy_build,
    isa => ArrayRef [ Maybe [Str] ],
    traits  => ['Array'],
    handles => { includes => 'elements' },
);

sub _build_includes
{    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    my @includes;
    if ( defined $self->_includes_attr ) {
        push @includes, split / [\s,] /,
            $self->project->apply_properties( $self->_includes_attr );
    }
    if ( defined $self->_includes_nested ) {
        push @includes,
            map { $self->project->apply_properties($ARG) }
            @{ $self->_includes_nested };
    }
    return \@includes;
}

__PACKAGE__->meta->make_immutable();
1;

__END__

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Element::PatternSet - Set of patterns in an Ant build file

=head1 VERSION

version 0.206

=head1 ATTRIBUTES

=head2 id

C<< <id/ >> attribute of the C<< <patternset/> >>

=head1 METHODS

=head2 includes

Returns a list of include patterns from the PatternSet's C<includes> attribute
and any nested C<< <include/> >> elements.

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
