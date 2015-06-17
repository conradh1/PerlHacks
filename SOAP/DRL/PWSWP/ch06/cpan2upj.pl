#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;
use File::Basename 'basename';
use Getopt::Std;
use Digest::MD5    'md5_hex';
use HTTP::Cookies;
use SOAP::Lite;

my (%opts, $user, $title, $discuss, $body, $host, $uri,
    $proxy, $file, $name, $cookie_file, $cookie_jar,
    $journal, $result);

getopts('C:c', \%opts) or die <<"USAGE";
Usage: $0 [ -c ] [ -C user:pass ]

-c              Allow comments on journal entry
-C user:pass    Provide authentication in place of (or in
                absence of) Netscape cookies. User in
                this case is UID, not nickname.
USAGE

while (defined($_ = <STDIN>)) {
    $file = $1, last if /^\s+file:\s+(\S+)/;
}
die "$0: No filename found in input, stopped" unless $file;
$name = basename $file;
$file =~ s|^\$CPAN|http://www.cpan.org|;

$user    = (getpwuid($<))[0];
$title   = "$name uploaded to PAUSE";
$discuss = $opts{c} ? 1 : 0;
$body = << "BODY";
<p>The file <tt>$name</tt> has been uploaded to CPAN, and
will soon be accessible as <a href="$file">$file</a>.
Mirroring may take up to 24 hours.</p>
<p><i>$0, on behalf of $user</i></p>
BODY

$host        = 'use.perl.org';
$uri         = "http://$host/Slash/Journal/SOAP";
$proxy       = "http://$host/journal.pl";
# Note that this path is UNIX-centric. Consider using
# File::Spec methods in most cases.
$cookie_file = "$ENV{HOME}/.netscape/cookies";

if ($opts{C}) {
    $cookie_jar = HTTP::Cookies->new
      ->set_cookie(0,
                   user => make_cookie(split /:/, $opts{C}),
                   '/', $host);
} elsif (-f $cookie_file) {
    $cookie_jar = HTTP::Cookies::Netscape->new(File => $cookie_file);
} else {
    die "$0: No authentication data found, cannot continue";
}

$journal = SOAP::Lite->uri($uri)
             ->proxy($proxy, cookie_jar => $cookie_jar);
die "$0: Error creating SOAP::Lite client, cannot continue"
    unless $journal;
$result = $journal->add_entry(subject => $title,
                              body    => $body,
                              discuss => $discuss);

if ($result->fault) {
    die "$0: Failed: " . $result->faultstring . "\n";
} else {
    printf "New entry added as %s\n", $result->result;
}

exit;

# Taken from the Slash codebase
sub make_cookie {
    my ($uid, $passwd) = @_;
    my $cookie = $uid . '::' . md5_hex($passwd);
    $cookie =~ s/(.)/sprintf("%%%02x", ord($1))/ge;
    $cookie =~ s/%/%25/g;
    $cookie;
}

