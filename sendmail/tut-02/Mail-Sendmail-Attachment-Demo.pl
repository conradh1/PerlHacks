#!perl -w
#
# Name:
#	Mail-Sendmail-Attachment-Demo.pl.
#
# Parameters:
#	1 The 'To' address. Eg: ron@savage.net.au.
#	2 The name of the file to attach. Eg: C:/Temp/file.txt.
#
# Note:
#	Mail::Sendmail does not require MS Windows.
#	I've only used MS Windows to set $smtp and $from.
#
# Reference:
#	http://alma.ch/perl/Mail-Sendmail-FAQ.htm.
#
# Version
#	1.00	1-Nov-1999
#
# Author:
#	Milivoj Ivkovic <mi@alma.ch>
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

use MIME::QuotedPrint;
use MIME::Base64;
use Mail::Sendmail 0.75; # doesn't work with v. 0.74!

use Config;

BEGIN
{
	require 'win32-Mail-Lib.pl' if ($Config{'osname'} eq 'MSWin32');
}

# -----------------------------------------------------------------

my($to)			= shift || die("Usage: $0 <To> <AttachmentFileName>\n");
my($fileName)	= shift || die("Usage: $0 <To> <AttachmentFileName>\n");

my($smtp, $from);

if ($Config{'osname'} eq 'MSWin32')
{
	($smtp, $from) = &getSMTPFrom();
}
else
{
	($smtp, $from) = ('aufrl.pdf', 'conradh@athabascau.ca');
}

die('SMTP server name not found') if (! $smtp);
die('Sender name not found') if (! $from);

my(%mail)		=
(
	SMTP	=> $smtp,
	From	=> $from,
	To		=> $to,
	Subject	=> "Mail-Sendmail-Attachment-Demo.pl",
);

my($boundary) = "====" . time() . "====";
$mail{'content-type'} = qq|multipart/mixed; boundary="$boundary"|;

my($message) = encode_qp("$fileName is attached");

open(F, $fileName) or die("Cannot read $fileName: $!\n");
binmode F;
{
	undef $/;
	$mail{body} = encode_base64(<F>);
}
close F;

$boundary = '--'.$boundary;
$mail{body} = <<END_OF_BODY;
$boundary
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

$message
$boundary
Content-Type: application/octet-stream; name="$fileName"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="$fileName"

$mail{body}
$boundary--
END_OF_BODY

sendmail(%mail) || die("Error: $Mail::Sendmail::error\n");
print "OK. Log says:\n", $Mail::Sendmail::log;

# Success.
print "Success \n";
exit(0);
