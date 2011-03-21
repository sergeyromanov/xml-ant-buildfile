#!perl
#
# This file is part of XML-Ant-BuildFile
#
# This software is copyright (c) 2011 by GSI Commerce.  No
# license is granted to other entities.
#
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

use Test::Most;
plan tests => 1;
bail_on_fail if 0;
use Env::Path 'PATH';

ok( scalar PATH->Whence($_), "$_ in PATH" ) for qw(ant);
