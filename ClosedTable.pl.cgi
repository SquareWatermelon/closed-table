#!/usr/bin/perl 
#Cleared taint mode "-T" for email
#The Main Controller for Closed table Works via:
#Phase 1 form submission, data retrieval, and 2 step Validation 
#   Also collects failures (and reasons) for the log.
#Phase 2 (when appropriate) Execution of given form data according to current 
#   state. Also collects the success for the log.
#Phase 3 Print out alerts and the log to provide information about event and
#   Print out appropriate page.
#*******************************************************************************
#BEGIN {
#  push(@INC, '/home/rmt2131/html/cs3157/project1/scripts');
#  push(@INC, '/home/rmt2131/html/cs3157/project1/foreign');
#};
use lib 'scripts';
use lib 'foreign';
use strict;
use validater;
use executer;
use printer;

print "Content-type: text/html\n\n";

#Phase 1
#holds all the clean form data
my %in = %{ retrieveInput() };#Phase 1 part 1
my $user = '';
$user .= $in{'userName'};
my $ip = $ENV{'REMOTE_ADDR'};
#debug(\%in);

my ( $response, $logStr, $printState) = valAndEx(\%in );

#Phase 3 Print out the appropriate info to page and log
display( $response, $logStr, $printState, \%in);



#runs phase 1 part 2 validation and phase 2 execution
sub valAndEx{
    my %in = %{shift @_};
    my $response;
    my $logStr = '';
    my $time = localtime;
    my $state = '';
    $state .= $in{'state'};
    my $user = '';
    $user .= $in{'userName'};
    if ($user == ''){$user .= $in{'emailUser'};}
    my $printState = 0;
    my $ip = $ENV{'REMOTE_ADDR'};
    
    if( $in{'illegal'} ) { #then failed first stage validation
        $response = 'A dangerous character such as (-, `, =, &, |) was found in the form submission!';
        #\\nForm thrown out and you are sent to login page.
        $logStr .= $in{'illegal'} . "\n\t" . "From $ip";
        if($in{'userName'}){$logStr .= ", provided userName " . $in{'userName'}; }
        if($in{'state'}){ $logStr .= ", provided state " . $in{'state'}; }    
        $state = 'skip';
        $printState = 0;
    }elsif( $state ne '' and $state ne 'skip'){
    #phase 1 part 2 Second layer of input validation for a backend type of action
         $logStr .= "->User $user attempted $state at $time from $ip.\n";
         $response = getWarnings( \%in );
         if( $response ne '0' ){
             $logStr .="\t They failed with error(s):\n\t\t$response\n";
             $printState = 0;
         }else{
    #Phase 2 if both parts of Phase 1 are passed
             ($printState, $response, my $logResponse) = chooseSuccess( \%in );
             $logStr .= $logResponse;
         }
    }
    if($printState eq 'login'){$printState = undef;}
    #revert back to printState in  HTML if it is set to 0
    $printState = $printState eq '0' ? $in{"printState"} : $printState;
    return ( $response, $logStr, $printState);    
}


#Runs first step of validation filtering out | ` - etc and puts all input in a
#useful hash
#returns a reference to a hash of the input or 'illegal'  to the first problem if
#dangerous characters were submited
sub retrieveInput{
    if($ENV{'CONTENT_LENGTH'} == 0){ return { 'printState' => undef } };
    my $length = $ENV{'CONTENT_LENGTH'};
    read( STDIN, my $in, $length );
    my (%in, @in);
    #ensure input can't be screwed with by adding = or &
    while($in =~ /(\%61|\%38)/){
        if (!$in{'illegal'}){
            $in{'illegal'} = '->Dangerous character(s) found in the form submission:\n| '
        }
        $in{'illegal'} .= $1 . " | " ; 
    }
    #unpack the HTML chars packed in form submition
    $in =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    @in = split( /&/, $in );
    foreach my $pair (@in) {
        #only acceptable characters will match
        if ($pair =~ /^([^`<>\|-]*)=([^`<>\|-]*)$/){ 
            $in{ $1 } = $2; 
        }else{
            if (!$in{'illegal'}){
                $in{'illegal'} = '->Dangerous character(s) found in the form submission:\n| '
            }
            $in{'illegal'} .= 'Key: ' . $1 . '  Value: ' . $2 . " | ";
        }
    }
    return \%in;
}

#prints out all data for current state
sub debug{
    my $in = %{shift @_};
    my $length = $ENV{'CONTENT_LENGTH'};
    read( STDIN, my $in, $length );
    print '_____________________________________<br />';
    print $in;
    my @in = split( /&/, $in );
    foreach my $pair (@in) {
        print $pair . "<br />"
    }
    print '_____________________________________<br />';

    foreach my $vars (sort keys %ENV) {
        print "<b>$vars</b>=";
        print "$ENV{$vars}<BR />"
    }
    foreach my $vars (sort keys %in) {
        print "<b>$vars</b>=";
        print "$in{$vars}<BR />"
    }
}

#            print '<script type="text/javascript">window.onload = function(){ window.location="pages/mkEmail.html" } </script>'; 
