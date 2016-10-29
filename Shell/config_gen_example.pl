#!/usr/bin/perl 

use Config::General;

 $conf = new Config::General(
    -ConfigFile     => 'configfile',
    -ExtendedAccess => 1
 );