#!/usr/local/bin/perl -- -*-perl-*-

#This is a perl program that tests simply file functions
use strict;
use FileHandle;
use DirHandle;

my @search_files;
my @found_strings;
my $str_search;
my $dir;

print "*********Start Program**************\n";
print"Enter a directory to search use escape characters.\n";
$dir= <STDIN>; #path for seach files
chop($dir);
print "Search directory: $dir \n";
print "Enter a string to do a search\n";
$str_search= <STDIN>;
chop($str_search);
get_dir();
show_results();
##################################################################
sub get_dir() {
    chdir($dir); 
    my $dh= new DirHandle $dir; #new directory handle
    $dh->open($dir);
    my @dir_files= $dh->read();
    $dh->close();
    get_files(@dir_files);
}
##################################################################
sub get_files() {
    my (@dir_files)= @_;

    foreach $_ (@dir_files) {
	open(HANDLE, $_) || die "\n $0 Cannot open $!\n";
	searchfile(\*HANDLE, $_);
	close(HANDLE);
    }
}
##################################################################
sub searchfile() {
	my ($fh, $file)= @_;
	my $found= 0;
	while (<$fh>) {
		chop($_);
		if (($_=~  /$str_search/gi) || /\w+(?=$str_search)/gi || /(?=$str_search)\+w/gi) {
			$found++;
		}
    	}
    	if ($found > 0) {
    		push (@found_strings, "found $str_search in $file $found time(s).");
    	}
}
##################################################################
sub show_results() {
    print"\n##############Results###################\n";
    foreach (@found_strings) {
	print "$_ \n";
    }
    print"#############End Program##################\n";
}
