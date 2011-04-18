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
    $XML::Ant::Properties::VERSION = '0.207';
}

# ABSTRACT: Singleton class for Ant properties

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

around set => sub {
    my ( $orig, $self ) = splice @ARG, 0, 2;
    my %element  = @ARG;
    my %property = %{ $self->_properties };
    while ( my ( $key, $value ) = each %element ) {
        $property{$key} = $self->apply($value);
    }
    $self->_properties( \%property );
    return $self->$orig(%element);
};

sub apply {
    my $self     = shift;
    my $source   = shift or return;
    my %property = %{ $self->_properties };
    while ( $source =~ / \$ { [\w:.]+ } / ) {
        my $old_source = $source;
        while ( my ( $property, $value ) = each %property ) {
            $source =~ s/ \$ {$property} /$value/g;
        }
        last if $old_source eq $source;
    }
    return $source;
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::Properties - Singleton class for Ant properties

=head1 VERSION

version 0.207

=head1 SYNOPSIS

    use XML::Ant::Properties;
    XML::Ant::Properties->set(foo => 'fooprop', bar => 'barprop');
    my $fooprop = XML::Ant::Properties->apply('${foo}');

=head1 DESCRIPTION

This is a singleton class for storing and applying properties while processing
an Ant build file.  When properties are set their values are also subject to
repeated Ant-style C<${name}> expansion.  You can also perform expansion with
the L<apply|/apply> method.

=head1 METHODS

=head2 count

=head2 get

=head2 set

=head2 delete

=head2 exists

=head2 defined

=head2 keys

=head2 values

=head2 clear

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

__END__
