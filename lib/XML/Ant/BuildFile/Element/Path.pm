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

package XML::Ant::BuildFile::Element::Path;

BEGIN {
    $XML::Ant::BuildFile::Element::Path::VERSION = '0.206';
}

# ABSTRACT: Path-like structure in an Ant build file

use English '-no_match_vars';
use Moose;
use MooseX::Types::Moose 'ArrayRef';
use namespace::autoclean;
extends 'XML::Ant::BuildFile::ResourceContainer';
with 'XML::Rabbit::Node';

has _elements => (
    isa         => ArrayRef,
    traits      => ['XPathValueList'],
    xpath_query => join(
        q{|} => map { ( "./\@$ARG", "./pathelement/\@$ARG" ) }
            qw(path location),
    ),
);

has _collections => (
    isa    => 'ArrayRef[XML::Ant::BuildFile::Resource]',
    traits => ['XPathObjectList'],
    xpath_query =>
        join( q{|} => map {"./$ARG"} qw(filelist path fileset dirset) ),
);

1;

__END__

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Element::Path - Path-like structure in an Ant build file

=head1 VERSION

version 0.206

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
