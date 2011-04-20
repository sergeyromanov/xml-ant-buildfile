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

package XML::Ant::Properties;

BEGIN {
    $XML::Ant::Properties::VERSION = '0.214';
}

# ABSTRACT: Singleton class for Ant properties

use strict;
use English '-no_match_vars';
use MooseX::Singleton 0.26;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(HashRef Maybe Str);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use namespace::autoclean;

has _properties => ( rw,
    isa => HashRef [ Maybe [Str] ],
    init_arg => undef,
    traits   => ['Hash'],
    default  => sub { {} },
    handles  => {
        map { $ARG => $ARG }
            qw(count get set delete exists defined keys values clear kv),
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
    my $self = shift;
    my $source = shift or return;

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

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

XML::Ant::Properties - Singleton class for Ant properties

=head1 VERSION

version 0.214

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

=head2 kv

=head2 apply

Takes a string and applies property substitution to it.

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

__END__
