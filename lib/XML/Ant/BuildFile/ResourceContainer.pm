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

package XML::Ant::BuildFile::ResourceContainer;

BEGIN {
    $XML::Ant::BuildFile::ResourceContainer::VERSION = '0.206';
}

# ABSTRACT: Container for XML::Ant::BuildFile::Resource plugins

use English '-no_match_vars';
use Moose;
use Module::Pluggable (
    sub_name    => 'resource_plugins',
    search_path => 'XML::Ant::BuildFile::Resource',
    require     => 1,
);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)

sub BUILD {
    my $self = shift;

    ## no critic (ValuesAndExpressions::ProhibitMagicNumbers)
    my %isa_map = map { lc( ( split /::/ => $ARG )[-1] ) => $ARG }
        $self->resource_plugins;
    $self->meta->add_attribute(
        _resources => (
            traits      => [qw(XPathObjectList Array)],
            xpath_query => join( q{|} => map {".//$ARG"} keys %isa_map ),
            isa_map     => \%isa_map,
            handles     => {
                all_resources    => 'elements',
                resource         => 'get',
                filter_resources => 'grep',
                num_resources    => 'count',
            },
        )
    );
    return;
}

sub resources {
    my ( $self, @names ) = @ARG;
    return $self->filter_resources( sub { $ARG->resource_name ~~ @names } );
}

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::ResourceContainer - Container for XML::Ant::BuildFile::Resource plugins

=head1 VERSION

version 0.206

=head1 SYNOPSIS

    package XML::Ant::BuildFile::Resource::Foo;
    use Moose;
    extends 'XML::Ant::BuildFile::ResourceContainer';

=head1 DESCRIPTION

Base class for containers of multiple
L<XML::Ant::BuildFile::Resource|XML::Ant::BuildFile::Resource> plugins.

=head1 METHODS

=head2 BUILD

Automatically run after object construction to set up task object support.

=head2 resources

Given one or more resource type names, returns a list of objects.

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
