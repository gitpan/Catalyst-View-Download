package TestApp;

use Catalyst qw[-Engine=Test];

use FindBin;
use lib "$FindBin::Bin";
use TestApp::View::Download;
use TestApp::View::Download::CSV;
use TestApp::View::Download::Plain;

sub csv_test : Global {
  my ($self, $c) = @_;

  my $data = $self->_generate_csv_test_data();

  $c->stash->{'csv'} = $data->{'array'};

  my $view = new TestApp::View::Download::CSV;

  $c->res->body(''.$view->render($c,'',$c->stash));
}

sub plain_test : Global {
  my ($self, $c) = @_;

  my $data = $self->_generate_plain_test_data();

  $c->stash->{'plain'} = $data;

  my $view = new TestApp::View::Download::Plain;

  $c->res->body(''.$view->render($c,'',$c->stash));
}

sub _generate_csv_test_data {
  my ($self, $c) = @_;

  my $data = {
    'array' => [
      ['a','b','c','d'],
      ['1','2','3','4'],
      [' ',"\n","\t",'!'],
      ['@',',','"',"'"]
    ],
    'content' => '',
  };

  my $csv = Text::CSV->new ({
     quote_char          => '"',
     escape_char         => '"',
     sep_char            => ',', 
     eol                 => "\n", 
     binary              => 1,
     allow_loose_quotes  => 1,
     allow_loose_escapes => 1,
     allow_whitespace    => 1,
  });

  foreach my $row(@{$data->{'array'}}) {
    $csv->combine(@{$row});
    $data->{'content'} .= $csv->string();
  }

  return $data;
}

sub _generate_plain_test_data {
  my ($self, $c) = @_;

  my $content =<<"TEST";
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vestibulum tempus augue interdum neque. Curabitur ac libero. Aliquam faucibus mi a lectus. Sed et elit. Etiam volutpat suscipit quam. Phasellus sit amet odio. Sed faucibus magna quis diam. Nulla facilisi. Vivamus id erat porttitor elit aliquam ornare. Integer tincidunt varius lacus. Pellentesque sit amet mauris id ligula faucibus semper. Maecenas eros. Curabitur hendrerit ligula ac nulla. Mauris dolor eros, pellentesque vel, varius porttitor, convallis non, lectus.

Curabitur lacinia laoreet felis. Vivamus a urna. Aenean adipiscing aliquam velit. Aliquam varius bibendum nulla. Praesent quis tortor nec nisi scelerisque facilisis. Cras tristique. Phasellus mi libero, vulputate ac, hendrerit ac, iaculis at, elit. Pellentesque ac ante sit amet orci viverra condimentum. Fusce aliquam semper justo. Integer tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nullam id lectus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur ut felis non mauris auctor viverra. Fusce dignissim. Morbi quis magna.

Proin scelerisque, lacus blandit consequat sodales, augue ligula laoreet quam, condimentum pretium velit diam eget lorem. Suspendisse potenti. Nam rhoncus mi vitae tortor. Sed eget neque. Fusce sagittis. Nulla rutrum nibh et justo. Suspendisse dolor libero, rhoncus a, pretium id, feugiat eget, velit. Aenean accumsan. Nunc vel nulla. Mauris semper consectetuer velit. Vivamus semper. Nulla fermentum sapien nec felis. Aenean iaculis felis nec ipsum. Aliquam tristique. Nam ut quam. Suspendisse ornare tristique arcu. Morbi pellentesque dolor eget lorem. Morbi ac nunc euismod lorem porttitor hendrerit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
TEST

  return $content;
}

__PACKAGE__->setup();

1;
