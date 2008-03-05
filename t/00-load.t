#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Catalyst::View::Download' );
}

diag( "Testing Catalyst::View::Download $Catalyst::View::Download::VERSION, Perl $], $^X" );
