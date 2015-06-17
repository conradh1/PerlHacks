sub check_fields
{
    &prterr("Surname cannot be blank.\n") unless $FORM{'surname'};
    &prterr("First Name cannot be blank.\n") unless $FORM{'firstname'};
    # Don't check Middle Name
    # &prterr("Middle Name cannot be blank.\n") unless $FORM{'midname'};
    # Don't check Former Name
    &prterr("Mailing Name must contain at least 2 words.\n") if
$FORM{'mailname'
} !~ / /;
    &prterr("Address (line 1) cannot be blank.\n") unless
$FORM{'addr1'};
    # Don't check Address (line 2)
    &prterr("Home phone # cannot be blank.\n") unless $FORM{'hphone'};
    # Don't check Address (line 3)
    # Don't check Work Phone
    &prterr("City/Town cannot be blank.\n") unless $FORM{'city'};
    &prterr("Prov/State cannot be blank.\n") unless $FORM{'prov'};
    # Remove the postal code check - for international students
    # &prterr("Postal/Zip cannot be blank.\n") unless $FORM{'postcode'};
    &prterr("Country cannot be blank.\n") unless $FORM{'country'};
    &prterr("Birthdate is improperly formatted.\n") if $FORM{'bdate'} !~
/\d\d\/
\d\d\/\d{4}/;
    # if there is a value in the sin field check for Canadian SIN
    if ($FORM{'sin'})
    {
        &prterr("SIN is improperly formatted.\n") if $FORM{'sin'} !~
/\d{9}/;
    }
    # Don't check Gender
    # Don't check Citizenship
    if ($FORM{'citship'} =~ /Canadian/)
    {
        $FORM{'citcountry'} = '';
    }
    else
    {
        &prterr("Citizenship country must be supplied.\n") unless
($FORM{'citcou
ntry'} && $FORM{'citcountry'} !~ /if.*state/i);
    }
    # Don't check any Education fields
    # Don't check Occupation
    # Don't check Disabiled
    if ($FORM{'disabled'} eq "No")
    {
        $FORM{'disability'} = '';
    }
    else
    {
        &prterr("Disability must be supplied.\n") unless
($FORM{'disability'} &&
 $FORM{'disability'} !~ /if.*state/i);
    }
    # Don't check Aboriginal
    # Don't check Tranfer
    # Don't check Contact
    # Don't check Credential
    if ($FORM{'aucred'} eq "No")
    {
        $FORM{'aucrednm'} = '';
    } elsif ($FORM{'aucred'} eq "Yes" && $FORM{'reactivate'} eq
"unclassified")
{
        # cannot select AU credential if unclassified
        $FORM{'aucrednm'} = '';
        $FORM{'aucred'} = 'No';
    } else {
        # if not empty credential & credential is not default then
        if ($FORM{'aucrednm'} && $FORM{'aucrednm'} !~ /if.*state/i) {
            # if credential not 4 yr BA & double major is not default then
            
    }
    # Don't check any Educational history fields
    # Don't check Fee
    # Don't check Charge to
    if ($FORM{'reactivate'} eq "unclassified") {
    } else {
        &prterr("Creditcard # is invalid.\n") unless
&ccverify($FORM{'ccard'},$F
ORM{'ccnum'});
        &prterr("Creditcard expiry date is invalid.\n") unless
&ccexpverify($FOR
M{'ccexpdt'});
    }
    &prterr("Terms declaration must be agreed to.\n") unless
$FORM{'approved'};

    exit if $errors;
}

# ----------------------------------------------------------------------
# This subroutine returns properly formatted error text to the user.
# ----------------------------------------------------------------------

sub prterr
{
    print "Please correct the following problems and resubmit:\n<P>\n"
unless $e
rrors;
    print "$_[0]<BR>";
    $errors++;
}

