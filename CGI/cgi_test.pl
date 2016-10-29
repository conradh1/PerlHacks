#!/usr/bin/perl -w
##################################
# Perl Version 5.0
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

#global variables
my $cgi= CGI::new(); #used for obtaining information from html pages

###################Start Program############################################
	print $cgi->header().
		$cgi->start_html(-title=>"CGI Environment in Perl",-bgcolor=>"#DDDDDD").
		$cgi->h3("CGI Environment in Perl");
	show_environment();
	print $cgi->end_html();
###################End Program##############################################
############################################################################
sub show_environment {
#this subroutine prints the html head
     my @parameter_names= $cgi->param(); #get all the parameter names
     my @parameter_values; #holds the values
     foreach $_ (@parameter_names) {
     	push(@parameter_values, $cgi->param($_));
     }

     print $cgi->hr().
           $cgi->h3("Form Information")."\n";

     for (my $i= 0; $i <= $#parameter_names; $i++) {
	 print"name= $parameter_names[$i] &nbsp;&nbsp;&nbsp; value= $parameter_values[$i]<BR>\n";
     }
     my $cookie=$cgi->cookie(remote_host());
     print $cgi->hr().
           $cgi->h3("Environment Information");
    
     foreach $_ (sort keys(%ENV)) {
     	print $cgi->p("$_ = $ENV{$_}")."\n";
     }

} #perform_functions
