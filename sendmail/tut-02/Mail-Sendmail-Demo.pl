#!perl -w
#
# Name:
#	Mail-Sendmail-Demo.pl.
#
# Parameter:
#	The 'To' address. Eg: ron@savage.net.au.
#
# Note:
#	Mail::Sendmail does not require MS Windows.
#	I've only used MS Windows to set $smtp and $from.
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

use Mail::Sendmail;

use Config;

BEGIN
{
	require 'win32-Mail-Lib.pl' if ($Config{'osname'} eq 'MSWin32');
}

# ----------------------------------------------------------

my($to) = shift || die("Usage $0 <To address>\n");

my($smtp, $from);

if ($Config{'osname'} eq 'MSWin32')
{
	($smtp, $from) = &getSMTPFrom();
}
else
{
	($smtp, $from) = ('milky.way.com', 'ron@savage.net.au');
}

die('SMTP server name not found') if (! $smtp);
die('Sender name not found') if (! $from);

my(%mail) =
(
	SMTP	=> $smtp,
	To		=> $to,
	From	=> $from,
	Subject	=> 'Mail-Sendmail-Demo.pl',
	Message	=> 'Mail-Sendmail-Demo.pl',
);

sendmail(%mail) || die($Mail::Sendmail::error);
print "OK. Log says:\n", $Mail::Sendmail::log;

# Success.
print "Success \n";
exit(0);
