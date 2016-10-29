#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Program Name: ride_search.pl
# Author: Conrad Holmberg
# Created: 07/22/02
# Last Modified: 07/23/02
# This program is for students searching a web directory and
# shows the URL for matched files
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use CGI qw/:standard :cgi/;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);
use FileHandle;
use Time::localtime; #module for getting the current time and date
use DirHandle; #used for opening directories

#global variables
my $cgi= CGI::new(); #used for obtaining information from html pages
my $str_search= $cgi->param('search_str'); #gets the search string
$str_search=~ s/\s\s+/ /gi; #replace extra spaces with one
$str_search=~ s/\s$//gi; #get rid of trailing space
$str_search=~ s/[^a-zA-z0-9\'\"\s]//gi; #get rid of any special unwanted characters
my %search_hits; #hash where the index name is a file and the value is the number of search hits
my $html_dir=
"/usr/local/etc/httpd/htdocs/html/ccism/deresrce/ride/"; #web dir path
my $main_site= "http://".$ENV{'SERVER_NAME'}."/html/ccism/deresrce/ride/"; #url path for searched pages
my $search_site=
"http://".$ENV{'SERVER_NAME'}."/html/ccism/deresrce/ride/ride_search.html";
$| = 1; #remove buffering
###################Start Program############################################
############################################################################
htmlHeader();

if (defined($cgi->param('search_state')) && $cgi->param('search_state') eq "search" && $str_search ne "") {
    startSearch(); #get the directories
    showResults(); #show the search results
}
else {
    print("<h3>Error... nothing to search. &nbsp;Please click <a href='$search_site'>here</a> to do a search.</h3>\n");
}
htmlFooter();
############################################################################
####################End Program#############################################
#################### htmlHeader ############################################
sub htmlHeader {
#this subroutine prints the html header

     print header();  #cgi method to print the header
     print("<html><head><title>RideSearch Results</title></head>\n".
           "<BODY>\n".
           "<center>\n<a href=\"http://www.athabascau.ca\">\n".
	   "<IMG BORDER=\"NONE\" SRC=\"/icons/auname.gif\" ALT=\"Athabasca University\">\n</a>\n</center>\n");

} #htmlHeader
############################################################################
#################### htmlFooter ############################################
sub htmlFooter {
#this subroutine prints the html bottom
     print("<CENTER><A HREF=\"http://www.athabascau.ca\"><STRONG>[AU 
Home]</STRONG></A>\n".
  	   "<A HREF=\"http://ccism.pc.athabascau.ca\"><STRONG>[CCIS 
Home]</STRONG></A>\n".
	   "</CENTER>\n".
	   "<BR><HR NOSHADE>\n".
	   "</BODY></HTML>");
} #htmlFooter
############################################################################
#################### startSearch ###########################################
sub startSearch {
#opens the html_dir directory value and assigns the values to dir_files
#then a call is made to searchFiles to obtain files with a html extension
    chdir($html_dir);
    my $dh= new DirHandle $html_dir; #new directory handle
    $dh->open($html_dir);
    my @dir_files= $dh->read(); #assign directory files
    $dh->close();
    searchFiles(@dir_files);
} ##get_dir
############################################################################
#################### searchFiles ###########################################
sub searchFiles {
# looks for all files in the directory with a html or htm
# extenstion when passed the directory
# assigns it to an array and searches each file by calling searchFileX()
# depending on type

    my (@dir_files)= @_;
    my @search_files; #array for storing all searchable files
    my $search_type= $cgi->param('search_type');

    foreach $_ (@dir_files) {
    #search for X.html and X.htm then assign to search_files
        if (/\w+(?=.html)/ || /\w+(?=.htm)/ || /\w+(?=.xml)/) {
            push(@search_files, $_);
        }
    } #foreach
    foreach $_ (@search_files) {
        open(HANDLE, $_) || die "\n $0 Cannot open $!\n";
        if ($search_type eq "any") {
            #search for any word or phrase
            searchFileAny(\*HANDLE, $_, $search_type);
        }
        elsif ($search_type eq "all") {
            #search and match all words
            searchFileAll(\*HANDLE, $_);
        }
        close(HANDLE);
    } #foreach
} ##get_files
############################################################################
###############  searchFileAny  ####################################
sub searchFileAny() {
#accepts the file handle and the file name
#searches the file line by line for a any match from the keywords
    my ($fh, $file, $search_type)= @_;
    #find search for exact for any of the words
    my $found= 0;  #define true 1 false 0
    my @search_strings= split(/ /, $str_search); #split each word in a phrase

    
    while (<$fh>) {
        chop($_); #get rid of \n
        #search the line for each word in search string
        foreach my $str_match (@search_strings) {
            #look for exact match or word plus X g = global i= case insensitive
                if ($_=~ /[^A-Za-z]$str_match/gi) {
                    if (!$found) {
                        $search_hits{$file}= 0; #hit found in file start count.
                        $found= 1;
                    }
                    $search_hits{$file}++; #increment number of hits
                } #if
        }#foreach
    }#while
} ##searchFileAny
############################################################################
################### searchFileAll ##########################################
sub searchFileAll() {
# accepts the file handle and the file name
# searches the file line by line for a match and counts the hits for all
# search words

    my ($fh, $file)= @_;
    #find search for exact for any of the words
    my @matches_found= (); #used for matching each search string
    my $match_count= 0;
    my $found= 1; #define true 1 false 0
    my @search_strings= split(/ /, $str_search); #split each word into an array

    foreach (@search_strings) { 
	push(@matches_found, 0); 
    } 

    while (<$fh>) {
        chop($_); #get rid of \n
        #look for exact match or word plus X or X plus word g = global
        for (my $i=0; $i <= $#search_strings; $i++) {
            #look for exact match or word plus X g = global i= case insensitive
            if ($_ =~ /[^A-Za-z]$search_strings[$i]/gi) {
                ++$matches_found[$i];
            }
        }
    }#while
    foreach (@matches_found) {
        if ($_ != 0) {
            $match_count+= $_; #add total matches for each word
        }
        else {
            $found= 0;
        }
    }
    if ($found) {
        $search_hits{$file}= $match_count; #hit found in file start count.
    }
} ##searchFileAll
############################################################################
############### showResults ################################################
sub showResults {
#prints out the results of the search and sorts the hash by number of hits
    print("<CENTER><TABLE BORDER= 5 CELLSPACING=2 CELLPADDING=2
WIDTH=80%>\n".
	  "<TR><TH bgColor='#006600'align='middle'>\n".
	  "<font size=+2 color='#FFFFFF'>URLs Below Matching
$str_search</font>\n</TH></TR>\n");
    if (keys %search_hits != 0) {
        #print results only is search_hits is NOT empty
        #sorts the hash by value in decending order
        #the $a and $b are packaged globals used for comparison
        foreach $_ (sort { $search_hits{$b} <=> $search_hits{$a} } keys %search_hits) {
            print("<TR><TD align='middle'><a href='$main_site$_'>$main_site$_</a>".
                      "&nbsp;&nbsp;&nbsp;&nbsp;($search_hits{$_} matche(s)) </TD></TR>");
        }
    }
    else {
        print("<TR><TD align='middle'><font size=+1 color='red'>".
	      "Sorry... your search did not return any results</font></TD></TR>\n");
    }
    print"</TABLE></CENTER><BR>";
} ##showResults
############################################################################
