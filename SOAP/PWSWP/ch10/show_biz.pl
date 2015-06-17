#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;
use vars qw(%opts $name @qualifiers @params $SHOWKEYS);
use subs qw(dump_business dump_service dump_template);

# Text::Wrap will be used to format <description> blocks
use Text::Wrap qw(wrap $columns);
use Getopt::Long 'GetOptions';
# This example will make use of the autodispatch ability
use UDDI::Lite +autodispatch =>
               proxy => 'http://uddi.microsoft.com/inquire',
               import => 'UDDI::Data';

# --case:     Do the matching in a case-sensitive manner
# --exact:    Match a string exactly
# --showkeys: Display record UUIDs right after the name
GetOptions(\%opts, qw(case exact showkeys)) and
    $name = shift or
    die "USAGE: $0 [ --case ] [ --exact ] [ --showkeys ] " .
        "name\n";
$SHOWKEYS++ if ($opts{showkeys});

# Building up the qualifiers this way makes it cleaner to
# create the <findQualifiers> structure. And since the
# parameters are being pre-constructed, throw the search
# string on at the end for convenience.
@qualifiers = ('sortByNameAsc');
push(@qualifiers, 'exactNameMatch')     if ($opts{exact});
push(@qualifiers, 'caseSensitiveMatch') if ($opts{case});
push(@params,
     findQualifiers(findQualifier(@qualifiers)),
     name($name));

# First UDDI call: find all businesses that match the
# criteria, then loop over them passing each to the
# dump_business routine.
my $result = find_business(@params);
dump_business($_)
    for ($result->businessInfos->businessInfo);

exit;

# Dump the contents of a <businessInfo> (an abbreviated
# form of a <businessEntity>) record.
sub dump_business {
    my $business = shift;

    print $business->name, "\n";
    print 'uuid:', $business->attr->{businessKey}, "\n"
        if $SHOWKEYS;
    print "\n";
    if (my $description = $business->description) {
        $columns = 72;
        print wrap("\t", "\t", $description), "\n\n";
    }
    # Hand off each service entry to the dump_service
    # routine.
    dump_service($_)
        for ($business->serviceInfos->serviceInfo);
}

# Dump the contents of a <businessService> record. What
# gets passed in is just a brief overview, however.
sub dump_service {
    my $svc = shift;

    my ($key, $service);

    # First order of business (so to speak) is to get the
    # full <businessService> record, since what was passed
    # in was a <serviceInfo>, that lacks a lot of data.
    $key = $svc->attr->{serviceKey};
    # Call get_serviceDetail using the serviceKey attribute
    # from the short-form data.
    return unless
        $service = get_serviceDetail(serviceKey($key));
    $service = $service->businessService;
    print '    Service: ', $service->name, "\n";
    print '    uuid:', $service->attr->{serviceKey}, "\n"
        if $SHOWKEYS;
    if (my $description = $service->description) {
        $columns = 64;
        print wrap("\t    ", "\t    ", $description), "\n";
    }
    print "\n";
    # Hand off a third time to handle <bindingTemplate>
    # records.
    dump_template($_)
        for ($service->bindingTemplates->bindingTemplate);
}

# Dump the contents of a <bindingTemplate> record. This
# doesn't need an extra call, because all the needed data
# was retrieved in the earlier get_serviceDetail call.
sub dump_template {
    my $template = shift;

    print "\tTemplate:\n";
    print "\tuuid:", $template->attr->{bindingKey}, "\n"
        if $SHOWKEYS;
    if (my $description = $template->description) {
        $columns = 60;
        print wrap("\t\t", "\t\t", $description), "\n";
    }
    # Display either the access point (with a parenthetical
    # comment about the URLType) or the redirector key.
    # If neither are present, well, the registry should
    # never have permitted that, but we can't count on it.
    if (my $access = $template->accessPoint) {
        printf "\t    Access point (%s): %s\n",
            $access->attr->{URLType}, $access->value;
    } elsif (my $redir = $template->hostingRedirector) {
        print "\t    Hosting redirect to ",
            $redir->value, "\n";
    } else {
        print "\t    No access point or hosting " ,
            "redirector?\n";
    }
    print "\n";
}
