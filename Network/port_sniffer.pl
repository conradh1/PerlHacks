#!/usr/bin/perl -w
# Filename : client.pl

use strict;
use IO::Socket;

# initialize host and port
my %list = ( 'FTP' => 21,
               'SSH' => 22,
               'Telnet' => 23,
               'SMTP' => 25,
               'DNS' =>53,
                'HTTP'=> 80,
                'HTTPS'=> 443
            );


my $server = shift || "localhost";  # Host IP running the server


print "Looking for ports on $server\n";

foreach my $protocol ( keys %list ) {
  my $port = $list{$protocol};
  print "Attempting socket: $protocol => $port ....";
  my $socket = IO::Socket::INET->new(PeerAddr => $server, PeerPort => $port , Proto => 'tcp' , Timeout => 3);
  if ( $socket ) {
    print "Connection made, response: $socket\n";
  }
  else {
    print "Closed $protocol with port $port! \n";
  }

}

# create the socket, connect to the port






