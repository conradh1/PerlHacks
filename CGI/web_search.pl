#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Program Name: web_search.pl
# Author: Conrad Holmberg
# Created: 07/22/02
# Last Modified: 07/24/02
# This program is for employers searches a web directory and
# shows the URL for matched files
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use CGI qw/:standard :cgi/;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);
use FileHandle;
use File::Find;
use DirHandle; #used for opening directories
use Time::localtime; #module for getting the current time and date


#global variables
my $cgi= CGI::new(); #used for obtaining information from html pages
my $keywords= $cgi->param('keywords'); #gets the search string
my $search_type= $cgi->param('search_type');
$keywords=~ s/\s\s+/ /gi; #replace extra spaces with one
$keywords=~ s/\s$//gi; #get rid of trailing space
$keywords=~ s/[^a-zA-z0-9\'\"\s\.]//gi; #get rid of any special unwanted characters
my %search_hits; #hash where the index name is a file and the value is the number of search hits
my $html_dir= $ENV{'DOCUMENT_ROOT'}; #web dir path
my $main_site= "http://".$ENV{'SERVER_NAME'}; #url dir for applicants
my $search_site= "http://".$ENV{'SERVER_NAME'}."tests/web_search.html";
my @search_files; #array for storing all searchable files
$| = 1; #remove buffering
###################Start Program############################################
############################################################################
htmlHeader();

if (defined($keywords) && $keywords ne "") {
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
     print("<html><head><title>Search Results</title></head>\n".
           "<BODY BGCOLOR='#DDDDDD' TEXT='000000'>\n".
           "<h1 align= 'center'>".$ENV{'SERVER_NAME'}." Search Results</h1>\n");

} #htmlHeader
############################################################################
#################### htmlFooter ############################################
sub htmlFooter {
#this subroutine prints the html bottom
     print("<hr></body></html>");
} #htmlFooter
############################################################################
#################### startSearch ###########################################
sub startSearch {
#opens the html_dir directory value and assigns the values to dir_files
#then a call is made to searchFiles to obtain files with a html extension
	#find sub { push(@search_files,$File::Find::name) }, $html_dir;
	find(\&getWebFiles, $html_dir);

	sub getWebFiles() {
    		#search for X.html, X.htm, and X.XML then assign to search_files
        	if ($File::Find::name=~ /\w+(?=.html)/ || $File::Find::name=~ /\w+(?=.htm)/ || $File::Find::name=~ /\w+(?=.xml)/) {
			push(@search_files, $File::Find::name); #push file name with absolute path
		}
    	} #getWebFiles
	for (my $i=0; $i <= $#search_files; $i++) {
        	open(HANDLE,$search_files[$i]) || die "\n $0 Cannot open $!\n";
		if ($search_type eq "exact") {
            		searchFileExact(\*HANDLE,$search_files[$i]); #search and match all words
        	}
        	elsif ($search_type eq "any") {
            		searchFileAny(\*HANDLE,$search_files[$i]); #search for any word or phrase
        	}
        	elsif ($search_type eq "all") {
            		searchFileAll(\*HANDLE,$search_files[$i]); #search and match all words
        	}
        	close(HANDLE);
    	} #foreach

} ##startSearch
############################################################################
###############  searchFileExact  ############################################
sub searchFileExact() {
#accepts the file handle and the file name
#searches the file line by line for an exact match from the keywords
    my ($fh, $file)= @_;
    my $url= "";
    #find search for exact for any of the words
    my $found= 0;  #define true 1 false 0

    while (<$fh>) {
	chop($_); #get rid of \n
 	#look for exact match or word plus X g = global i= case insensitive
	if ($_=~ /$keywords/gi) {
        	if (!$found) {
		    	$url= $file;
			$url=~ s/$html_dir/$main_site/gi; #replace actual path with virtual path
                        $search_hits{$url}= 0; #hit found in file start count.
                        $found= 1;
                    }
                    $search_hits{$url}++; #increment number of hits
   	} #if

    }#while
} ##searchFileExact
############################################################################
###############  searchFileAny  ############################################
sub searchFileAny() {
#accepts the file handle and the file name
#searches the file line by line for a any match from the keywords
    my ($fh, $file)= @_;
    my $url= "";
    #find search for exact for any of the words
    my $found= 0;  #define true 1 false 0
    my @search_strings= split(/ /, $keywords); #split each word in a phrase

    while (<$fh>) {
        chop($_); #get rid of \n
        #search the line for each word in search string
        foreach my $str_match (@search_strings) {
            #look for exact match or word plus X g = global i= case insensitive
                if ($_=~ /$str_match/gi) {
                    if (!$found) {
		    	$url= $file;
			$url=~ s/$html_dir/$main_site/gi; #replace actual path with virtual path
                        $search_hits{$url}= 0; #hit found in file start count.
                        $found= 1;
                    }
                    $search_hits{$url}++; #increment number of hits
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
    my $url= "";
    my @matches_found= (); #used for matching each search string
    my $match_count= 0;
    my $found= 1; #define true 1 false 0
    my @search_strings= split(/ /, $keywords); #split each word into an array

    foreach (@search_strings) {
	push(@matches_found, 0);
    }

    while (<$fh>) {
        chop($_); #get rid of \n
        #look for exact match or word plus X or X plus word g = global
        for (my $i=0; $i <= $#search_strings; $i++) {
            #look for exact match or word plus X g = global i= case insensitive
            if ($_ =~ /$search_strings[$i]/gi) {
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
	$url= $file;
	$url=~ s/$html_dir/$main_site/gi; #replace actual path with virtual path
        $search_hits{$url}= $match_count; #hit found in file start count.
    }
} ##searchFileAll
############################################################################
############### showResults ################################################
sub showResults {
#prints out the results of the search and sorts the hash by number of hits
    print("<CENTER><TABLE BORDER= 5 CELLSPACING=2 CELLPADDING=2 WIDTH='640'".
	  "BGCOLOR='#DDDDDD' NOSAVE>\n".
	  "<TR><TH bgColor='#ccccff'align='middle'>\n".
	  "<font size=+2>Search Results Below for $keywords</font>\n</TH></TR>\n");
    if (keys %search_hits != 0) {
        #print results only is search_hits is NOT empty
        #sorts the hash by value in decending order
        #the $a and $b are packaged globals used for comparison
        foreach $_ (sort { $search_hits{$b} <=> $search_hits{$a} } keys %search_hits) {
            print("<TR><TD align='middle'><a href='$_'>$_</a>".
                      "&nbsp;&nbsp;&nbsp;&nbsp;($search_hits{$_} match(es)) </TD></TR>");
        }
    }
    else {
        print("<TR><TD align='middle'><font size=+1 color='red'>".
	      "Sorry... your search did not return any results</font></TD></TR>\n");
    }
    print"</TABLE></CENTER><BR>";
} ##showResults
############################################################################
