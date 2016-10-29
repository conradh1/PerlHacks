#!/usr/local/bin/perl -- -*-perl-*-

#parse_html.pl
#This is a perl program that parses html tags
use FileHandle;
use HTML::Parser ();
use HTML::FormParser;
use HTML::Form;
##############################################
my $html= "";
my $fh = new FileHandle;
$fh->open("test.html", "r") || die "\n $0 Cannot open $!\n";

while (<$fh>) {
        $html.= $_;
}
$fh->close;
#$p = HTML::FormParser->new();
#$p->parse_file($questionnaire) || die $!;

my $p = HTML::FormParser->new();
$p->parse($html,
start_form => sub {
	my ($attr, $origtext) = @_;
	print "Form action is $attr->{action}\n";
},
input => sub {
	my ($attr, $origtext) = @_;
	print "Name: $attr->{name}= $attr->{value}\n";
}
);
exit 0;
#end program