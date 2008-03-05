#!perl -T

use Test::More tests => 1;

BEGIN {
  use_ok( 'Catalyst::View::Download::CSV' );
}

diag( "Testing Catalyst::View::Download::CSV $Catalyst::View::Download::CSV::VERSION, Perl $], $^X" );
