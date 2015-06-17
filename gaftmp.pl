
#!/usr/local/bin/perl -- -*-perl-*-
# Load externalibraries
$|=1;

use strict;

require "ctime.pl";
require 'ccproc.pl';
use POSIX 'strftime';

# declaration of the forms package
require "formpk.pm";

# Get some variable definitions out of the way
my $pid = "$$";
## my $logfile = '/usr/local/ns-home/httpd-auburn/logs/log.gaftmp';
## my $logfile = 'log.gaftmp';
return_message_header();

#get_parameters();
form_set_param('send_degree', 'BSc Accounting");
form_set_param('send_institution', "University of Alberta');
# if this function fails the script terminates
check_fields(); 

# requires main routine: out_message_routine
# this function calls this main routine to create secret output message
form_encrypt($datafile, $recipient);

## insert check if the encrypted file exists before continuing

system("echo \"".&fparam('surname').", ".&fparam('firstname').":".$pid."\" | cat - > $controlfile");

return_message();

exit;

# main routines

sub return_message_header {
# Print out a content-type for HTTP/1.0 compatibility
    print "Content-type: text/html\n\n";

# Print a title and heading
    print "<Head><Title>WWW CLC General Application Form Response </Title></Head>\n";
    print "<H2>WWW CLC General Application Form Response </H2><P>\n";
}

sub return_message {
# Relay processing status to the user
    print "Thank you. Your application has been accepted by our server ";
    print "and will be processed.\n";
    print "<P>Name: <B>".&fparam('firstname')." ".&fparam('midname')." ";
    print "".&fparam('surname')."</B><P>\n";
    if (&fparam('paytype') eq "Charge") {
        print "Payment by ";
        print "".&fparam('ccard')." # ".ccformatcard2(&fparam('ccard'),&fparam('ccnum'));
    } elsif (&fparam('paytype') eq "Cheque") {
        print "Payment by Cheque";
    } elsif (&fparam('paytype') eq "Cash") {
        print "Payment by Cash";
    }
    print "<P>You will be charged ".&fparam('fee')."\n";
    print "<P>If you have any problems or questions, feel free to email our \n";
    print "<A HREF=\"mailto:auinfo\@cs.athabascau.ca\">Information Desk</A>.\n";
    
    my $TIME = strftime("%d-%b-%Y %H:%M", localtime);
    
    open (LOGFILE, ">>$logfile");
    printf LOGFILE "%17s %15s %30s %30s\n", $TIME, $ENV{'REMOTE_ADDR'}, &fparam('firstname'), &fparam('surname');
    close LOGFILE;
}

# ----------------------------------------------------------------------
# This subroutine checks whether form fields are required and
# formatted correctly.
# ----------------------------------------------------------------------
sub check_fields
{
    # Do some simple editing
    print_error("You must enter a valid Degree") unless fparam('send_degree');
    print_error("You must enter a valid Institution") unless fparam('send_institution');
    exit if check_errors();
}

#
# This routine outputs to a filehandle WTR that is pointing to
# standard input of an expect script.
# It is called by the form_encrypt routine.
#
sub out_message_routine {
    my ($WTR) = @_;
    print_expect( \*WTR, 0, "--------------------------------------------------------\n\n");
    print_expect( \*WTR, 0, "CLC General Application Form\n\n");
    print_expect( \*WTR, 0, "Name: ".&fparam('firstname')." ".&fparam('midname')." ".&fparam('surname')."\n\n");
    print_expect( \*WTR, 0, "Mailing Name: ".&fparam('mailname')."\n\n");
    print_expect( \*WTR, 0, "Former Name: ".&fparam('forname')."\n\n") if &fparam('forname');
    print_expect( \*WTR, 0, "Address: ".&fparam('addr1')."\n");
    print_expect( \*WTR, 0, "         ".&fparam('addr2')."\n") if &fparam('addr2');
    print_expect( \*WTR, 0, "         ".&fparam('addr3')."\n") if &fparam('addr3');
    print_expect( \*WTR, 0, "         ".&fparam('city').", ".&fparam('prov')."  ".&fparam('country')."\n");
    print_expect( \*WTR, 0, "         ".&fparam('postcode')."\n\n");
    print_expect( \*WTR, 0, "Email: ".&fparam('email')."\n\n");
    print_expect( \*WTR, 0, "Phone: ".&fparam('hphone')." (home)\n");
    print_expect( \*WTR, 0, "       ".&fparam('wphone')." (work)\n") if &fparam('wphone');
    print_expect( \*WTR, 0, "\nBirthdate: ".&fparam('bdate')."\n\n");
    print_expect( \*WTR, 0, "SIN: ".&fparam('sin')."\n\n");
    print_expect( \*WTR, 0, "Gender: ".&fparam('gender')."\n\n");
    print_expect( \*WTR, 0, "Citizenship: ".&fparam('citship'));
    print_expect( \*WTR, 0, " (".&fparam('citcountry').")") if &fparam('citcountry');
    print_expect( \*WTR, 0, "\n\nSecondary Education: ".&fparam('edusec')."\n\n");
    print_expect( \*WTR, 0, "Post-secondary Education: ".&fparam('edupost')."\n\n") if &fparam('edupost');
    print_expect( \*WTR, 0, "Occupation: ".&fparam('occupation')."\n\n") if &fparam('occupation');
    print_expect( \*WTR, 0, "Disability: ".&fparam('disabled'));
    print_expect( \*WTR, 0, " (".&fparam('disability').")") if &fparam('disability');
    print_expect( \*WTR, 0, "\n\nAboriginal: ".&fparam('aboriginal')."\n\n");
    print_expect( \*WTR, 0, "In program at another institution: ".&fparam('transfer')."\n\n");
    print_expect( \*WTR, 0, "How did you first hear about AU: ".&fparam('contact')."\n\n");
    print_expect( \*WTR, 0, "AU credential desired: ".&fparam('aucred'));
    print_expect( \*WTR, 0, " (".&fparam('aucrednm').")") if &fparam('aucrednm');
    print_expect( \*WTR, 0, "\n\nEducational History:\n");
    print_expect( \*WTR, 0, "\t".&fparam('inst1')." | ".&fparam('loc1')." | ".&fparam('attend1')." | ".&fparam('degree1')." | Credential received - ".&fparam('credrec1')."\n") if &fparam('inst1');
    print_expect( \*WTR, 0, "\t".&fparam('inst2')." | ".&fparam('loc2')." | ".&fparam('attend2')." | ".&fparam('degree2')." | Credential received - ".&fparam('credrec2')."\n") if &fparam('inst2');
    print_expect( \*WTR, 0, "\t".&fparam('inst3')." | ".&fparam('loc3')." | ".&fparam('attend3')." | ".&fparam('degree3')." | Credential received - ".&fparam('credrec3')."\n") if &fparam('inst3');
    print_expect( \*WTR, 0, "\nFee: ".&fparam('fee')."\n\n");
    if (&fparam('paytype') eq "Charge") {
        print_expect( \*WTR, 0, "Charge to: ".&fparam('ccard')." - ");
        print_expect( \*WTR, 0, "".ccformatcard2(&fparam('ccard'),&fparam('ccnum')));
        print_expect( \*WTR, 0, " (".&fparam('ccexpdt').")\n\n");
    } elsif (&fparam('paytype') eq "Cash") {
        print_expect( \*WTR, 0, "Payment by cash\n\n");
    } elsif (&fparam('paytype') eq "Cheque") {
        print_expect( \*WTR, 0, "Payment by cheque\n\n");
    }
    print_expect( \*WTR, 0, "--------------------------------------------------------\n");
    print_expect( \*WTR, 0, "--End Of Message--\n");
}







