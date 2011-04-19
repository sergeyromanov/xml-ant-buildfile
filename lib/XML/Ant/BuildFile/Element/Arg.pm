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

package XML::Ant::BuildFile::Element::Arg;

BEGIN {
    $XML::Ant::BuildFile::Element::Arg::VERSION = '0.211';
}

# ABSTRACT: Argument element for a task in an Ant build file

use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Maybe Str);
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use XML::Ant::Properties;
use namespace::autoclean;
with 'XML::Rabbit::Node';

for my $attr (qw(value file path pathref line prefix suffix)) {
    has "_$attr" => ( ro,
        isa         => Str,
        traits      => ['XPathValue'],
        xpath_query => "./\@$attr",
    );
}

has _args => ( ro, lazy_build,
    isa => ArrayRef [ Maybe [Str] ],
    traits  => ['Array'],
    handles => { args => 'elements' },
);

sub _build__args
{    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    return [ $self->_value ] if $self->_value;
    return [ split / \s /, $self->_line ] if $self->_line;
    {
        ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
        return [
            XML::Ant::Properties->apply(
                '${toString:' . $self->_pathref . '}'
            )
            ]
            if $self->_pathref;
    }
    return [];
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Element::Arg - Argument element for a task in an Ant build file

=head1 VERSION

version 0.211

=head1 SYNOPSIS

    package My::Ant::Task;
    use Moose;
    with 'XML::Ant::BuildFile::Task';

    has arg_objects => (
        isa         => 'ArrayRef[XML::Ant::BuildFile::Element::Arg]',
        traits      => ['XPathObjectList'],
        xpath_query => './arg',
    );

    sub all_args {
        my $self = shift;
        return map {$_->args} @{ $self->arg_objects };
    }

=head1 DESCRIPTION

This is an incomplete class to represent C<< <arg/> >> elements in a
L<build file project|XML::Ant::BuildFile::Project>.

=head1 METHODS

=head2 args

Returns a list of arguments contained in the element.  Currently
handles C<< <arg/> >> elements with the following attributes:

=over

=item value

=item line

=item pathref

=back

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
