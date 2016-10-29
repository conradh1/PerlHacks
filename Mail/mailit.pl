#!/usr/bin/perl


#                                                        : :::::::::: :
#                                                        : Feb 05, 03 :
# mailit - a perl mailer for unix command shell programs : :::::::::: :
#             to do custom mailing of logs and such      : Troy Adams :
#                                                        : :::::::::: :
#
# type in 'mailit.pl -h' for help
#



# access the appropriate modules so we do not need to do manual stuff
use Mail::Sendmail;
use Getopt::Std;


# declare some variables
my    $MYNAME      = `hostname -s`;               # computer host
chomp $MYNAME;
my    $RETRIES     = 20;                          # total number of send tries
my    $RETRY_DELAY = 20;                          # twenty seconds between tries
my    $recipient   = "cs_oper\@athabascau.ca";    # default recipient
my    $subject     = "$MYNAME Backup Report";     # default subject
my    $sender;
my    $smtpserver  = "mail.athabascau.ca";        # default smtp server

my    $true        = 1;
my    $false       = 0;
my    $verbose     = $false;                      # no verbosity by default

my    $Message;



# retreive & parsing of optional command line arguments
getopts("hvt:f:s:m:");   # colons mean there is an argument (non-boolean)
if ($opt_h) { 
              print STDERR "$0 options:\n";
              print STDERR "  -h              help\n";
              print STDERR "  -v              verbose\n";
              print STDERR "  -t [to]         recipient\n";
              print STDERR "  -f [from]       sender\n";
              print STDERR "  -s [subject]    subject\n";
              print STDERR "  -m [mailserver] mailserver\n";
              print STDERR "\n";
              print STDERR "$0 -h -v -t 'somebody\@somewhere.com' ";
              print STDERR "-s 'subject' -f 'fromsomebody'\n";
              exit 0;
            }
if ($opt_v) { $verbose   = $opt_v; }
if ($opt_t) { $recipient = $opt_t; }
if ($opt_f) { if ($opt_f =~ /\@/) { $sender    = "$opt_f"; }
              else { $sender    = "$opt_f\@$MYNAME"; }
            }
if ($opt_s) { $subject   = $opt_s; }
if ($opt_m) { $smtpserver= $opt_m; }


# read in the message body
while (<STDIN>) { $Message .= $_; }


# verbosity dump
if ($verbose)
   {
      print "host:    $MYNAME\n";
      print "server:  $smtpserver\n";
      print "To:      $recipient\n";
      print "From:    $sender\n";
      print "Subject: $subject\n";
      print "Message: \n";
      print "-----------------------------------------------------------------";
      print "---------------\n";
      print $Message;
      print "-----------------------------------------------------------------";
      print "---------------\n\n";
   }


# send the message:
$Mail::Sendmail::mailcfg{smtp}->[0] = $smtpserver;
$Mail::Sendmail::connect_retries = $RETRIES;
$Mail::Sendmail::retry_delay = $RETRY_DELAY;
sendmail( To      => $recipient,
          From    => $sender,
          Subject => $subject,
          Message => $Message,
        ) or die $Mail::Sendmail::error;

