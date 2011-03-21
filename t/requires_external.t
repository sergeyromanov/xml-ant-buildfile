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

use Test::Most;
plan tests => 1;
bail_on_fail if 0;
use Env::Path 'PATH';

ok( scalar PATH->Whence($_), "$_ in PATH" ) for qw(ant);
