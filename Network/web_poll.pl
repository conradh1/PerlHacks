require LWP::UserAgent;
 
 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
 $ua->env_proxy;

 my $server = shift || 'http://search.cpan.org/';
 

 print "Attempting content from $server\n";
 my $response = $ua->get($server);
 
 if ($response->is_success) {
     print $response->content;  # or whatever
 }
 else {
     die $response->status_line;
 }