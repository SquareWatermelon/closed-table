#Author: Robert "Square Watermelon" Tolda
#Handles the second stage of validation
#And Contains functions to validate input strings
#*******************************************************************************

use strict;
use Switch;
use misc;
use tableMaker;
use reservations;
use userDatabase;

#Controls second stage validation by selecting the appropriate validation sub
#returns warning string if the input did not pass, otherwise 0
sub getWarnings {
    my %in = %{shift @_};
    my $warningString = '';
    my $state = $in{'state'};
#    print $in{'userName'};
    switch( $state ){
    case "getTables"    {
        $warningString = getGetTablesWarnings(
            $in{'date'}, 
            $in{'startTime'},
            $in{'endTime'});
    }
    case "mkPDF"      { 
        $warningString = getMkPDFWarnings($in{'date'});
    }
    case "mkTPass"      { 
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
            $in{'rmDate'},
            $in{'rmNumber'});
    }
    case "rmTable"      {
        $warningString = getRmTableWarnings(
            $in{'rmTableNumber'});
    }
    case "rmUser"       {
        $warningString = getRmUserWarnings(
            $in{"rmUserName"});
    }
    case "tryLogin"     {
        $warningString = getLoginWarnings(
            $in{'userName'},
            $in{'password'});
    }
    else                { 
        $warningString = 'Bad submission error 10!' . $in{"state"} 
    }
    }

    if ($warningString eq ''){ return 0 };
    return scriptChomp($warningString);
}

################################################################################
# Warning String Methods (function names explain everthing)
################################################################################
sub getGetTablesWarnings{
    my $date = shift;
    my $startTime = shift;
    my $endTime = shift;
    my $warningString = '';
    my $endBlock = getBlock($endTime);
    my $startBlock = getBlock($startTime);
    my $test = 1;
    if ( !isValidDate($date) ){
        $warningString .= "Not a Valid Date\\n";
    }
    if ( !isValidTime($startTime) ){
        $warningString .= "Not a Valid Time for Start\\n";
        $test = 0;
    }
    if ( !isValidTime($endTime) ){
        $warningString .= "Not a Valid Time for End\\n";
        $test = 0;
    }
    
    if ($test == 1){
        if( $endBlock - $startBlock > 10){
            $warningString .= "Please give a maximum of 5 hours difference\\n";
        }elsif ($endBlock - $startBlock < 2){
            $warningString .= "Please give a minimum of 1 hour difference\\n";
        }
    }
    if ( $endBlock > 46 or $startBlock > 46){
        $warningString .= "Store Closes Reservations at 23:00\\n";
    }
    if ( $endBlock < 16 or $startBlock < 16){
        $warningString .= "Store Starts Reservations at 8:00\\n";
    }
    return $warningString;
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
    $warningString .= getPasswordWarnings($mkPassword);
    return $warningString;
}

sub getMkReserveWarnings{
    my $mkName = shift;
    my $mkNumber = shift;
    my $mkTime = shift;
    my $mkDate = shift;
    my $mkPhone = shift;
    my $warningString = '';
    my @mkDate = split /\D/, $mkDate;
    my $try = 1;
    if ( !isValidName( $mkName ) ) {
        $try = 0;
        $warningString .= "Invalid Name\\n";
    }
    if ( $mkNumber =~ /\D/ ) {
        $try = 0;
        $warningString .= "Invalid Number\\n";
    }
    if ( !isValidTime( $mkTime ) ) {
        $try = 0;
        $warningString .= "Invalid Time\\n";
    }
    if ( !isValidDate( $mkDate ) ) {
        $try = 0;
        $warningString .= "Invalid Date\\n";
    }
    $mkTime = getBlock($mkTime);
    
    if ( $mkTime > 46){
        $try = 0;
        $warningString .= "Store Closes Reservations at 23:00\\n";
    }
    if ( $mkTime < 16){
        $try = 0;
        $warningString .= "Store Starts Reservations at 8:00\\n";
    }
    if ( $try and !checkTable($mkDate, $mkTime, $mkName, $mkNumber)){
#    spaceExists( $mkNumber, getBlock($mkTime), @mkDate) ){
        $warningString .= "Can not reserve for that time or no such table!\\n";
    }
    if ( $mkPhone ne 'Phone+Number' and $mkPhone ne '' and !isValidPhone($mkPhone)){
        $warningString .= "Phone # must be 7 numbers or nothing!\\n";
    }
    return $warningString;
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
    $warningString .= getPasswordWarnings( $password );
    if ( !isValidEmailString( $email ) ) {
        $warningString .= "Email not a valid email address\\n";
    }
    return $warningString;
}

sub getMkPDFWarnings{
    my $date = shift;
    if ( !isValidDate( $date ) ) {
        return "Invalid Date\\n";
    }
    return '';
}

sub getRmReserveWarnings{
    my $rmName = shift;
    my $rmTime = shift;
    my $rmDate = shift;
    my $rmNumber = shift;
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
    if ( $rmNumber =~ /\D/) {
        $try = 0;
        $warningString .= "Invalid Number\\n";
    }
    if ( !isValidDate( $rmDate ) ) {
        $try = 0;
        $warningString .= "Invalid Date\\n";
    }
    $rmTime = getBlock($rmTime);
#    my ($month, $day, $year) = split (/\D/, $date);
    if ( $try and !checkTable($rmDate, $rmTime, $rmName, $rmNumber) ){
        $warningString .= "Email not a valid email address\\n";
    }
}

sub getRmTableWarnings{
    my $rmTableNumber = shift;
    if ( not $rmTableNumber =~ /^\d?\d$/ ) {
        return "Not a valid table amount";
    }else{
        if ( !tableExists($rmTableNumber) ){
            return "No such table.";
        }
        if ( !isTableOccupied($rmTableNumber) ) {
            return "Table has reservations on it!";
        }
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
    if ( not userExists( $userName ) ){
        return "User does not exist";
    }elsif( not isUsersPassword($userName, $userPassword ) ){
        return "Incorrect Password";
    }
    return '';
}

################################################################################
# String Validation Methods (function names explain everthing)
################################################################################

sub isValidPhone {
    my $number = shift;
    return $number =~ m/^\d{3}.\d{3}.\d{4}$/;
}

sub isValidTime {
    my $time = shift;
    return $time =~ m/^(0|1)?\d.(0|1|2|3|4|5|6)\d$/
        or $time =~ m/^2(0|1|2|3|4).(0|1|2|3|4|5|6)\d$/
}

#does not account for the skipped leap years every whatever hundred years
sub isValidDate {
    my $date = shift;
#    print "L_______$date ________";
    my ($month, $day, $year ) = split ( /\//, $date );
#    print "$month, $day, $year";
    if (not ($month > 0 and $month <= 12)){ return 0 };
    if ($day < 0){return 0};
    #31 day months
    if ($month =~ /^(1|3|5|6|7|10|12)$/){
        if (not ($day <= 31)){ return 0 };
    }else{ #30 day and feb
        if ($month == 2 ) {
            if($year % 4 != 0){
                 if(not($day <= 28)){ return 0 };
            }elsif(not($day <= 29)){ return 0 };
        }else{
            if (not ($day <= 30)){ return 0 };
        }
    }
    return $year =~ /^\d?\d$/;
}

sub isValidEmailString{
    my $email = shift;
    return ($email =~ m/^\w+\@\w+\.\w{2,4}$/)
}

sub getPasswordWarnings{
    my $password = shift;
    my $warningString = '';
    my $length = length($password);
    if ( $length < 6 ) {
        $warningString .= "Password must be at least 6 characters.\\n";
    }
    if ( $length > 15 ) {
        $warningString .= "Password must be less then 15 character.\\n";
    }
    if ( $password !~ /[^a-zA-Z0-9]/) {
        $warningString .= "Password must contain at least one Special Character.\\n";
    }
    if ( $password !~ /[A-Z]/) {
        $warningString .= "Password must contain at least one Uppercase Character.\\n";
    }
    if ( $password =~ /[: ]/) {
        $warningString .= "Password must not Contain :.\\n";
    }
    return $warningString;
}

1;