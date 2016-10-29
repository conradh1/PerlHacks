#!/usr/bin/perl --
use strict;

require LWP::UserAgent;

 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
 $ua->env_proxy;

 my ( $filesetURL ) = 'http://search.cpan.or';
 my ( $lastFileSet ) = '';
 my $newFileSet;  # string of the new file set if there is one
 my $htmlResponse; # html request response
 my $htmlContent;  # content from the html request.
 my $maxHtmlRequestAttempts = 5;
 my $htmlRequestAttempts = 0;
 my $htmlRequestSuccess = 0;
 # The URL to find the next fileset is the base datastore domain plus the last file set

    while ( !$htmlRequestSuccess && $htmlRequestAttempts < $maxHtmlRequestAttempts) {
      #$htmlResponse = $ua->get( "$filesetURL/index.txt?$lastFileSet" );
      print "attemtping to poll\n";
      $htmlResponse = $ua->get( "$filesetURL" );
      # Case successful response
      if ($htmlResponse->is_success) {
        $htmlContent = $htmlResponse->content;
	$htmlRequestSuccess = 1;
      }
      else {
        # $self->_logger->logdie("Poll Error: ".$htmlResponse->status_line);
	$htmlRequestAttempts++;
	print ("Poll Error at $htmlRequestAttempts attempt(s): ".$htmlResponse->status_line);
	sleep(1); #wait a minute
      }
    } # while

    if ( !$htmlRequestSuccess ) {
      die ("Poll Error died after $maxHtmlRequestAttempts attempts: ".$htmlResponse->status_line);
    }
    else {
      print "########### Poll succes ##################\n";
    }
    # There is one file per line so simply count the number of lines
#     if ( $htmlContent ) {
#       print "$htmlContent\n";
#     }
