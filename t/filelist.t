#!perl
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

use Test::More tests => 7;
use English '-no_match_vars';
use Readonly;
use Path::Class;
use XML::Ant::BuildFile::Project;

our $CLASS;

BEGIN {
    Readonly our $CLASS => 'XML::Ant::BuildFile::Project';
    eval "require $CLASS; $CLASS->import()";
}
Readonly my $TESTFILE => file('t/filelist.xml');

my $project
    = new_ok( $CLASS => [ file => $TESTFILE ], 'from Path::Class::File' );
$project = new_ok(
    $CLASS => [ file => $TESTFILE->stringify() ],
    'from path string',
);

is( $project->name, 'test', 'project name' );
cmp_ok( $project->targets, '~~', [qw(simple double nested)], 'target names' );

my @filelists = @{ $project->filelists };
is( scalar @filelists, 3, 'filelists' );

cmp_ok(
    [ map { $ARG->id } @filelists ],
    '~~', [ ('filelist') x 3 ],
    'filelist ids',
);

cmp_ok(
    [ map { $ARG->directory->stringify() } @filelists ],
    '~~',
    [ (q{.}) x 3 ],
    'filelist dirs',
);
