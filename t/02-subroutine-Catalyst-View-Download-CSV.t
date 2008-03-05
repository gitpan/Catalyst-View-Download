use Test::More tests => 1;

use FindBin;
use lib $FindBin::Bin."/Testing";
use Catalyst::Test 'TestApp';

sub render_ok {
  return get('/csv_test');
}

BEGIN: {
  my $compare = "a,b,c,d\n"
               ."1,2,3,4\n"
               ."\" \",\"\n\",\"\t\",!\n"
               ."\@,\",\",\"\"\"\",'\n";

  is(render_ok(),$compare,'Compare CSV output'); 
}

diag( "Testing subroutine, render, for Catalyst::View::Download::CSV" );
