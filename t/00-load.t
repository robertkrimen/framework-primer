#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Framework::Primer' );
}

diag( "Testing Framework::Primer $Framework::Primer::VERSION, Perl $], $^X" );
