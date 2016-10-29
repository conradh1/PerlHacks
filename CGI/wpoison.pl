#!/usr/bin/perl -w

# wpoison.pl - Version 1.8p
#
# For usage instructions see http://www.monkeys.com/wpoison/
#
# Original idea by Ronald F. Guilmette <rfg@monkeys.com>
# Code implemented by Ronald F. Guilmette <rfg@monkeys.com>
#
# Copyright (c) 2000,2001 Ronald F. Guilmette; All rights reserved.
#
# Redistribution and use in source form ONLY, with or without modification,
# is permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# 2. All advertising materials mentioning features or use of this software
#     must display the following acknowledgement:
#      This product includes software developed by Ronald F. Guilmette.
# 3. Neither the name of Ronald F. Guilmette nor the names of other con-
#     tributors to this software may be used to endorse or promote products
#     derived from this software without specific prior written permission.
# 4. Either a copy of, or a link to the official Wpoison logo graphic (which
#     may be found at http://www.monkeys.com/wpoison/logo.gif) must be
#     included in, and clearly and legibly visible on the home page of any
#     web site which uses, employs, includes, or makes reference to this
#     software or any derivative or modified version thereof.  Also, the
#     official Wpoison logo itself must be include in an HTML hyperlink
#     so that any usser clicking on any part of the logo image will be
#     directed/linked to the Wpoison home page at:
#
#	http://www.monkeys.com/wpoison/
#
#     In order to satisfy this requirement, you may simply include the
#     following HTML code somewhere (anywhere) on your web site home page:
#
#	<A HREF="http://www.monkeys.com/wpoison/">
#		<IMG SRC="http://www.monkeys.com/wpoison/logo.gif">
#	</A>
#
# Disclaimer
# ----------
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

use strict;
use FileHandle;
use POSIX;
use vars qw($pname $tmp_words_file $num_cached_randwords @randwords @tl_domains_1 @tl_domains_2);

$pname="wpoison";
$tmp_words_file = "/tmp/wpoison.words";
$num_cached_randwords = 4096;
my $creation_time;
my $age_in_seconds;
my $email_addr;
my $num_addresses;
my $num_links;
my $script_name = getenv ("SCRIPT_NAME") || $0;

@tl_domains_1 = (
  "com", "com", "com", "com",
  "net", "net", "net",
  "org", "org",
  "edu", "edu",
  "gov",
  "mil",
  "int");

@tl_domains_2 = (
  "uk", "su",
  "af", "al", "dz", "as", "ad", "ao", "ai", "aq", "ag", "ar", "am", "aw", "au",
  "at", "az", "bs", "bh", "bd", "bb", "by", "be", "bz", "bj", "bm", "bt", "bo",
  "ba", "bw", "bv", "br", "io", "bn", "bg", "bf", "bi", "kh", "cm", "ca", "cv",
  "ky", "cf", "td", "cl", "cn", "cx", "cc", "co", "km", "cg", "ck", "cr", "ci",
  "hr", "cu", "cy", "cz", "dk", "dj", "dm", "do", "tp", "ec", "eg", "sv", "gq",
  "er", "ee", "et", "fk", "fo", "fj", "fi", "fr", "fx", "gf", "pf", "tf", "ga",
  "gm", "ge", "de", "gh", "gi", "gr", "gl", "gd", "gp", "gu", "gt", "gn", "gw",
  "gy", "ht", "hm", "hn", "hk", "hu", "is", "in", "id", "ir", "iq", "ie", "il",
  "it", "jm", "jp", "jo", "kz", "ke", "ki", "kp", "kr", "kw", "kg", "la", "lv",
  "lb", "ls", "lr", "ly", "li", "lt", "lu", "mo", "mk", "mg", "mw", "my", "mv",
  "ml", "mt", "mh", "mq", "mr", "mu", "yt", "mx", "fm", "md", "mc", "mn", "ms",
  "ma", "mz", "mm", "na", "nr", "np", "nl", "an", "nc", "nz", "ni", "ne", "ng",
  "nu", "nf", "mp", "no", "om", "pk", "pw", "pa", "pg", "py", "pe", "ph", "pn",
  "pl", "pt", "pr", "qa", "re", "ro", "ru", "rw", "kn", "lc", "vc", "ws", "sm",
  "st", "sa", "sn", "sc", "sl", "sg", "sk", "si", "sb", "so", "za", "gs", "es",
  "lk", "sh", "pm", "sd", "sr", "sj", "sz", "se", "ch", "sy", "tw", "tj", "tz",
  "th", "tg", "tk", "to", "tt", "tn", "tr", "tm", "tc", "tv", "ug", "ua", "ae",
  "gb", "us", "um", "uy", "uz", "vu", "va", "ve", "vn", "vg", "vi", "wf", "eh",
  "ye", "yu", "zr", "zm", "zw");

sub
death
{
  my ($message) = @_;

  print STDOUT ("Content-Type: text/html\n",
		"\n",
		"<HTML>\n",
		"<HEAD><TITLE>WPOISON - Unexpected Error</TITLE></HEAD>\n",
		"<BODY BGCOLOR=\"white\" TEXT=\"#c00000\"><BIG><BIG>\n");

  print "$pname: $message\n";

  print ("</BIG></BIG></BODY>\n</HTML>\n");
  exit 0;
}

sub
gen_new_random_words_list
{
  my $dictfile;
  my $total_words;
  my @words;
  my %already_taken;

  if (-f $tmp_words_file) {
    if (not unlink ($tmp_words_file)) {
      death ("Error unlinking file \`$tmp_words_file\': $!");
    }
  }

  if ( -f "/usr/dict/words") {
    $dictfile = "/usr/dict/words";
  } elsif (-f "/usr/share/dict/words") {
    $dictfile = "/usr/share/dict/words"
  } elsif (-f "words") {
    $dictfile = "words";
  } else {
    death ("Cannot find dictionary file!");
  }

  death ("Error opening dictionary file \`$dictfile\': $!")
    unless (open (DICTFILE, "<$dictfile"));

  $total_words = 0;
  while (<DICTFILE>) {
    chop;
    push @words, $_;
    $total_words++;
  }

  close DICTFILE;

  death ("Error opening tmp words file \`$tmp_words_file\': $!")
    unless (open (RWORDS, ">$tmp_words_file"));

# We will now pick $num_cached_randwords words at random

  srand;

  for (1..$num_cached_randwords) {
  try_again:
    my $rand_index = int (rand $total_words);

    goto try_again if (defined $already_taken{$rand_index});
    $already_taken{$rand_index} = 1;
    print RWORDS "$words[$rand_index]\n";
  }

  close RWORDS;
}

sub
read_random_words
{
  death ("Error opening tmp words file \`$tmp_words_file\': $!")
    unless (open (RWORDS, "<$tmp_words_file"));

  chop(@randwords = <RWORDS>);

  close RWORDS;
}

sub
random_word
{
  my $word_index;

  $word_index = int (rand $num_cached_randwords);
  return $randwords[$word_index];
}

sub
gen_random_words
{
  my ($min_words, $max_words) = @_;
  my $num_words;
  my $word_index;
  my $i;

  $num_words = $min_words + (rand ($max_words - $min_words));
  for $i (1..$num_words) {
    $word_index = int (rand $num_cached_randwords);
    print $randwords[$word_index];
    print " " if ($i < $num_words);
  }
}

sub
gen_random_color
{
  my $red_code = int (rand 256);
  my $green_code = int (rand 256);
  my $blue_code = int (rand 256);

  printf "#%02x%02x%02x", $red_code, $green_code, $blue_code;
}

sub
random_letter
{
  return chr (unpack ("%c", 'a') + int (rand 26));
}

sub
random_domain
{
  my $rindex;

  if (int (rand 4) == 0) {
    $rindex = int (rand ($#tl_domains_2 + 1));
    return $tl_domains_2[$rindex];
  } else {
    $rindex = int (rand ($#tl_domains_1 + 1));
    return $tl_domains_1[$rindex];
  }
}

autoflush STDOUT 1;

if (not -r $tmp_words_file) {
  gen_new_random_words_list ();
} else {
  $creation_time = (stat $tmp_words_file)[9];
  $age_in_seconds = time - $creation_time;
  gen_new_random_words_list () if ($age_in_seconds > (30 * 60));
}

read_random_words ();

print STDOUT ("Content-Type: text/html\n",
		"\n",
		"<HTML>\n",
		"<HEAD>\n",
		"<TITLE>");

gen_random_words (2, 6);

print STDOUT ("</TITLE>\n",
		"<META NAME=\"ROBOTS\" CONTENT=\"NOINDEX, NOFOLLOW\">\n",
		"</HEAD>\n",
		"<BODY BGCOLOR=\"");
gen_random_color ();
print ("\" TEXT=\"");
gen_random_color ();
print ("\" LINK=\"");
gen_random_color ();
print ("\" VLINK=\"");
gen_random_color ();
print ("\">\n", "<BIG>\n");

gen_random_words (10, 30);
print ("<P>\n");

$num_addresses = 2 + int (rand 16);
for (1..$num_addresses) {
  $email_addr = random_word ();
  $email_addr .= "@";
  if (int (rand 4) == 0) {
    $email_addr .= random_word () . ".";
  }
  $email_addr .= random_word () . random_letter () . "." . random_domain ();
  print "<A HREF=\"mailto:$email_addr\">$email_addr</A><BR>\n";
}

print ("<P>\n");
gen_random_words (2, 20);
print ("<P>\n");

$num_links = 1 + int (rand 16);
for (1..$num_links) {
  print "<A HREF=\"";
  print $script_name;
  print "/";
  print (random_word ());
  print ("\">");
  gen_random_words (1, 9);
  print ("</A><BR>\n");
}

print ("<P>\n");

gen_random_words (2, 20);

# Sleep for four seconds when finishing each page to avoid server overload.

sleep (4);

print ("</BIG>\n</BODY>\n</HTML>\n");

exit 0;
