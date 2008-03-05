package Catalyst::View::Download;

use strict;
use warnings;
use base qw( Catalyst::View );

=head1 NAME

Catalyst::View::Download

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

__PACKAGE__->config(
	'default' => 'text/plain',
	'content_type' => {
		'text/csv' => {
			'outfile'	=> 'data.csv',
			'module' => '+Download::CSV',
		},
		'text/plain' => {
			'outfile' => 'data.txt',
			'module' => '+Download::Plain',
		},
	},
);

sub process {
	my $self = shift;
	my ($c) = @_;
	
	my $content = $self->render($c, $c->stash->{template}, $c->stash);
	
	$c->response->body($content);
}

sub render {
	my $self = shift;
	my ($c, $template, $args) = @_;
	my $content;
	
	my $content_type = $c->response->header('Content-Type') || $self->config->{'default'};
	my $options = $self->config->{'content_type'}{$content_type} || return $c->response->body;
	
	my $module = $options->{'module'} || return $c->response->body;
	if($module =~ /^\+(.*)$/) {
		$module = 'Catalyst::View::'.$1;
	}
	
	$c->response->header('Content-Type' => $content_type);
	$c->response->header('Content-Disposition' => 'attachment; filename='.$options->{'outfile'});
	
	Catalyst::Utils::ensure_class_loaded($module);
	my $view = new $module;
	
	$content = $view->render(@_);
	
	return $content;
}

1;
__END__

=head1 SYNOPSIS

	# lib/MyApp/View/Download.pm
	package MyApp::View::Download;
	use base qw( Catalyst::View::Download );
	1;

	# lib/MyApp/Controller/SomeController.pm
	sub example_action_1 : Local {
		my ($self, $c) = @_;

		my $content_type = $c->request->params->{'content_type'} || 'plain'; # 'plain' or 'csv'

		$c->header('Content-Type' => 'text/'.$content_type); # Set the content type so Catalyst::View::Download can determine how to process it.

		# Array reference of array references.
		my $data = [
			['col 1','col 2','col ...','col N'], # row 1
			['col 1','col 2','col ...','col N'], # row 2
			['col 1','col 2','col ...','col N'], # row ...
			['col 1','col 2','col ...','col N']  # row N
		];

		# If the chosen content_type is 'csv' then the render function of Catalyst::View::Download::CSV will be called which uses the 'csv' stash key
		$c->stash->{'csv'} = $data;

		# For plain text in this example we just dump the example array
		# Catalyst::View::Download::Plain will use either the 'plain' stash key or just pull from $c->response->body
		use Data::Dumper;
		$c->response->body( Dumper( $data ) )

		# Finally forward processing to the Download View
		$c->forward('MyApp::View::Download');
	}
	
=head1 SUBROUTINES

=head2 process

This method will be called by Catalyst if it is asked to forward to a component without a specified action.

=head2 render

Allows others to use this view for much more fine-grained content generation.

=head1 CONFIG

=over 4

=item default

Determines which Content-Type to use by default. Default: 'text/plain'

	$c->view('MyApp::View::Download')->config('default' => 'text/plain');

=item content_type

A hash ref of hash refs. Each key in content_type is Content-Type that is handled by this view. 

	$c->view('MyApp::View::Download')->config->{'content_type'}{'text/csv'} = {
		'outfile' => 'somefile.csv',
		'module' => 'My::Module'
	};

The Content-Type key refers to it's own hash of parameters to determine the actions thie view should take for that Content-Type.

'outfile' - The name and extenstion of the file that will display by default in the download dialog box.

'module' - The name of the module that will handle data output. If there is a plus symbol '+' at the beginning of the module name, this will indicate that the module is a Catalyst::View module will will add 'Catalyst::View::' to the beginning of the module name.

	$c->view('MyApp::View::Download')->config->{'content_type'}{'text/csv'}{'module'} = '+Download::CSV'; # Module Loaded: Catalyst::View::Download::CSV

	$c->view('MyApp::View::Download')->config->{'content_type'}{'text/csv'}{'module'} = 'My::Module::CSV'; # Module Loaded: My::Module::CSV

=back

=head1 Content-Type Module Requirements

Any module set as 'the' module for a certain Content-Type needs to have a subroutine named 'render' that returns the content to output with the following parameters handled.

=over 4

=item $c

The catalyst $c variable

=item $template

In case a template file is needed for the module. This view will pass $c->stash->{template} as this value.

=item $args

A list of arguments the module will use to process the data into content. This view will pass $c->stash as this value.

=back

=head1 CURRENT CONTENT-TYPES SUPPORTED

=head2 text/csv

Catalyst::View::Download has the following default configuration for this Content-Type

	$c->view('MyApp::View::Download')->config->{'content_type'}{'text/csv'} = {
		'outfile' => 'data.csv',
		'module' => '+Download::CSV'
	};

See L<Catalyst::View::Download::CSV> for more details.

=head2 text/plain

Catalyst::View::Download has the following default configuration for this Content-Type

	$c->view('MyApp::View::Download')->config->{'default'} = 'text/plain';

	$c->view('MyApp::View::Download')->config->{'content_type'}{'text/csv'} = {
		'outfile' => 'data.csv',
		'module' => '+Download::CSV'
	};
	
See L<Catalyst::View::Download::Plain> for more details.

=head1 AUTHOR

Travis Chase, C<< <gaudeon at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-view-download at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-View-Download>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Catalyst::View::Download

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Catalyst-View-Download>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Catalyst-View-Download>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Catalyst-View-Download>

=item * Search CPAN

L<http://search.cpan.org/dist/Catalyst-View-Download>

=back

=head1 SEE ALSO

L<Catalyst> L<Catalyst::View>

=head1 CONTRIBUTORS

=head1 ACKNOWLEDGEMENTS

Thanks to following people for their constructive comments and help:

=over 4

=item J. Shirley

=item Jonathan Rockway

=back

Thanks also to my company Ti4 Technologies for their financial support. L<http://www.ti4tech.com/>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Travis Chase, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
