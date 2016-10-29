#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Module Name: get_test.pl
# Author: Conrad Holmberg
# Created: June29/00
# This program tests the GET method
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use CGI qw/:standard :cgi/;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);
use FileHandle;

#global variables
my $cgi= CGI::new(); #used for obtaining information from html pages
my $url= $cgi->param('url'); #get the url to forward to
$| = 1;
# Remove buffering

###################Start Program############################################
    html_header();
    write_request();
    html_footer();
###################End Program##############################################

sub html_header {
#this subroutine prints the html header

     print header();  #cgi method to print the header
     print("<html><head><title>CGI function tests</title></head>",
	   "<meta http-equiv='REFRESH' CONTENT='1; URL=$url'>",
           "<BODY BGCOLOR='#DDDDDD' TEXT='000000'>",
           "<h1 align= 'center'>CGI function tests</h1>");
} #html_header

############################################################################
sub html_footer {
#this subroutine prints the html bottom
     print("<hr></body></html>");

} #html_footer
############################################################################
sub write_request {
#this subroutine prints the html head
    
     chdir("Z:\\INETPub\\WWWRoot"); 
     my $user= remote_user();
     my $user_name= user_name();
     my $host= remote_host();
     my $fh = new FileHandle "downloads.log", "a";    #open file rot
     
     $fh->open("downloads.log", "a") || die "\n $0 Cannot open $!\n";
     $fh->print("***************************************************\n");
     $fh->print("user name is $user_name\n");
     $fh->print("url requested is $url\n");
     $fh->print("host is $host \n");
     $fh->close;
} #perform_functions
############################################################################
