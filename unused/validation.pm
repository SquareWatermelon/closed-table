#contains functions to validate input strings

use strict;
use Switch;
use pages;
use misc;
use test;
use functions;
#use test;

sub getWarnings {
    my %in = %{shift @_};
    my $warningString = '';
    my $state = $in{'state'};
    switch( $state ){
    case "getTables"    {
        $warningString = getGetTablesWarnings(
            $in{'date'}, 
            $in{'startTime'},
            $in{'endTime'});
    }
    case "mkEmail"      { 
        $warningString = getMkEmailWarnings(
            $in{'emailUser'}, 
            $in{'mkEmail'});
    }
    case "mkPassword"   { 
        $warningString = getMkPasswordWarnings(
            $in{'oldPassword'},
            $in{'newPassword'},
            $in{'userName'});
    }
    case "mkReserve"    {
        $warningString = getMkReserveWarnings(
            $in{'mkName'},
            $in{'mkNumber'},
            $in{'mkTime'},
            $in{'mkDate'},
            $in{'mkPhone'});
    }
    case "mkTable"      {
        $warningString = getMkTableWarnings(
            $in{'mkTableNumber'});
    }
    case "mkUser"       {
        $warningString = getMkUserWarnings(
            $in{'mkUserName'}, 
            $in{'mkPassword'}, 
            $in{'mkEmail'   });
    }
    case "rmReserve"    {
        $warningString = getRmReserveWarnings(
            $in{'rmName'},
            $in{'rmTime'},
            $in{'rmDate'});
    }
    case "rmTable"      {
        $warningString = getRmTableWarnings(
            $in{'rmTableNumber'});
    }
    case "rmUser"       {
        $warningString = getRmUserWarnings(
            $in{"rmUserName"});
    }
#    case "skip"         { unshift @_, 0; }
    case "tryLogin"     {
        $warningString = getLoginWarnings(
            $in{'userName'},
            $in{'password'});
    }
        #unshift @_, "login";
        #unshift @_, $isValidPass{$in{"password"}}
        #unshift @_, $isValidUser{$in{"user"}}
    else                { 
        $warningString = 'Bad submission error 10!' . $in{"state"} 
    }
    }

    if ($warningString eq ''){ return 0 };
    return scriptChomp($warningString);
}

sub getGetTablesWarnings{
    my $date = shift;
    my $startTime = shift;
    my $endTime = shift;
    my @date = isValidDate( $mkDate );
    $startTime = isValidTime($startTime);
    $endTime = isValidTime($endTime);
    my $warningString = '';
    my $test = 1;
    if ( !@date[0] ){
        $warningString .= "Not a Valid Date\\n";
    }
    if ( !$startTime ){
        $warningString .= "Not a Valid Time for Start\\n";
        $test = 0;
    }
    if ( !$endTime ){
        $warningString .= "Not a Valid Time for End\\n";
        $test = 0;
    }
    if ($test == 1 and getBlock($endTime) - getBlock($startTime) > 10){
        $warningString .= "Please give a maximum of 5 hours difference\\n";
    }
    return ($warningString, @date, $startTime, $endTime);
}

sub getMkEmailWarnings{
    my $user = shift; 
    my $email = shift;
    my $warningString = '';
    my $test = 0;
    if ( !userExists( $user ) ) {
        $warningString .= "No Such User\\n";
        $test = 1;
    }
    if ( !isValidEmailString($email) ){
        $test = 1;
        $warningString .= "Not a Valid Email\\n";
    }
    if ( !isUsersEmail( $user, $email ) and $test == 0 ) {
        $warningString .= "Incorrect Email\\n";
    }
    return $warningString;
}

sub getMkPasswordWarnings{
    my $oldPassword = shift;
    my $mkPassword = shift;
    my $userName = shift;
    my $warningString = '';    
    if (not isUsersPassword($userName, $oldPassword ) ){
        $warningString .= "Incorrect Old Password\\n";
    }
    if ( !isValidPassword( $mkPassword ) ) {
        $warningString .= "Invalid Password\\n";
    }
    return $warningString;
}

sub getMkReserveWarnings{
    my $mkName = shift;
    my $mkNumber = shift;
    my $mkTime = shift;
    my $mkDate = shift;
    my $mkPhone = shift;
    my $warningString = '';
    my $mkTime = isValidTime( $mkTime );
    my @date = isValidDate( $mkDate );
    
    my $try = 1;
    if ( !isValidName( $mkName ) ) {
        $try = 0;
        $warningString .= "Invalid Name\\n";
    }
    if ( !$mkTime ) {
        $try = 0;
        $warningString .= "Invalid Time\\n";
    }
    if ( !@date[0] ) {
        $try = 0;
        $warningString .= "Invalid Date\\n";
    }
    if ( $try and !spaceExists( $mkNumber, getBlock($mkTime), @mkDate) ){
        $warningString .= "Can not reserve for that time!\\n";
    }
    return $warningString
}

sub getMkTableWarnings{
    my $mkTableNumber = shift;
    if ( not $mkTableNumber =~ /^\d?\d$/ ) {
        return "Not a valid table amount";
    }
    return '';
}

sub getMkUserWarnings{
    my ($user, $password, $email) = @_;
    my $warningString = '';
    if ( userExists( $user ) ){
        return "User already Exists\\n";
    }
    if ( !isValidName( $user ) ) {
        $warningString .= "Invalid User\\n";
    }
    if ( !isValidPassword( $password ) ) {
        $warningString .= "Invalid Password\\n";
    }
    
    if ( !isValidEmailString( $email ) ) {
        $warningString .= "Email not a valid email address\\n";
    }
    return $warningString;
}

sub getRmReserveWarnings{
    my $rmName = shift;
    my $rmTime = shift;
    my $rmDate = shift;
    
    my @date = isValidDate( $rmDate )
    my $warningString = '';
    my $try = 1;
    if ( !isValidName( $rmName ) ) {
        $try = 0;
        $warningString .= "Invalid Name\\n";
    }
    if ( !isValidTime( $rmTime ) ) {
        $try = 0;
        $warningString .= "Invalid Time\\n";
    }
    
    if ( !@date[0] ) {
        $try = 0;
        $warningString .= "Invalid Date\\n";
    }
    if ( $try and !reservationExists( $rmName, $rmTime, $rmDate ) ){
        $warningString .= "Email not a valid email address\\n";
    }
}

sub getRmTableWarnings{
    my $rmTableNumber = shift;
    if ( not $rmTableNumber =~ /^\d?\d$/ ) {
        return "Not a valid table amount";
    }elsif ( !tableExists($rmTableNumber) ){
        return "No such table.";
    }
    return '';
}
sub getRmUserWarnings{
    my $rmUserName = shift;
    if ( !userExists( $rmUserName ) ){
        return "User does not exist";
    }
    return '';
}

sub getLoginWarnings{
    my $userName = shift;
    my $userPassword = shift;
    print '<br/> here';
    if ( not userExists( $userName ) ){
        return "User does not exist";
    }elsif( not isUsersPassword($userName, $userPassword ) ){
        return "Incorrect Password";
    }
        print '<br/> there';
    return '';
}

sub isValidPhone {
    my $number = shift;
    return $number =~ m/^\d{3}.\d{3}.\d{4}$/;
}

sub isValidTime {
    my $time = shift;
    if($time =~ /^(\d{1,2})\D(\d{1,2})$/ ) {
        my ($hours, $minutes) = ($1, $2);
        if($hours <= 24 and $hours > 0 
                and $minutes < 60 and $minutes >= 0 ){
            return $hours . ':' . $minutes
        }
    }
    return 0;
}
#    return $time =~ m/^(0|1)?\d.(0|1|2|3|4|5|6)\d$/
#        or $time =~ m/^2(0|1|2|3|4).(0|1|2|3|4|5|6)\d$/


#does not account for the skipped leap years every whatever hundred years
sub isValidDate {
    my $date = shift;
#    print "L_______$date ________";
    if($date =~ /(\d?\d)\D(\d?\d)\D(\d{1,4})/){
        my $month = $1;
        my $day = $2;
        my $year = $3;
        if (not ($month > 0 and $month <= 12)){ return 0 };
        if ($day < 0){ return (0) };
        #31 day months
        if ($month =~ /^(1|3|5|6|7|10|12)$/){
            if (not ($day <= 31)){ return (0) };
        }else{ #30 day and feb
            if ($month == 2 ) {
                if($year % 4 != 0){
                     if(not($day <= 28)){ return (0) };
                }elsif(not($day <= 29)){ return (0) };
            }else{
                if (not ($day <= 30)){ return (0) };
            }
        }
        return ($month, $day, $year);
    }else return (0);
#    my ($month, $day, $year ) = split ( /\//, $date );
#    print "$month, $day, $year";
}

sub isValidEmailString{
    my $email = shift;
    return ($email =~ m/^\w+\@\w+\.\w{2,4}$/)
}

1;






#switch($in{"state"}){
#    case "mkEmail"      { 
#        my $warningString = getMkEmailWarnings($in{"emailUser"}, $in{'mkEmail'});
#        if( $warningString ne '' ){
#            email($in{"emailUser"}, $in{'mkEmail'}) 
#        }else{
#            alert($warningString);
#            unshift @_, 0;
#        }
#    }
#    case "mkReserve"    { unshift @_, 0; }#mkReserve() }
#    case "mkStore"      { mkStore(\%in) }
#    case "mkUser"       { 
#        my $warningString = getMkUserWarnings(
#            $in{"mkUserName"}, 
#            $in{"mkPassword"}, 
#            $in{"mkEmail"   });
#        if( $warningString ne '' ){
#            mkUser($in{"mkUserName"}, $in{"mkPassword"}, $in{"mkEmail"}) 
#        }
#        else {
#            alert($warningString);
#            unshift @_, "mkUser";
#        }
#    }
#    case "rmReserve"    { rmReserve(\%in) }
#    case "rmStore"      { mkStore(\%in) }
#    case "rmUser"       { rmUser(\%in) }
#    case "skip"         { unshift @_, 0; }
#    case "tryLogin"     { 
#        unshift @_, "startReserve" 
#        #unshift @_, "login";
#        #unshift @_, $isValidPass{$in{"password"}}
#        #unshift @_, $isValidUser{$in{"user"}}
#    }
#    case undef          { unshift @_, "login"; }
#    else                { alert('Bad submission error 10!' . $in{"state"} )}
#}