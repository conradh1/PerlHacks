# Name:
#	win32-Mail-Lib.pl.
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

# Can't use strict;

use Carp;
use Win32::TieRegistry(Delimiter => '/', ArrayValues => 0);

# -----------------------------------------------------------------------

sub getProfile
{
	my($keyPrefix)		= 'HKEY_CURRENT_USER/Software/Microsoft/Windows NT/CurrentVersion/Windows Messaging Subsystem/Profiles/';
	my($key)			= $Registry -> {$keyPrefix}	|| croak("Can't read key $keyPrefix: $^E\n");

	$$key{'DefaultProfile'};

}	# End of getProfile.

# -----------------------------------------------------------------------

sub getSMTPFrom
{
	# Win95 key.
	my($keyPrefix) = 'HKEY_USERS/.Default/Software/Microsoft/Internet Mail and News/Mail/';
	my($key, $smtp, $from);

	if (defined($Registry -> {$keyPrefix}) )
	{
		$key	= $Registry -> {$keyPrefix};
		$smtp 	= $$key{'Default SMTP Server'};
		$from	= $$key{'Sender EMail'};
	}
	else
	{
		# WinNT key.
		undef $keyPrefix;
		$keyPrefix = 'HKEY_CURRENT_USER/Software/Microsoft/Internet Account Manager/Accounts/';

		if (defined($Registry -> {$keyPrefix}) )
		{
			$key = $Registry -> {$keyPrefix};

			my(@smtp, @from);

			for (sort(keys(%$key) ) )
			{
				my($key2);

				for $key2 (%{$$key{$_} })
				{
					next if (! defined(${$$key{$_} }{$key2}) );
					push(@smtp, ${$$key{$_} }{$key2}) if ($key2 eq '/SMTP Server');
					push(@from, ${$$key{$_} }{$key2}) if ($key2 eq '/SMTP Email Address');
				}
			}

			# Grab the first, if any.
			$smtp = ($#smtp >= 0) ? $smtp[0] : undef;
			$from = ($#from >= 0) ? $from[0] : undef;
		}
	}

	($smtp, $from);

}	# End of getSMTPFrom.

# -----------------------------------------------------------------------

1;
