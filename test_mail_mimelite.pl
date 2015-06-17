#!/usr/bin/perl -w
# Small program to test module mime lite to send an email

use MIME::Lite;
use strict;

print "Running mime lite test\n";
&emailViaMimeLite();
exit(0);


#<emailViaMimeLite ()>

#  Emails an error to the somebody

sub emailViaMimeLite()
{
    my $emailTo = 'conradwholmberg@gmail.com';
    #compose the message
    my $message = "To whom it may concern:\n".
               "\t\tThis is an automated message testing Mime Lite. \n";


    my $mimeEmail = MIME::Lite->new (
        To => $emailTo,
        From => 'automatedresponse@lsb01.psps.ifa.hawaii.edu',
        Subject => 'Mime Lite Test for Perl',
        Data => $message
    );
    if ( $mimeEmail->send() ) {
      print "Email successfully sent to $emailTo\n";
    }
    else {
        die ("Error: Could not send email to ".$emailTo.". Please check account.");
    }

} #emailViaMimeLite
