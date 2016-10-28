#!/usr/local/bin/perl -- -*-perl-*-

open FILE, "logo.png" or die $!;
binmode FILE;

my ($buf, $data, $n, $offset,$length);

$offset = 0; # byte position on the line
$length = 1; # number of bytes to read
while (($n = read FILE, $data, $length, $offset) != 0) {
  print "$data\n";
  $buf .= $data;
  $length++;
  #$offset += $n;
}
close(FILE);