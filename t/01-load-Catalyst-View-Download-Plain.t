#!perl -T

use Test::More tests => 1;

BEGIN {
  use_ok( 'Catalyst::View::Download::Plain' );
}

diag( "Testing Catalyst::View::Download::Plain $Catalyst::View::Download::Plain::VERSION, Perl $], $^X" );
