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

package XML::Ant::BuildFile::Task::Copy;

BEGIN {
    $XML::Ant::BuildFile::Task::Copy::VERSION = '0.211';
}

# ABSTRACT: copy task node in an Ant build file

use English '-no_match_vars';
use Moose;
use MooseX::Types::Moose 'Str';
use MooseX::Has::Sugar;
use MooseX::Types::Path::Class 'File';
use Path::Class;
use XML::Ant::Properties;
use namespace::autoclean;
extends 'XML::Ant::BuildFile::ResourceContainer';
with 'XML::Ant::BuildFile::Task';

for my $attr (qw(dir file)) {
    has "_to_$attr" => ( ro,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => "./\@to$attr",
    );

    has "to_$attr" => ( ro, lazy,
        isa     => "Path::Class::\u$attr",
        default => sub {
            my $method  = "_to_$attr";
            my $applied = XML::Ant::Properties->apply( $ARG[0]->$method );
            ## no critic (ProhibitStringyEval, RequireCheckingReturnValueOfEval)
            return eval "Path::Class::$attr('$applied')";
        },
    );
}

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Task::Copy - copy task node in an Ant build file

=head1 VERSION

version 0.211

=head1 SYNOPSIS

    package My::Ant;
    use Moose;
    with 'XML::Rabbit::Node';

    has paths => (
        isa         => 'ArrayRef[XML::Ant::BuildFile::Task::Copy]',
        traits      => 'XPathObjectList',
        xpath_query => './/copy',
    );

=head1 DESCRIPTION

This is a L<Moose|Moose> type class meant for use with
L<XML::Rabbit|XML::Rabbit> when processing C<< <copy/> >> tasks in an Ant
build file.

=head1 ATTRIBUTES

=head2 to_file

The file to copy to as a L<Path::Class::File|Path::Class::File> object.

=head2 to_dir

The directory to copy a set of
L<XML::Ant::BuildFile::Resource|XML::Ant::BuildFile::Resource>s to as a
L<Path::Class::Dir|Path::Class::Dir> object.

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
