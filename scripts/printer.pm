#Author Robert "Square Watermelon" Tolda
#Phase 3 Printa out alerts and the log to provide information about event and
#   Print out appropriate page.
#*******************************************************************************
use strict;
use misc;
use tablePrinter;
use navPrinter;
use userDatabase;
use reservations;
use Switch;
use logger;

#Phase 3 Print out the appropriate info to page and log
sub display{
    my $response = shift;
    my $logStr = shift;
    my $printState = shift;
    my %in = %{shift @_};
    my $user = $in{'userName'};
    
    #print to log
    open (my $LOGH, '>>data/log.txt') || {$response = "Could not write to log!"};
    print $LOGH $logStr;
    close($LOGH);
    
    #print top of the page
    printPage('header', '');
    print "<body>";
    
    #give user the response to their last action
    if($response){ alert($response) }
    
    #print debug(\%in);
    switch($printState){
            case 'mkEmail'      { printPage('mkEmail', '') }
            case undef          { 
                my $ie = $ENV{'HTTP_USER_AGENT'};
                if ($ie =~ /MSIE/) {
                    alert('Internet Explorer not Recomended');
                }
                printPage('login', '') 
            }
            case 'PDF'          { openPDF( $user ); }
            case 'userActivity' {
                printNav( $user );
                my $printUser = '';
                my $pLog;
                $printUser .= $in{'rmUserName'};
                if( $printUser ne ''){
                    $pLog = getLog( $printUser );
                }elsif(isAdmin($user)){
                    $pLog = getLog( '' );
                }else{
                    $pLog = getLog( $user );
                }
                print '
        <div class="center4">'.$pLog.'</div>';
            }
            case 'reserve'      { openReserve($user, \%in ) }
            case 'rmUser'       {
                my $userList = getUserSelector();
                printNav( $user );
                printPageIns( 'rmUser', $user, $userList );
            }
            case 'startMyLog'       {
                my $userList = getUserSelector();
                printNav( $user );
                printPageIns( 'startMyLog', $user, $userList );
            }
            else                { 
                printNav( $user );
                printPage($printState, $user);
            }
        }
    print "</body></html>";
}

################################################################################
# Page printing subs
################################################################################
sub openPDF{
    my $user = shift;
    print '<script type="text/javascript">window.onload = function(){ window.open("data/reserve.pdf") } </script>';
    printNav( $user );
    if(isAdmin($user)){
        printPage('adminHome');
    }else{
        printPage('userHome');
    }
}

sub openReserve{
    my $user = shift;
    my %in = %{shift @_};
    printNav( $user );
    my $start = getBlock($in{'startTime'});
    my $end = getBlock($in{'endTime'});
    my $date = $in{'date'};
    # a little bit of a hack but adds some hidden fields to keep track of the
    # present times on display last "> included in page
    my $temp = $user . '">';
    $temp .= '<input type="hidden" name="date" value="' . $in{'date'} . '">';
    $temp .= '<input type="hidden" name="startTime" value="' . $in{'startTime'} . '">';
    $temp .= '<input type="hidden" name="endTime" value="' . $in{'endTime'};

    #check if the user is running IE
    my $ie = $ENV{'HTTP_USER_AGENT'};
    if ($ie =~ /MSIE/) {
        printIETables($date, $start, $end);
        printPage( "reserveIE", $temp );
    }else{
        printTables($date, $start, $end);
        printPage( "reserve", $temp );
    }
}

#print javascript that will alert the user to the given info.
sub alert{
    my $alert = shift;
    print <<END_PRINT;
<script type="text/javascript">window.onload = function(){alert('$alert')}</script>
END_PRINT
}

#Prints the given page.
sub printPage {
    my $page = shift;
    my $userName = shift;
    local $/= undef;
    open ( my $FH, "pages\/$page.html");
    my $out = <$FH>;
    $out =~ s/!!userName!!/$userName/seg;
    print "$out";
}

#Prints the given page with the given string inserted.
sub printPageIns {
    my $page = shift;
    my $userName = shift;
    my $insert = shift;
    local $/= undef;
    open ( my $FH, "pages\/$page.html");
    my $out = <$FH>;
    $out =~ s/!!userName!!/$userName/seg;
    $out =~ s/!!insert!!/$insert/seg;
    print "$out";
}

#gives an html list full of the users
sub getUserSelector {
    my @users = userList();
    my $out = '
        <select name="rmUserName" >';
    foreach (@users){
        $out .='
            <option value="' . $_ . '">' . $_ . '</option>';
    }
    $out .='
        </select>';
    return $out;
}

1;