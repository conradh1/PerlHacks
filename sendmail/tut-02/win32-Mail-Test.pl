#!perl -w
#
# Name:
#	win32-Mail-Test.pl.
#
# Version
#	1.00	1-Nov-1999
#
# Author:
#	Ron Savage <ron@savage.net.au>
#	http://savage.net.au/index.html
#
# Licence:
#	Australian Copyright (c) 1999-2002 Ron Savage.
#
#	All Programs of mine are 'OSI Certified Open Source Software';
#	you can redistribute them and/or modify them under the terms of
#	The Artistic License, a copy of which is available at:
#	http://www.opensource.org/licenses/index.html

use strict;

use Config;

BEGIN
{
	require 'win32-Mail-Lib.pl' if ($Config{'osname'} eq 'MSWin32');
}

# -----------------------------------------------------------------

my($smtp, $from)	= &getSMTPFrom();
my($profile)		= &getProfile();

print "SMTP:    $smtp \n";
print "From:    $from \n";
print "Profile: $profile \n";

# Success.
print "Success \n";
exit(0);
