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
	my $script= "\nfunction submitForm() {\n\tdocument.je_group.submit();\n}\n";

	print $cgi->header().
		$cgi->start_html(-title=>"CGI Environment in Perl",-bgcolor=>"#DDDDDD", -script=>$script).
		$cgi->h3("CGI Environment in Perl");
	print  "<form name=\"form1\" method=\"post\">",
		"Form:",
		"<select name=\"greetings\" onchange=\"submitForm();\">",
  		"<option value=\"Hello\">H</option>",
  		"<option value=\"GoodBye\">G</option>",
  		"<option value=\"So long\">L</option>",
		"</select>";
                "<input type=\"hidden\" name=\"file\" value=\"file1\">",
                "<input type=\"hidden\" name=\"file\" value=\"file2\">",
               	$cgi->submit(-name  => 'go', -value => 'Submit'),
		"</form>";
	show_environment();
	print $cgi->end_html();
###################End Program##############################################
############################################################################
sub show_environment {
#this subroutine prints the html head
     print "<hr>";
     my @parameter_names= $cgi->param(); #get all the parameter names
     foreach $_ (@parameter_names) {
     	print("Name: ".$_."Value: ".$cgi->param($_));
     }
     print "<hr>";
     my @files = $cgi->param("file");
     foreach (@files) {
       print "file is $_ <br>";
     }
}
#show_environment
