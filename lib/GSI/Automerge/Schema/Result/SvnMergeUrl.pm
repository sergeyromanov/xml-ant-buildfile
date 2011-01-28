package GSI::Automerge::Schema::Result::SvnMergeUrl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

GSI::Automerge::Schema::Result::SvnMergeUrl

=cut

__PACKAGE__->table("svn_merge_urls");

=head1 ACCESSORS

=head2 id

  is_auto_increment: 1
  is_nullable: 0
  sequence: 'svn_url_seq'

=head2 to_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 from_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "id",
  { is_auto_increment => 1, is_nullable => 0, sequence => "svn_url_seq" },
  "to_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "from_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-09-23 09:58:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YSDrMQksuIfXiIQObTJl/w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
