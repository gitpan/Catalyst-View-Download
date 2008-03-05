package Catalyst::View::Download::CSV;

use strict;
use warnings;
use base qw( Catalyst::View );

use Catalyst::Exception;
use Text::CSV;

=head1 NAME

Catalyst::View::Download::CSV

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

__PACKAGE__->config(
	'stash_key' => 'csv',
	'quote_char' => '"',
	'escape_char' => '"',
	'sep_char' => ',',
	'eol' => "\n",
);

sub process {
	my $self = shift;
	my ($c) = @_;

  my $template = $c->stash->{template};
  my $content = $self->render($c, $template, $c->stash);

  $c->res->headers->header("Content-Type" => "text/csv") if($c->res->headers->header("Content-Type") eq "");
  $c->res->body( $content );
}

sub render {
	my $self = shift;
	my ($c,  $template, $args) = @_;

  my $content;
	
	my @data;
	
	my $stash_key = $self->config->{'stash_key'};
	
  if(defined($args->{$stash_key}) && ref($args->{$stash_key}) =~ /ARRAY/) {
		push(@data, @{$args->{$stash_key}});
  }
  else {
    foreach my $key(%{$args}) {
      if(ref($args->{$key}) =~ /ARRAY/) {
        push(@data,@{$args->{$key}});
      }
    }
  }
	
	my $csv = Text::CSV->new ({
     quote_char          => $self->config->{'quote_char'},
     escape_char         => $self->config->{'escape_char'},
     sep_char            => $self->config->{'sep_char'},
     eol                 => $self->config->{'eol'},
     binary              => 1,
     allow_loose_quotes  => 1,
     allow_loose_escapes => 1,
     allow_whitespace    => 1,
  });
	
	foreach my $row(@data) {
		my $status = $csv->combine(@{$row});
    Catalyst::Exception->throw("Text::CSV->combine Error: ".$csv->error_diag()) if(!$status);
    $content .= $csv->string();
	}

  return $content;
}

=head1 SYNOPSIS

  # lib/MyApp/View/Download/CSV.pm
  package MyApp::View::Download::CSV;
  use base qw( Catalyst::View::Download::CSV );
  1;

  # lib/MyApp/Controller/SomeController.pm
  sub example_action_1 : Local {
    my ($self, $c) = @_;
  
    # Array reference of array references.
    my $data = [
      ['col 1','col 2','col ...','col N'], # row 1
      ['col 1','col 2','col ...','col N'], # row 2
      ['col 1','col 2','col ...','col N'], # row ...
      ['col 1','col 2','col ...','col N']  # row N
    ];

    # To output your data in comma seperated values just pass your array by reference into the 'csv' key of the stash
    $c->stash->{'csv'} = $data;

    # Finally forward processing to the CSV View
    $c->forward('MyApp::View::Download::CSV');
  }

  # Other ways of storing data
  sub example_action_2 : Local {
    my ($self, $c) = @_;

    # Array of array references
    my @data;

    push(@data,['col 1','col 2','col ...','col N']); # row 1
    push(@data,['col 1','col 2','col ...','col N']); # row 2
    push(@data,['col 1','col 2','col ...','col N']); # row ...
    push(@data,['col 1','col 2','col ...','col N']); # row N

    # OR to produce a single column of data you can simply do the following 
    my @data = (
                'col 1 row 1',
                'col 1 row 2',
                'col 1 row ...',
                'col 1 row N'
               );

    $c->stash->{'csv'} = \@data;

    $c->forward('MyApp::View::Download::CSV');
  }

  # Available Options to produce other types of delimiter seperated output
  sub  example_action_3 : Local {
    my ($self, $c) = @_;

    my $data = [
      ['col 1','col 2','col ...','col N'], # row 1
      ['col 1','col 2','col ...','col N'] # row 2
    ];

    # You can change any of the aspects of a delimiter seperated values format by change the view configuration
    # This is an example of tab seperated values for instance

		$c->view('MyApp::View::Download')->config(
			'stash_key' => 'data',
			'quote_char' => '"',
			'escape_char' => '"',
			'sep_char' => "\t",
			'eol' => "\n",
		);

    $c->stash->{'data'} = $data;
		
		$c->forward('MyApp::View::Download::CSV');
  }

=head1 SUBROUTINES

=head2 process

This method will be called by Catalyst if it is asked to forward to a component without a specified action.

=head2 render

Allows others to use this view for much more fine-grained content generation.

=head1 CONFIG

=over 4

=item stash_key

Determines the key in the stash this view will look for when attempting to retrieve data to process. If this key isn't found it will then look at the stash as a whole, find any array references and process them.

	$c->view('MyApp::View::Download')->config->{'stash_key'} = 'data';

=item quote_char

Determines what value will be enclosed within if it contains whitespace or the delimiter character. DEFAULT: '"'

  $c->view('MyApp::View::Download')->config->{'quote_char'} = '/';

=item escape_char

Determines what value will be to escape any delimiter's found in a column. DEFAULT: '"'

  $c->view('MyApp::View::Download')->config->{'escape_char'} = '/';

=item sep_char

Determines the separator between columns. DEFAULT: ','

  $c->view('MyApp::View::Download')->config->{'sep_char'} = '|';

=item eol

Any characters defined in eol will be placed at the end of a row. DEFAULT: '\n'

  $c->view('MyApp::View::Download')->config->{'eol'} = '\0';

=back

=head1 AUTHOR

Travis Chase, C<< <gaudeon at cpan.org> >>

=head1 SEE ALSO

L<Catalyst> L<Catalyst::View> L<Catalyst::View::Download> L<Text::CSV>

=head1 CONTRIBUTORS

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 Travis Chase, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Catalyst::View::Download::CSV
