#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Module Name: cgi_funcs.pl
# Author: Conrad Holmberg
# Created: June29/00
# This program is for testing cgi functions
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use CGI qw/:standard :cgi/;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);
use Win32::NetAdmin qw(GetUsers UsersExist UserGetAttributes UserCreate UserChangePassword GroupAddUsers);
#global variables
my $cgi= CGI::new(); #used for obtaining information from html pages

$| = 1;
# Remove buffering

###################Start Program############################################
    html_header();
    perform_functions();
    html_footer();
###################End Program##############################################

sub html_header {
#this subroutine prints the html header

     print header();  #cgi method to print the header
     print("<html><head><title>CGI function tests</title></head>",
           "<BODY BGCOLOR='#DDDDDD' TEXT='000000'>",
           "<h1 align= 'center'>CGI function tests</h1>");
} #html_header

############################################################################
sub html_footer {
#this subroutine prints the html bottom
     print("<hr></body></html>");

} #html_footer
############################################################################
sub perform_functions {
#this subroutine prints the html head
    my $user= "conradh";
    my $password;
    my $passwordAge;
    my $privilege;
    my $homeDir;
    my $comment;
    my $flags;
    my $scriptPath;
    my %user_bunch;
    if (UsersExist("", $user)) {
	print"user exits.<BR>";
    }
    else {
	print"user does not exit<BR>";
    }
    #GetUsers("", "FILTER_NORMAL_ACCOUNT" , \%user_bunch) or die "GetUsers() failed: $^E";
    #UserGetAttributes(server, userName, password, passwordAge, privilege, homeDir, comment, flags, scriptPath);
    UserGetAttributes("", $user, $password, $passwordAge, $privilege, $homeDir, $comment, $flags, $scriptPath);
    print"Attributes for $user <BR>\n";
    print"Password $password <BR>\n";
    print"Password Age $passwordAge <BR>\n";
    print"Privilege: $privilege<BR>\n";
    print"Home Dir $homeDir <BR>\n";
    print"Comment $comment <BR>\n";
    print"Flags $flags <BR>\n";
    print"Script Path $scriptPath <BR>\n";
    #UserCreate(server, userName, password, passwordAge, privilege, homeDir, comment, flags, scriptPath)
    UserCreate("", "aabuddy", "buddy", 0, 1, "", "test-user", 513, "");
    #UserChangePassword(domainname, username, oldpassword, newpassword)
    #GroupAddUsers(server, groupName, users)
    GroupAddUsers("", "Global", "aabuddy");
    #UserChangePassword("", "aabuddy", "buddy", "buddy1");
} #perform_functions
############################################################################
