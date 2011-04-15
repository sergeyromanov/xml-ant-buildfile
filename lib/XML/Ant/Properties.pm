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

package XML::Ant::Properties;

BEGIN {
    $XML::Ant::Properties::VERSION = '0.206';
}

use strict;
use English '-no_match_vars';
use MooseX::Singleton;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(HashRef Str);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use namespace::autoclean;

has _properties => ( rw,
    isa => HashRef [Str],
    init_arg => undef,
    traits   => ['Hash'],
    default  => sub { {} },
    handles  => {
        map { $ARG => $ARG }
            qw(count get set delete exists defined keys values clear),
    },
);

sub apply {
    my ( $self, $source ) = @ARG;
    my %properties = %{ $self->_properties };
    while ( $source =~ / \$ { [\w:.]+ } / ) {
        while ( my ( $property, $value ) = each %properties ) {
            $source =~ s/ \$ {$property} /$value/g;
        }
    }
    return $source;
}

__PACKAGE__->meta->make_immutable();
1;

__END__

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::Properties

=head1 VERSION

version 0.206

=head1 METHODS

=head2 apply

Takes a string and applies property substitution to it.

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
