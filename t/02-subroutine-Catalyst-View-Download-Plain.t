use Test::More tests => 1;

use FindBin;
use lib $FindBin::Bin."/Testing";
use Catalyst::Test 'TestApp';

sub render_ok {
  return get('/plain_test');
}

BEGIN: {
  my $compare = <<"TEXT";
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vestibulum tempus augue interdum neque. Curabitur ac libero. Aliquam faucibus mi a lectus. Sed et elit. Etiam volutpat suscipit quam. Phasellus sit amet odio. Sed faucibus magna quis diam. Nulla facilisi. Vivamus id erat porttitor elit aliquam ornare. Integer tincidunt varius lacus. Pellentesque sit amet mauris id ligula faucibus semper. Maecenas eros. Curabitur hendrerit ligula ac nulla. Mauris dolor eros, pellentesque vel, varius porttitor, convallis non, lectus.

Curabitur lacinia laoreet felis. Vivamus a urna. Aenean adipiscing aliquam velit. Aliquam varius bibendum nulla. Praesent quis tortor nec nisi scelerisque facilisis. Cras tristique. Phasellus mi libero, vulputate ac, hendrerit ac, iaculis at, elit. Pellentesque ac ante sit amet orci viverra condimentum. Fusce aliquam semper justo. Integer tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nullam id lectus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur ut felis non mauris auctor viverra. Fusce dignissim. Morbi quis magna.

Proin scelerisque, lacus blandit consequat sodales, augue ligula laoreet quam, condimentum pretium velit diam eget lorem. Suspendisse potenti. Nam rhoncus mi vitae tortor. Sed eget neque. Fusce sagittis. Nulla rutrum nibh et justo. Suspendisse dolor libero, rhoncus a, pretium id, feugiat eget, velit. Aenean accumsan. Nunc vel nulla. Mauris semper consectetuer velit. Vivamus semper. Nulla fermentum sapien nec felis. Aenean iaculis felis nec ipsum. Aliquam tristique. Nam ut quam. Suspendisse ornare tristique arcu. Morbi pellentesque dolor eget lorem. Morbi ac nunc euismod lorem porttitor hendrerit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
TEXT

  is(render_ok(),$compare,'Compare Plaint output'); 
}

diag( "Testing subroutine, render, for Catalyst::View::Download::Plain" );
