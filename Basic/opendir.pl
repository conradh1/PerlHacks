use strict ;
use warnings ;
use File::stat ;

my $path = "./" ;

opendir (DH, $path) || die "Fail to open dir:$!\n" ; ;
my @dir = readdir (DH) ;
closedir (DH) ;

foreach my $dir (@dir) {
 	print "file: $dir\n" ;
# 	 my $dirmode = (stat($dir)) [2] ;
# 	 printf "Permissions are %04o\n", $dirmode & 07777;
	 #print "DIRmode= $dirmode\n" ;
 }


 #anotehr way to skin a cat
 my @list = `ls -la`;

 foreach my $file (@list) {
      my @parts = split(/\s/,$file);
      if ( $parts[0] =~ /x/ ) {
	print "Executable flie:$parts[$#parts]\n" ;
      }


 }


