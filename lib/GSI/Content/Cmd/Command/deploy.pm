## no critic (NamingConventions::Capitalization)
package GSI::Content::Cmd::Command::deploy;

# ABSTRACT: deploy and post-process content from SVN

use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw(ArrayRef HashRef);
use MooseX::Types::Path::Class 'File';
use MooseX::Types::URI 'Uri';
use Readonly;
use Regexp::DefaultFlags;
## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
use SVN::Simple::Client;
use SVN::Simple::Client::Types 'SvnUri';
use TryCatch;
use XML::Twig;
use GSI::Content::Cmd::Command::minify;
use namespace::autoclean;
extends 'MooseX::App::Cmd::Command';
with 'MooseX::SimpleConfig';
with 'MooseX::Getopt';
with 'SVN::Simple::Client::AsRole';

has '+configfile' => ( default => 'conf/config.ini' );

for (qw(MooseX::Types::URI::Uri SVN::Simple::Client::Types::SvnUri)) {
    MooseX::Getopt::OptionTypeMap->add_option_type_to_map( $ARG => '=s' );
}

=method execute

Runs the subcommand.

=cut

sub execute {
    my ( $self, $opt, $args ) = @ARG;
    $self->update_or_checkout();

    my $minifier = GSI::Content::Cmd::Command::minify->new_with_config(
        configfile   => $self->configfile(),
        working_copy => $self->working_copy(),
    );
    $minifier->execute( $opt, $args );

    return;
}

__PACKAGE__->meta->make_immutable();

1;

__END__

=head1 DESCRIPTION

=head1 SYNOPSIS

=for test_synopsis 1;

=for test_synopsis __END__

    perl -MGSI::Content::Cmd -e 'GSI::Content::Cmd->run()' deploy \
        --working_copy /path/to/dir
        --url http://sample.com/svn/repo/trunk
