use strict;
use Test::More;

plan qw/no_plan/;

package Xyzzy;

use Moose;
use Framework::Primer;

extends qw/Framework::Primer::Base/; 

name qw/xyzzy/;

1;

package main;

my $xyzzy = Xyzzy->new;
ok($xyzzy);

is($xyzzy->name, "xyzzy");
is($xyzzy->var_dir, "var");

1;
