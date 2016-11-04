use strict ;
use warnings ;
use File::stat ;

my $path = "/nfs/ch/test_dir" ;

opendir (DH, $path) || die "Fail to open dir:$!\n" ; ;
my @dir = readdir (DH) ;
closedir (DH) ;

foreach my $dir (@dir) {
 	print "DIR: $dir\n" ;
	 $dirmode = (stat($dir)) [2] ;
	 printf "Permissions are %04o\n", $dirmode & 07777;
	 print "DIRmode= $dirmode\n" ;
 }
