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

package XML::Ant::BuildFile::Resource::FileSet;

BEGIN {
    $XML::Ant::BuildFile::Resource::FileSet::VERSION = '0.206';
}

use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Path::Class qw(Dir File);
use Path::Class;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use namespace::autoclean;
extends 'XML::Ant::BuildFile::Element::PatternSet';

has _dir => ( ro,
    isa         => Str,
    traits      => ['XPathValue'],
    xpath_query => './@dir',
);

has dir => ( ro, lazy,
    isa => Dir,
    default =>
        sub { dir( $ARG[0]->project->apply_properties( $ARG[0]->_dir ) ) },
);

has _files => ( ro, lazy_build,
    isa => ArrayRef [File],
    traits  => ['Array'],
    handles => { files => 'elements' },
);

sub _build__files {
    my $self = shift;
    my @patterns;
    for my $pattern ( $self->includes ) {

        # translate Ant globs into regular expressions
        $pattern =~ s/ \* /.*/;
        $pattern =~ s/ \? /./;
        $pattern =~ s{ [/\] \z}{**\z};
        $pattern =~ s{ ** }{(?:(?:[^/]+)/)+};
        push @patterns, qr/$pattern/;
    }

    my @files;
    $self->dir->recurse(
        callback => sub {
            my $path = shift;
            next if $path->is_dir;
            if ( !@patterns ) { push @files, $path; return }
            for my $pattern (@patterns) {
                if ( $path->stringify() =~ $pattern ) {
                    push @files, $path;
                    return;
                }
            }
            return;
        }
    );
    return \@files;
}

__PACKAGE__->meta->make_immutable();
1;

__END__

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Resource::FileSet

=head1 VERSION

version 0.206

=head1 ATTRIBUTES

=head2 dir

A L<Path::Class::Dir|Path::Class::Dir> for the root of the directory tree of
this FileSet.

=head1 METHODS

=head2 includes

Returns a list of include patterns from the FileSet's C<includes> attribute
and any nested C<< <include/> >> elements.  Inherited from
L<XML::Ant::BuildFile::Element::PatternSet|XML::Ant::BuildFile::Element::PatternSet>.

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
