#!/usr/bin/perl -w
=pod

=head1 NAME

 pspsadminweb-install.pl -Install PSPSAdminWeb from a copy of the repository.

=head1 SYNOPSIS

  perl pspsadminweb-install.pl

=head1 DESCRIPTION

  This script installs the PSPSAdmin Web application

=head2 METHODS
   TODO
=cut

# 
#
# Usage: perl install.pl

use strict;
use LWP::Simple;
use Cwd;
use XML::Simple;
    
my $DEBUG = 0;

# global variables
my $g_cur_dir = getcwd; # current directory
my $g_conf_sub_path = "web/conf"; # configuration file relative path
my $g_conf_filename = "psadmin_config.xml"; # configuration file name
my $g_default_install_dest = "/var/www/html"; # default installation path
my $g_install_path = ""; # the final install path
my @g_urls = (); # configuration URL array
my $g_src_subpath = "web"; # subdirectory in source tree of source files

# *** START *****************************************************************

# create a temporary installation directory

my $user_input = ""; # user provided values
my $valid_path = 0; # valid path flag

print "Installing PSPSAdminWeb...\n\n";

# retrieve source code
print "Retrieving code distribution.\n\n";
if(!$DEBUG) {
    retrieve_source_code();
}

get_urls(); # retrieves the URLs from the configuration file
verify_services();
print "\n";
check_reference_types();

while (!$valid_path) {
    print "\nEnter the file path to install to [$g_default_install_dest]: ";
    $user_input =  <STDIN>; # user input
    chomp ($user_input);
    #$user_input = lc($user_input);
    if ($user_input eq "") {
        $g_install_path = $g_default_install_dest;
        $valid_path = 1;
    } else {
        $g_install_path = $user_input;
        $valid_path = 1;
    }
    if ( ! ( -d $g_install_path ) ) {
        print "ERROR: The directory $g_install_path does not exist.\n";
        $valid_path = 0;
    }
}

print "\nThe files will be installed to $g_install_path. Proceed [Yes]/No?\n";

$user_input =  <STDIN>; # user input
chomp ($user_input);
$user_input = lc($user_input);
if ($user_input eq "" || $user_input eq "y" || $user_input eq "yes") {
    print "Proceeding with the installation.\n\n"
} else {
    print "Cancelling installation.\n";
    exit;
}

install_files();
cleanup();
exit;
# *** THE END ***************************************************************

# get services from the configuration file
# @return none
sub get_urls {
    if ( ! -e "$g_temp_install_dir/$g_conf_sub_path/$g_conf_filename" ) {
        print "ERROR: $g_temp_install_dir/$g_conf_sub_path/$g_conf_filename doesn't exist.\n";
        exit;
    }
    
    my $name; # name of item
    my $xml = new XML::Simple; # XML object
    my $data = $xml->XMLin("$g_temp_install_dir/$g_conf_sub_path/$g_conf_filename"); # PSAdmin configuration file data
    my $last_url;

    my $k1; # key 1
    my $v1; # value 1
    my $k2; # key 2
    my $v2; # value 2

    # iterate over the URLs
    # each URL has name, location, type, description
    while ( ($k1, $v1) = each %{$data->{url}} ) {

        $name = $k1;
        my %url; # temporary hash used to process URLs       
        $url{name}=$k1; # XML uses name as a special attribute
        push(@g_urls,\%url);

        while ( ($k2, $v2) = each %{$v1} ) {
            
            my %url; # temporary hash used to process URLs       
            $url{$k2} = $v2;
            push(@g_urls,\%url);
            
        }        
    }
}

# verify the services
# @return none
sub verify_services {
    my $k1; # key 1
    my $v1; # value 1
    my $location = ""; # a location to be verified
    my $name = ""; # name of service

    print "Verifying web services.\n";
    
    foreach my $u (@g_urls) {
        # iterate over the URL data
        while ( ($k1, $v1) = each %{$u} ) {
           if ( $k1 eq "name" ) {
                $name = $v1;
           }
            if ( $k1 eq "location" ) {
                $location = $v1;
            }

            if ( $k1 eq "type" && $v1 eq "service" ) {

                print "Enter location for $name: [$location]? ";
                
                $user_input =  <STDIN>; # user input
                chomp ($user_input);
                #$user_input = lc($user_input);
                if ( $user_input ne "" ){
                    
                    # change the location in the configuration file
                    change_location_in_conf_file($location, $user_input);
                        
                    # user wants to change the location
                    $location = $user_input;
                    
                }
                
                print "$location ";
                verify_location($location);
            }
        }
    }    
}

# change a location in the configuration file
# this is not the best way to handle this problem
# @return none
sub change_location_in_conf_file {
    my ($original_location, $new_location) = @_;
    if ( $original_location =~ s/\//\\\//g ) {}
    if ( $new_location =~ s/\//\\\//g ) {}
    `sed -i 's/$original_location/$new_location/g' $g_temp_install_dir/$g_conf_sub_path/$g_conf_filename`;
}

# verify that a web location exists
# @param URL to web location
# @return 1 if valid, 0 otherwise
sub verify_location {
    my ($url) = @_;
    if ( defined ( my $content = get $url ) ) {
        print "exists\n";
        return 1;
    }
    print "is not available\n";
    return 0;
}

# check the reference types in the configuration file
# @return none
sub check_reference_types {
    my $name; # resource name
    my $location; # URL for resource
    my $k1; # key
    my $v1; # value
    print "Checking reference types.\n";

    foreach my $u (@g_urls) {
        # iterate over the URL data
        while ( ($k1, $v1) = each %{$u} ) {
           if ( $k1 eq "name" ) {
                $name = $v1;
           }
            if ( $k1 eq "location" ) {
                $location = $v1;
            }
            if ( $k1 eq "type" && $v1 eq "reference" ) {
                print "$name: $location ";
                verify_location($location);
            }
        }
    }    
}

# retrieve the configuration file path
# @return 0|path to configuration file
sub get_config_path {
    my $default_conf_path = "$g_temp_install_dir/$g_conf_sub_path";
    if ( -e $default_conf_path ) {
        return $default_conf_path;
    }
    else {
        return 0;
    }
}

# retrieve the source code from the repository
# @return none
sub retrieve_source_code {
    my $result = `$export_cmd`;
}

# perform cleanup of all installation related files
# @return none
sub cleanup {
    # cleanup the installation directory
    print "Cleaning up.\n";
    if($g_temp_install_dir =~ /pspsadminweb-install/) {
        if(!$DEBUG) {
            `rm -rf $g_temp_install_dir`;
        }
    } else {
        print "ERROR: Can't remove $g_temp_install_dir.\n";
        exit;
    }    
}

# perform installation of files
# @return none
sub install_files {
    if ( -e "$g_temp_install_dir/$g_src_subpath" ) {
        `cp -r $g_temp_install_dir/$g_src_subpath/* $g_install_path`;
    } else {
        print "ERROR: $g_temp_install_dir/web does not exist.\n";
        exit;
    }
}
