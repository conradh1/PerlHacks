#!/usr/local/bin/perl -- -*-perl-*-

#parse_html.pl
#This is a perl program that parses html tags
use strict;
use FileHandle;
use HTML::Parser ();

##############################################
#print "Enter name of html file with questionnaire form: ";
#my $questionnaire= <STDIN>;
#chop($questionnaire);
my $questionnaire= "test.html";

#print "Enter name of total log file: ";
#my $file= <STDIN>;
#chop($file);

#my $fh = new FileHandle;
#$fh->open($file, "r") || die "\n $0 Cannot open $!\n";

#while (<$fh>) {
  #      print($_);
#}
#$fh->close;

sub start_handler {
return if shift ne "title";
my $self = shift;
$self->handler(text => sub { print shift }, "dtext");
$self->handler(end  => sub { shift->eof if shift eq "title"; },"tagname,self");
}
my $p = HTML::Parser->new(api_version => 3);
$p->handler( start => \&start_handler, "tagname,self");
$p->parse_file($questionnaire) || die $!;
print "\n";
exit 0;
#end program
