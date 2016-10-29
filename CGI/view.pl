#!/usr/bin/perl
#script: view.pl

use CGI ':standard';

print header,

start_html ('Athabasca University - Construct of LSO Courses Table'),
img ({-src=>'/aublugr.gif', -align=>'center', -alt=>'Athabascaa University'}),
h1 ({-align=>'center'},'Request to Construct LSO Table'),
p({-align=>'center'},'Please request the type of view that you wish to construct.'),
hr,
process_forms(),   
hr,
a({-href=>'http://www.athabascau.ca'}),
img({src=>'/auhome.gif',-align=>'right', -alt=>'[AU Home Page]'}),
img({src=>'/au_incis.gif', -alt=>'AU'}),
a({-href=>'/conradh@athabascau.ca'}, "Webmaster"),

end_html; 


sub process_forms {
 
    start_form(-action=>'/cgi-bin/LSO.pl'),
    strong({-align=>'center'},'Create General Web View.'),
    p(),
    'Sort table by: ',
    submit(-name=> 'Institution', -value=> 'Institution'),
    submit(-name=>'Project ID'),
    submit(-name=>'Alpha order'),
    p(),
    strong({-align=>'center'},'Create Intranet View.'),
    p(),
    'Sort table by: ',
    submit(-name=>'Institution'),
    submit(-name=>'Project ID'),
    submit(-name=>'Alpha order'), 
    p(),
    strong({-align=>'center'},'Create Intranet view by Course, Project ID, and Institution.'),
    p(),
    'View table by: ',
    submit(-name=> 'view_form', -value=> 'view_7'),
    p(),
    strong({-align=>'center'},'Create Intranet view by Supervisor, Semester, and Course ID.'),
    p(),
    'Sort table by: ',
    submit(-name=>'Supervisor'), 
    end_form,
}




