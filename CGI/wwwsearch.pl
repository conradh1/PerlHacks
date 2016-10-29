#!/usr/bin/perl
####################################################################
# find.cgi  Search WWWBoard Articles
# Created by Craig Horton       (chorton@dbasic.com)
# Contributions by Matt Wright  (mattw@misha.net)
# Created on:  5/4/96
# I can be reached at:          chorton@dbasic.com
# Script Found at:              http://www.dbasic.com/scripts/
# This script may be redistributed for non-commericial reasons
# as long as this header remains intact. All copyrights reserved.
####################################################################

# Define Variables
$basedir = "/usr/local/etc/httpd/htdocs/html/server/wwwboard/" . $ENV{'QUERY_STRING'};
$baseurl = "http://www.athabascau.ca/html/server/wwwboard/" . $ENV{'QUERY_STRING'};
$mesgdir = "messages";
$ext = "htm";

# This is the listing of directory/files to search.
@files = ("$basedir/$mesgdir/*.$ext");

# Print out a content-type for HTTP/1.0 compatibility
print "Content-type: text/html\n\n";

# Get the input
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

   $FORM{$name} = $value;
}

print "<Head><Title>WWWBoard Simple Search</Title></Head><Body>\n";
print "<h2><center>Search Results for \"$FORM{'query'}\"</center></H2>\n";
print "<HR>\n";

# This routine loads all files designated in @files into the array @FILES
foreach $file (@files) {
   $ls = `ls $file`;
   @ls = split(/\s+/,$ls);
   foreach $filename (@ls) {
     push(@FILES,$filename);
   }
}

print "<OL>\n";

# This routine acts on each file loaded into the @FILES
foreach $FILE (@FILES) {
   open(FILE,"$FILE");
   @LINES = <FILE>;
   close(FILE);
   $url = '';
   $detail = '';
   foreach $line (@LINES) {
     if ($line =~ "<TITLE>") {
       $lpos = (index($line,"<T") + 7);
       $rpos = (rindex($line,"/T"));
       $detail = substr($line,$lpos,($rpos-$lpos)-1);
     }
     if ($line =~ "<title>") {
       $lpos = (index($line,"<t") + 7);
       $rpos = (rindex($line,"/t"));
       $detail = substr($line,$lpos,($rpos-$lpos)-1);
     }
     if ($line =~ /$FORM{'query'}/i && $line !~ /http/i) {
       $lpos = (rindex($FILE,"/"));
       $url = "$baseurl/$mesgdir".substr($FILE,$lpos);
       #print "<xmp>$line</xmp>\n";
       #print "$url\n";
       last;
     }
   }
   if ($url ne '') {
     print "<LI><a href=\"$url\"><b>$detail</b></A>\n";
   }
}
print "</OL><HR>\n";
print "</body></html>\n";
exit;
