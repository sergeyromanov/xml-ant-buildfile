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

use Test::Most tests => 2;
use English '-no_match_vars';
use Readonly;
use Path::Class;
use XML::Ant::BuildFile::Project;

my $project = XML::Ant::BuildFile::Project->new( file => 't/yui-build.xml' );

my %paths = $project->paths;

cmp_bag(
    [ keys %paths ],
    [qw(site.css.concat site.css.min site.js.concat site.js.min)],
    'path ids',
);

cmp_deeply(
    [   map {
            [ $ARG->[0] => [ map {"$ARG"} $ARG->[1]->all ] ]
            } $project->path_pairs,
    ],
    bag([ 'site.css.concat' => ['target/yui/concat/site.css'] ],
        [ 'site.js.concat'  => ['target/yui/concat/site.js'] ],
        [ 'site.css.min'    => ['target/yui/mincat/css/min/site.css'] ],
        [ 'site.js.min'     => ['target/yui/mincat/js/min/site.js'] ],
    ),
    'path location pairs',
);
