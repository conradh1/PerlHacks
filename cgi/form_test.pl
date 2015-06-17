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
my $q= CGI::new(); #used for obtaining information from html pages
my $first_name = $q->param('name');
my $age = $q->param('age');
# Import the CGI module
########################################
# Define function to generate HTML form.
sub generate_form() {
  print $q->header(),
        $q->start_html(-title=>'Info Form',-bgcolor=>'#DDDDDD'),
        $q->h3('Please, enter your name and age.'),
        $q->start_form(-action => 'form_test.pl'),
        $q->table({-border => 0, -cellspacing => 3, -cellpadding => 3},
                  Tr(th('Name:').
                     td($q->textfield({-name=> 'name', -value=>$first_name, -size=> 10, -maxlength=> 12}))
                    ),
                  Tr(
                     th('Age:').
                     td($q->textfield({-name=> 'age', -value=>$age, -size=> 2, -maxlength=> 3}))
                    ),
                  Tr(
                     th({-colspan => 2}, $q->submit(-name  => 'submit',-value => 'Send'))
                    )
                 ),
        $q->end_form,
        $q->end_html;
}
########################################
# Check each field in form for validation
sub validate_form() {
  my $validate = 1;

  if (!$first_name) {
    print "<br><strong>Error, you must enter a first name.</strong>";
    $validate = 0;
  }

  if (!$age) {
    print "<br><strong>Error, you must enter a age.</strong>";
    $validate = 0;
  }
  elsif ( $age !~ /\d+/ ) {
    print "<br><strong>Error, age is not a number.</strong>";
    $validate = 0;
  }
  return ($validate);
  
}
########################################
# Define function display data.
sub display_data {
        
        print $q->b("$first_name, you are $age years old."),
              $q->end_html;
}
########################################
# Define main function.
sub main() {

  print $q->header(),
        $q->start_html(-title=>'Info Form',-bgcolor=>'#DDDDDD');
        

  if (!$q->param('submit')) {
    generate_form();
  }
  else {
    if (validate_form()) {
      display_data();
    }
    else {
      generate_form();
    }  
  }
  print $q->end_html;
} #main
########################################
main(); # Call main function.
