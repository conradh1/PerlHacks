#!/usr/bin/perl
#This program gets rid of html tags

my $html_str= "<html><head><body>This is some text.</body></head></body>";

print"The string before html parsing: \"$html_str\"\n";
html_parse();
print"The string after html parsing: \"$html_str\"\n";


sub html_parse {
#get rid of html tags
    $html_str=~ s/<[^>]+>//g;
}

