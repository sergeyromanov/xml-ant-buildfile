#!perl
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

use Test::Most tests => 4;
use English '-no_match_vars';
use Path::Class;
use XML::Ant::BuildFile::Project;

my $project = XML::Ant::BuildFile::Project->new( file => 't/yui-build.xml' );
my $copy = ( $project->target('move-files')->tasks('copy') )[0];
isa_ok( $copy, 'XML::Ant::BuildFile::Task::Copy', 'copy task' );

is( $copy->to_dir->stringify(),
    XML::Ant::Properties->get('basedir'),
    'copy to_dir',
);

my $filelist = ( $copy->resources('filelist') )[0];
isa_ok(
    $filelist,
    'XML::Ant::BuildFile::Resource::FileList',
    'file list to copy',
);
cmp_bag(
    [ $filelist->map_files( sub {"$ARG"} ) ],
    [ map { target_mincat($ARG) } qw(css/min/site.css js/min/site.js) ],
    'names in file list',
);

sub target_mincat {
    return Path::Class::File->new_foreign( 'Unix', 't/target/yui/mincat',
        @ARG )->stringify();
}
