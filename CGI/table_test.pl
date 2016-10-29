#!/usr/bin/perl -w
##################################
# Perl Script Version 5.8.1
# Script Name: table_test.pl
# Author: Conrad Holmberg
# Created: May 04/2004
# This program prints out html tables
# using the cgi module
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use CGI qw/:standard :cgi/;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);

#global variables
my $q= CGI::new(); #used for obtaining information from html pages

my %tables = (
    'language' =>
    ['English','French','Spanish','Indonesian','Greek'],
    'Table1' =>
    ['One','Un','Onze','Satu','Alpha'],
    'Table2' =>
    ['Two','Deu','Duaz','Dua','Beta'],
    'Table3' =>
    ['Three','Tre','Trez','Tiga','Gamma']
    );

my $p_table= $q->param('table');
################# START PROGRAM ###################

print $q->header(),
      $q->start_html(-title=>'Language Table',-style=>{-src=>'/style/finance.css'});

if ($q->param('submit') eq 'Send') {
  display_data();
}
else {
  generate_form();
}

print $q->end_html;
################# END PROGRAM #####################
###################################################
# Define function to generate HTML form.
sub generate_form {
  print $q->h3('Please, complete this form.'),
        $q->start_form(-action => 'table_test.pl', -method => 'get'),
        $q->table({-border => 0, -cellspacing => 3, -cellpadding => 3},
                  Tr(th('Table Type:').
                     td($q->popup_menu(-name =>'table',
                                       -values => ['All', 'Table1','Table2','Table3'],
                                       -default => $p_table)).
                     td($q->submit(-name => 'submit', -value => 'Send'))
                    )
                 ),
        $q->endform;
}
########################################
# Define function display data.
sub display_data {


  my @dtl= th({-class=>'header'}, $tables{'language'});

  if ($p_table eq 'All') {
    push @dtl, td({-class=>'alt1'}, $tables{'Table1'});
    push @dtl, td({-class=>'alt2'}, $tables{'Table2'});
    push @dtl, td({-class=>'alt1'}, $tables{'Table3'});
  }
  elsif ($p_table eq 'Table1') {
    push @dtl, td({-class=>'alt1'}, $tables{'Table1'});
  }
  elsif ($p_table eq 'Table2') {
    push @dtl, td({-class=>'alt1'}, $tables{'Table2'});
  }
  elsif ($p_table eq 'Table3') {
    push @dtl, td({-class=>'alt1'}, $tables{'Table3'});
  }

  print $q->table({-border => 0, -cellspacing => 3, -cellpadding => 3},
                  Tr(\@dtl)
                 );
} #display_data
########################################



