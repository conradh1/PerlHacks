#!perl -w
#
# Name:
#	Mail-MAPI-Demo.pl.
#
# Parameter:
#	The 'To' address. Eg: ron@savage.net.au.
#
# Version
#	1.00	1-Nov-1999
#
# Author:
#	Hernán Sánchez <hsanchez@suratep.com.co>
#	Analista de Telecomunicaciones
#	SURATEP
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

require 'win32-Mail-Lib.pl';

# --------------------------------------------------------------------------

my($to)				= shift || die("Usage $0 <To address>\n");
my($defaultProfile) = &getProfile();

die('DefaultProfile not available') if (! $defaultProfile);

############################################################################
### Sender's Name and Password...
### Must be exactly like your Outlook profile name (Spaces and all)...
############################################################################

my($sender) = $defaultProfile;
my($passwd) = '';

############################################################################
### Create a new MAPI Session...
############################################################################

use Win32::OLE qw(in with);
use Win32::OLE::Variant;

############################################################################
### Co-Initialize the OLE Session...
############################################################################

Win32::OLE->Initialize(Win32::OLE::COINIT_OLEINITIALIZE);

############################################################################
### Log on to the Exchange server....
############################################################################

my($session) = Win32::OLE->new("MAPI.Session")
or die "Could not create a new MAPI Session: $! " .
Win32::OLE->LastError(0);
my $err = $session->Logon($sender, $passwd);
if ($err) {die "Logon failed: $!";}

############################################################################
### Add a new message to the Outbox.
############################################################################

my($msg) = $session->Outbox->Messages->Add();

############################################################################
### Add the recipient. This can be put into a loop to add a list of recipients...
############################################################################
### {Type} = 0 Sender:
### {Type} = 1 To:
### {Type} = 2 CC:
### {Type} = 3 BCC:
############################################################################

# HKEY_CURRENT_USER/Software/Microsoft/Office/8.0/Outlook/AutoNameCheck/ NicknamePath/

my($rcpt) = $msg->Recipients->Add();
$rcpt->{Name} = $to;
$rcpt->{Type} = 1;

$msg->{Sensitivity} = 2;

############################################################################
### Sensitivity
### 0 = Normal
### 1 = Personal
### 2 = Private
### 3 = Confidential
############################################################################

$msg->{Importance} = 2;

############################################################################
### Importance
### 0 = Low
### 1 = Normal
### 2 = High
############################################################################

$rcpt->Resolve();

############################################################################
### Create a subject and a body...
############################################################################

$msg->{Subject} = 'Mail-MAPI-Demo.pl';
$msg->{Text} = <<EOF;

Mail-MAPI-Demo.pl

EOF

############################################################################
### Send the message and log off.
############################################################################

$msg->Update();
$msg->Send(0, 0, 0);
$session->Logoff();

############################################################################
### End of Script...
############################################################################

# Success.
print "Success \n";
exit(0);
