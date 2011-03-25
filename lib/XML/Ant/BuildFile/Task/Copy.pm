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

package XML::Ant::BuildFile::Task::Copy;

BEGIN {
    $XML::Ant::BuildFile::Task::Copy::VERSION = '0.206';
}

# ABSTRACT: copy task node in an Ant build file

use Carp;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef Str);
use MooseX::Types::Path::Class 'File';
use Path::Class;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use namespace::autoclean;
with 'XML::Ant::BuildFile::Task';

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

XML::Ant::BuildFile::Task::Copy - copy task node in an Ant build file

=head1 VERSION

version 0.206

=head1 SYNOPSIS

    use XML::Ant::BuildFile::Project;
    my $project = XML::Ant::BuildFile::Project->new( file => 'build.xml' );
    my @foo_java = $project->target('foo')->tasks('java');
    for my $java (@foo_java) {
        print $java->classname || "$java->jar";
        print "\n";
    }

=head1 DESCRIPTION

This is an incomplete class for
L<Ant Java task|http://ant.apache.org/manual/Tasks/java.html>s in a
L<build file project|XML::Ant::BuildFile::Project>.

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
