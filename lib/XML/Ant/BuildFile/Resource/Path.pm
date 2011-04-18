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

package XML::Ant::BuildFile::Resource::Path;

BEGIN {
    $XML::Ant::BuildFile::Resource::Path::VERSION = '0.206';
}

# ABSTRACT: Path-like structure in an Ant build file

use Modern::Perl;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Str);
use MooseX::Types::Path::Class qw(Dir File);
use Path::Class;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use XML::Ant::Properties;
use namespace::autoclean;
extends 'XML::Ant::BuildFile::ResourceContainer';

has _paths => ( ro,
    lazy_build,
    isa => ArrayRef [ Dir | File ],
    traits  => ['Array'],
    handles => {
        all       => 'elements',
        as_string => [ join => $OSNAME =~ /\A MSWin/ ? q{;} : q{:} ],
    },
);

sub _build__paths {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    my @paths;

    if ( my $location = $self->_location ) {
        if ( not state $recursion_guard) {
            $recursion_guard = 1;
            $location        = XML::Ant::Properties->apply($location);
            undef $recursion_guard;
        }
        push @paths, file($location);
    }
    push @paths, map { $ARG->files } $self->resources('filelist');

    return \@paths;
}

with 'XML::Ant::BuildFile::Resource';

has _location => (
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    isa         => Str,
    traits      => ['XPathValue'],
    xpath_query => './@location',
);

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Resource::Path - Path-like structure in an Ant build file

=head1 VERSION

version 0.206

=head1 SYNOPSIS

    package My::Ant;
    use Moose;
    with 'XML::Rabbit::RootNode';

    has paths => (
        isa         => 'HashRef[XML::Ant::BuildFile::Resource::Path]',
        traits      => 'XPathObjectMap',
        xpath_query => '//classpath[@id]|//path[@id]',
        xpath_key   => './@id',
    );

=head1 DESCRIPTION

This is a L<Moose|Moose> type class meant for use with
L<XML::Rabbit|XML::Rabbit> when processing path-like structures in an Ant
build file.

=head1 METHODS

=head2 all

=head2 as_string

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
