#!/usr/bin/perl
# Created by Charles McFadden (Virginia Institute for Marine Science / 
# modifed by Conrad Holmberg (not really though) March/2003
# chuck@vims.edu) and Ed Summers (Old Dominion University / esummers@odu.edu)
# this CGI script uses the MARC.pm Perl Module. Please contact the authors
# for more information. Feel free to redistribute this code as needed.
# ehs 12/1/1999

use CGI;
use MARC;
use MARC::XML;

#create the CGI object
$q=new CGI;

#get name value pairs from the web form
$self=$q->script_name();
$filename=$q->param('file');
$tmpfilename=$q->tmpFileName($filename);
$type=$q->param('type');
$remotehost=$q->remote_host();

#if the person has just come to the web page then give them the form
if (not($filename)) {

print 
$q->header,
"<body background=\"../../icons/book_cloth.gif\">",
$q->start_html(-title=>'Web Interface to MARC.pm'),
"<table align=\"center\"><tr><th><a target=\"_new\" href=\"http://www.athabascau.ca\"><img src=\"../../icons/aulogo.gif\" align=\"left\" border=\"0\" alt=\"Athabasca University Home\"></a></th>",
"<th><a target=\"_new\" href=\"http://ccism.pc.athabascau.ca\"><img src=\"../../icons/ccis2.gif\" align=\"right\" border=\"0\" alt=\"CCISM Home\"></a></th></tr></table>",
"<table width=\"700\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\" bgcolor=\"#FFFF99\">",
"<tr>",
"<td width=\"40\" valign=\"top\" bgcolor=\"#CCCC99\" height=\"12\">&nbsp;</td>",
"<td valign=\"top\" width=\"160\" bgcolor=\"#CCCC99\">&nbsp;</td>",
"<td valign=\"top\" width=\"500\" bgcolor=\"#CCCC99\">&nbsp;</td>",
"</tr>",
"</table>",
"<table width=\"700\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\" bgcolor=\"#FFFF99\">",
"<tr>",
"<td valign=\"top\" bgcolor=\"#FFFF99\"><center><h1>MARC Conversion Interface</h1>",
"<p>This web form converts MARC records into other formats. AU MARC records can be found in the <a href=\"http://aupac.lib.athabascau.ca/screens/opacmenu.html\" target=\"_new\">Athabasca University Library Catalogue</a>.",
$q->start_multipart_form('post',$self),

"Select the type of conversion you would like to perform",
$q->br,
	"<SELECT name=\"type\">\n",
	"<OPTION>MARC->XML\n",
	"<OPTION>MARC->HTML (100,245,600,610,650,700,710,856 fields)\n",
	"<OPTION>MARC->ASCII\n",
	"<OPTION>MARC->ISBD\n",
	"</SELECT>\n",
	$q->p,
	"Use the Browse button to locate the input file on your computer (click <a href=\"http://adlib.athabascau.ca/marc/marc.htm\" target=\"_new\">here</a> for a tutorial.)",
	$q->filefield(-name=>'file',-size=>'40'),
	$q->p,
	$q->br,
	$q->submit(),
	$q->endform,
	$q->p(),	
	"</center></td></tr>",
	"<tr><td valign=\"top\" bgcolor=\"#CCCC99\">",
	"<font face=\"Arial, Helvetica, sans-serif\" size=\"-5\" color=\"#666666\">Last update March 31, 2002\n<br>Note: This application works best with Netscape 6.0 or higher and IE 5.0 or higher.<br>&nbsp;",
	"</font></td></tr>",
	"</table>",
	$q->br,	
	$q->end_html();
} #if

#if the person has submitted a MARC file for translating then translate it!
elsif ($type eq "MARC->ASCII") {
print
"content-type: text/plain\n\n";
$x=MARC->new($tmpfilename);
print $x->output({format=>"ascii"});
}

#if the person has submitted a MARC file for translating then translate it!
elsif ($type eq "MARC->MARCMakr") {
print
"content-type: application/marc\n\n";
$x=MARC->new($tmpfilename);
print $x->output({format=>"marcmaker"});
}

#if the person has submitted a MARCMakr file for translating then translate it!
elsif ($type eq "MARCMakr->MARC") {
print "content-type: application/marc\n\n";
$x=MARC->new($tmpfilename,"marcmaker");
print $x->output({format=>"marc"});
}

#if the person has submitted a MARC file for translating to XML then translate it!
elsif ($type eq "MARC->XML") {
print "content-type: application/xml\n\n";
$x=MARC::XML->new($tmpfilename,"usmarc");
print $x->output({format=>"xml"});
}

#if the person wants to convert to HTML then display on screen
elsif ($type eq "MARC->HTML (100,245,600,610,650,700,710,856 fields)") {
print "content-type: text/html\n\n";
$x=MARC->new($tmpfilename) || die "couldn't open file";
print $x->output({format=>"html",100=>"Author: ",245=>"Title: ",260=>"Imprint: ",600=>"Personal Name: ",610=>"Corporate Name: ", 650=>"Subject: ", 700=>"Other Author: ",710=>"Other Author: ", 856=>"URL: "});
}

#if the person wants to extract urls then display on screen
elsif ($type eq "MARC->EXTRACTURLS") {
print "content-type: text/html\n\n";
$x=MARC->new($tmpfilename);
print $x->output({format=>"urls"});
}

#if the person wants to output in ISBD format
elsif ($type eq "MARC->ISBD") {
print "content-type: text/plain\n\n";
$x=MARC->new($tmpfilename);
print $x->output({format=>"isbd"});
}
