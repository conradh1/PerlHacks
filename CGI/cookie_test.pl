#!/usr/local/bin/perl
################################################################################
$VERSION="cookietest.pl v1.1"; #Aug. 18, 1996 Dale Bewley <dlbewley@iupui.edu>
# v1.0 29 June 96, v0.9 14 May 96
#-------------------------------------------------------------------------------
# This script and others found at http://www.bewley.net/perl/
#
# Simple cookie demo.
# For more info see:
#       http://www.bewley.net/perl/cookie-test.html
#
################################################################################

#- User configurable variables ------------------------------------------------#
#ftp://ftp.ind.net/pub/nic/rfc/rfc822.txt Section 5.1
$expDate = "09-Nov-00 00:00:00 GMT";
#set this to your domain prepended with a .
$domain = ".bewley.net";
$path = "/cgi-bin/";
#------------------------------------------------------------------------------#


#- Main Program ---------------------------------------------------------------#
&setCookie("user", "dbewley",  $expDate, $path, $domain);
&setCookie("user_addr", $ENV{'REMOTE_HOST'},  $expDate, $path, $domain);
&setCookie("flag", "black",  $expDate, "/cgi-bin/", ".iupui.edu");
&setCookie("car", "honda:accord:88:LXI:green",  $expDate, "/cgi-bin/",
           $domain);

# be sure to print a MIM type AFTER cookie headers and follow with a blank line
print "Content-type: text/html\n\n";

# this is the first thing the user sees in the browser
print "\nReload for Cookies:<BR>";
%cookies = &getCookies; # store cookies in %cookies

foreach $name (keys %cookies) {
        print "\n$name = $cookies{$name}<br>";
}
#------------------------------------------------------------------------------#


#- Set Cookie -----------------------------------------------------------------#
sub setCookie {
        # end a set-cookie header with the word secure and the cookie will only
        # be sent through secure connections
        local($name, $value, $expiration, $path, $domain, $secure) = @_;

        print "Set-Cookie: ";
        print ($name, "=", $value, "; expires=", $expiration,
                "; path=", $path, "; domain=", $domain, "; ", $secure, "\n");
}
#------------------------------------------------------------------------------#


#- Retrieve Cookies From ENV --------------------------------------------------#
sub getCookies {
        # cookies are seperated by a semicolon and a space, this will split
        # them and return a hash of cookies
        local(@rawCookies) = split (/; /,$ENV{'HTTP_COOKIE'});
        local(%cookies);

        foreach(@rawCookies){
            ($key, $val) = split (/=/,$_);
            $cookies{$key} = $val;
        }

        return %cookies;
}
#------------------------------------------------------------------------------#