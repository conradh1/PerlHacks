#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;
use vars qw($chan $cat $num $data $UA $request);

use LWP::UserAgent;
use HTTP::Request;
use XML::XPath;

use constant MEERKAT =>
    'http://www.oreillynet.com/meerkat/xml-rpc/server.php';
use constant XPATH_TO_STRUCTS =>
    '/methodResponse/params/param/value/array/data/value' .
    '/struct';

# Read and test the command-line arguments.
if ($ARGV[0] =~ /^-ch/) {
    $chan = $ARGV[1];
    $num  = $ARGV[2] || 15;
} elsif ($ARGV[0] =~ /^-ca/) {
    $cat = $ARGV[1];
    $num = $ARGV[2] || 15;
}
unless (($chan or $cat) and ($num =~ /^\d+$/)) {
    die "USAGE: $0 { -channel str | -category str } [ n ]";
}

# Create a user-agent object, and pre-create the HTTP
# Request object. Also, set the Content-Type to the standard
# value, as that will never need to be changed.
$UA = LWP::UserAgent->new();
$request = HTTP::Request->new(POST => MEERKAT);
$request->content_type('text/xml');

# This could be done with just one data-retrieval routine,
# but this way is easier to follow, and tests $chan/$cat
# less-often.
$data = $chan ? data_from_chan($chan, $num) :
                data_from_cat($cat, $num);
show_data($data);

exit;

# Retrieve data from a 'Channel' source
sub data_from_chan {
    my ($chan, $num) = @_;

    # If $chan is not already numeric, convert it by using
    # an intermediate XML-RPC call
    $chan = resolve_name($chan, 'Channels')
        unless ($chan =~ /^\d+$/);
    get_data(channel => $chan, $num);
}

# Retrieve data from a 'Category' source
sub data_from_cat {
    my ($cat, $num) = @_;

    # If $cat is not already numeric, convert it by using
    # an intermediate XML-RPC call
    $cat = resolve_name($cat, 'Categories')
        unless ($cat =~ /^\d+$/);
    get_data(category => $cat, $num);
}

# Output the HTML fragment for the data. Note that the way
# the data is treated is independant of whether the source
# was a category or a channel
sub show_data {
    my $data = shift;

    # The data in was a scalar reference pointing to the
    # XML returned from Meerkat. Feed it straight to the
    # XML::XPath engine, then start by retrieving all the
    # 'struct' nodes.
    my $xp = XML::XPath->new(xml => $$data);
    my $nodes = $xp->find(XPATH_TO_STRUCTS);

    my @stories = ();
    for my $struct ($nodes->get_nodelist) {
        # Each story record is built by finding the
        # <member> within the <struct> that has a <name>
        # matching the given key (the loop value). When
        # that is found, the <value>/<string> part is
        # extracted and saved on the hash-reference.
        my $tmp = {};
        for my $key (qw(title link description)) {
            my $node = $xp->find(qq(member[name="$key"]),
                                 $struct);
            $tmp->{$key} =
                $xp->find('value/string',
                          $node->get_node(1))
                    ->string_value;
        }
        push(@stories, $tmp);
    }
    print STDOUT qq(<span class="meerkat">\n<dl>\n);
    for (@stories) {
        print STDOUT <<"END_HTML";
<dt class="title"><a href="$_->{link}">$_->{title}</a></dt>
<dd class="description">$_->{description}</dd>
END_HTML
    }
    print STDOUT qq(</dl>\n</span>\n);
}

# Resolve a substring name-fragment into the numeric ID that
# the call later on in get_data requires
sub resolve_name {
    my ($str, $name) = @_;

    # Fortunately, the calling syntax is the same for
    # categories or channels, the only difference being
    # the name of the remote procedure
    $name = "meerkat.get${name}BySubstring";
    # Make the XML for the request
    my $xml = <<"END_XML";
<?xml version="1.0"?>
<methodCall>
  <methodName>$name</methodName>
  <params>
    <param><value>$str</value></param>
  </params>
</methodCall>
END_XML

    # Set the content of the request object to the XML
    $request->content($xml);
    # Make the request and get the HTTP::Response object
    my $resp = $UA->request($request);
    die "resolve_name: transport error: " . $resp->message
        if $resp->is_error;
    # Feed the XML of the result to XML::XPath
    my $xp = XML::XPath->new(xml => $resp->content);
    # Grab the <struct> block(s) within the <array>
    my $nodeset = $xp->find(XPATH_TO_STRUCTS);
    # We aren't doing multi-channels (yet), so report an
    # error if the substring returns more than one hit
    die "resolve_name: $str returned more than 1 match"
        if ($nodeset->size > 1);
    my $node = $nodeset->get_node(1);
    $node = $xp->find('member[name="id"]', $node);

    # The only value needed is the <int> ID for the
    # <struct>
    $xp->find('value/int', $node->get_node(1))
        ->string_value;
}

# Get the data-- will return a scalar reference to the
# XML text.
sub get_data {
    my ($key, $val, $num) = @_;

    # Create the XML message for the request
    my $xml = <<"END_XML";
<?xml version="1.0"?>
<methodCall>
  <methodName>meerkat.getItems</methodName>
  <params>
    <param><value>
      <struct>
        <member>
          <name>$key</name>
          <value><int>$val</int></value>
        </member>
        <member>
          <name>time_period</name>
          <value><string>7DAY</string></value>
        </member>
        <member>
          <name>num_items</name>
          <value><int>$num</int></value>
        </member>
        <member>
          <name>descriptions</name>
          <value><int>200</int></value>
        </member>
      </struct>
    </value></param>
  </params>
</methodCall>
END_XML

    # Set the content on the request object to the XML
    $request->content($xml);
    # Get the HTTP::Response object back
    my $resp = $UA->request($request);
    die "resolve_name: transport error: " . $resp->message
        if $resp->is_error;
    my $content = $resp->content;
    # Return the XML body of the response
    \$content;
}
