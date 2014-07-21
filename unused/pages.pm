#contains pages for Closed Table
use strict;
use misc;

my $c = clear();

sub printNav{
    my $user = shift;
    my $form = getNavForm($user);
    print <<END_PRINT;
    <!-- Title Bar -->
  <table width="100%" border="0" align="center" cellpadding="6" cellspacing="0" class="Navigation" summary="Closed Table Navigation">
    <tr>
      <td width="250">
        <div class="float">
            <img src="insert_img_here" height="30" width="94" alt="insert_img_here" />
        </div>
      </td>
      <td align="left">
        $form
      </td>
      <td align="right">
        Signed in as $user&nbsp;|&nbsp;
        <a href="ClosedTable.pl.cgi" title="SignOut">Sign&nbsp;Out</a>
      </td>
    </tr>
  </table>
END_PRINT
}

#sub printTables{
#    my @tables = @{ shift @_ };
#    my $startTime = shift;
#    my $endTime = shift;
#    my $date = "1/1/1";
#    my $totalSpan = $endTime - $startTime;
#    my $tableNum = scalar @tables;
#    my $blocksize = 800 / ($totalSpan + 1);
#    my $evenOdd = 'odd';
#    my $px = 'px';
#    #Print the table head
#    print <<END_PRINT;
#    <div class="center4">
#    <div style="position: relative">
#        <div class="TLcorner">
#            <img src="images/corner.png" width="11" height="11" />
#        </div>
#        <div class="tableContainer">
#        <table class="Main" width="800" border="1" cellspacing="0"
#            cellpadding="3">
#          <thead class="fixedHeader" width="800">
#            <tr class="top">
#                <th style="width: $blocksize$px" align="right" class="corner" width="$blocksize">&nbsp;</th>
#END_PRINT
#    for(my $i = 0; $i < $totalSpan; $i++){
#        my $time = getTime($startTime+$i);
#        print <<END_PRINT;
#                <th style="width: $blocksize$px" width="$blocksize" class="top">
#                $time   
#                </th>
#END_PRINT
#    }
#    print <<END_PRINT;
#            </tr>
#          </thead>
#          <tbody class="scrollContent" width="800">
#END_PRINT
#    #print the other rows;
##    my $blocksize = 784 / ($totalSpan + 1);
#    for(my $i = 0; $i < $tableNum; $i++){
#        $evenOdd = $evenOdd eq 'even' ? 'odd' : 'even';
#    print <<END_PRINT;
#            <tr class="$evenOdd">
#                <th style="width: $blocksize$px" width="$blocksize" align="left" class="side">Table&nbsp;$i<br />
#                </th>
#END_PRINT
#        for(my $j = 0; $j < $totalSpan; $j++){
#            my $time = getTime($startTime+$j);
#            my $reservation = $tables[$i]{ $j + $startTime };
#            if($reservation){
#                my $span = $j + 4 < $totalSpan  ? 4 : $totalSpan - $j;
#                my $tempBlock = $j + 4 < $totalSpan ? $blocksize * $span : $blocksize * $span - 16;
#                $j += $span - 1;
#                print <<END_PRINT;
#                <td style="width: $tempBlock$px" width="$tempBlock" colspan="$span"
#                onclick="updateCancel('$reservation', '2', '$time', '$date', '5555555555')" >
#                    $reservation</td>
#END_PRINT
#            }else {
#                if ($j == $totalSpan - 1){
#                    my $temp = $blocksize - 16;
#                    print <<END_PRINT;
#                <td style="width: $temp$px" width="$temp"
#                onclick="updateReserve('$time', '$date')" >
#                >&nbsp;</td>
#END_PRINT
#                }
#                else{
#                print <<END_PRINT;
#                <td style="width: $blocksize$px" width="$blocksize"
#                onclick="updateReserve('$time', '$date')">&nbsp;</td>
#END_PRINT
#                }
#            }
#        }
#        print <<END_PRINT;
#            </tr>
#END_PRINT
#        }
#        my $temp = $totalSpan + 1;
#        print <<END_PRINT;
#            <tr class="spacer">
#                <th colspan = "$temp">&nbsp;</th>
#            </tr>
#          </tbody>
#        </table>
#      </div>
#    </div>
#</div>
#END_PRINT
#}


sub printTables{
    my @tables = @{ shift @_ };
    my $startTime = shift;
    my $endTime = shift;
    my $date = "1/1/1";
    my $totalSpan = $endTime - $startTime;
    my $tableNum = scalar @tables;
    my $blocksize = (704 / ($totalSpan)) - 8;
    my $evenOdd = 'odd';
    my $px = 'px';
    #Print the table head
    print <<END_PRINT;
    <div class="mainTable">
        <div class="TLcorner"><img src="images/corner.png" width="11" height="11" /></div>
        <div class="TRcorner"><img src="images/TRcorner.png" width="11" height="11" /></div>
            <div class="topShell" style="width: 800$px; height: 40$px">
                <div style="width: 76$px; height: 40$px" align="right" class="corner" >&nbsp;</div>
END_PRINT
    for(my $i = 0; $i < $totalSpan - 1; $i++){
        my $time = getTime($startTime+$i);
        print <<END_PRINT;
                <div style="width: $blocksize$px; height: 40$px" class="top">$time</div>
END_PRINT
    }
    {#print the last one without the right border
        my $time = getTime($endTime);
        print <<END_PRINT;
                <div style="width: $blocksize$px; height: 40$px; border-right-width: 0px" class="top" >$time</div>
END_PRINT
    }
    print <<END_PRINT;
            </div>
<div class="tableContainer">
            <div class="scrollContent" style="width: 790$px">
END_PRINT
    #print the other rows;
    my $blocksize = 704 / ($totalSpan) - 16; #for borders and margins
    for(my $i = 1; $i <= $tableNum; $i++){
        $evenOdd = $evenOdd eq 'even' ? 'odd' : 'even';
    print <<END_PRINT;
                <div style="width:790$px; height: 44$px; float:left">
                    <div style="width: 76$px; height: 40$px" align="left" class="side">Table&nbsp;$i<br /></div>
END_PRINT
        for(my $j = 0; $j < $totalSpan; $j++){
            my $time = getTime($startTime+$j);
            my $reservation = $tables[$i]{ $j + $startTime };
            if($reservation){
                my $span = $j + 4 < $totalSpan  ? 4 : $totalSpan - $j;
                my $tempBlock = $blocksize * $span + ($span - 1 ) * 16 - 1;# for every missed border and margin $j + 4 < $totalSpan ? $blocksize * $span : $blocksize * $span - 16;
                $j += $span - 1;
                print <<END_PRINT;
                    <div class="$evenOdd" style="width: $tempBlock$px; height: 40$px"
                    onclick="updateCancel('$reservation', '2', '$time', '$date', '5555555555')" >
                        $reservation</div>
END_PRINT
            }else {
                if ($j == $totalSpan - 1){
                    my $temp = $blocksize;# - 16;
                    print <<END_PRINT;
                    <div class="$evenOdd" style="width: $temp$px; height: 40$px"
                    onclick="updateReserve('$time', '$date')" >
                    &nbsp;</div>
END_PRINT
                }
                else{
                print <<END_PRINT;
                    <div class="$evenOdd" style="width: $blocksize$px; height: 40$px"
                    onclick="updateReserve('$time', '$date')">&nbsp;</div>
END_PRINT
                }
            }
        }
        print <<END_PRINT;
                </div>
END_PRINT
        }
        my $temp = $totalSpan + 1;
        print <<END_PRINT;
            <div class="spacer">&nbsp;</div>
            </div>
        </div>
    </div>
END_PRINT
}

sub getNavForm{
    my $user = shift;
    my $isAdmin = isAdmin($user);
    my $out = '
        <form id="navForm" name="form" action="ClosedTable.pl.cgi" method="post" >         
            <input type="hidden" name="state" value="skip">
            <input type="hidden" name="printState" id="printState" value="startReserve">
            <input type="hidden" name="userName" value="' . $user . '">';
    if(!$isAdmin){ 
        $out .= '
            <a href="javascript: setPrintState(this, \'userHome\')">Home</a>&nbsp;|&nbsp;'
    }else{ 
        $out .= '
            <a href="javascript: setPrintState(this, \'adminHome\')">Home</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(this, \'users\')">Users</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(this, \'tables\')">Tables</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(this, \'mkPDF\')">Create&nbsp;PDF</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(this, \'userActivity\')">User&nbsp;Activity</a>&nbsp;|&nbsp;';
    }
    $out .= '
            <a href="javascript:setPrintState(this, \'startReserve\')">Reservations</a>&nbsp;|&nbsp;
            <a href="javascript:setPrintState(this, \'mkPassword\')">Change&nbsp;Password</a>&nbsp;|&nbsp;
        </form>';
    return $out;
}

1;
