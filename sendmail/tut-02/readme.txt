# Name:
#	readme.txt
#
# Author:
#	Ron Savage <ron@savage.net.au>
#
# Home:
#	http://savage.net.au/Perl-tutorials.html#tut-2

Files
-----
o	Mail-MAPI-Demo.pl used to work under MS Windows.

o	Mail-Sender-Demo.pl uses Mail::Sender. It has been tested under Unix and
	WinNT and Win95. The tests used V 0.6.7 of Mail::Sender.

o	Mail-Sendmail-Attachment-Demo.pl uses Mail::Sendmail. It has been tested
	under Unix and WinNT and Win95. The tests used V 0.77 of Mail::Sendmail.
	Big hint: Attach files in the current directory. Files in other directories
	will work, but names like C:\Temp\x.txt will be listed as CTempx.txt.
	C:/Temp/x.txt will be treated in the same way.

o	Mail-Sendmail-Demo.pl uses Mail::Sendmail. It has been tested under Unix
	and WinNT and Win95. The tests used V 0.77 of Mail::Sendmail

o	win32-Mail-Lib.pl. Under Windows, the above 4 programs use win32-Mail-Lib.pl
	to determine the names of the SMTP server and of the sender.
	Obviously, under Unix you must use other methods to determine these.

o	win32-Mail-Test.pl. win32-Mail-Test.pl simply tests win32-Mail-Lib.pl.