#Author: Robert "Square Watermelon" Tolda
#Contains Table printing subs
################################################################################

use tableMaker;

#print the reservation tables for not IE
sub printTables{
#    my @tables = @{ shift @_ };
    my $date = shift;
    my $startTime = shift;
    my $endTime = shift;
    my ($month, $day, $year) = split ( /\D/, $date );
    my $totalSpan = $endTime - $startTime;
    my $tableNum = getTotalTables();
    my $blocksize = int(684 / ($totalSpan)) - 8;
    my $evenOdd = 'odd';
    my $px = 'px';
    my $j = -3;
    #Print the table head
    print <<END_PRINT;
    <div class="mainTable">
        <div class="TLcorner"><img src="images/corner.png" width="11" height="11" /></div>
        <div class="TRcorner"><img src="images/TRcorner.png" width="11" height="11" /></div>
            <div class="topShell" style="width: 800$px; height: 40$px">
                <div style="width: 96$px; height: 40$px" align="right" class="corner" >&nbsp;</div>
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
    $blocksize -= 8; #for borders and margins
    for(my $i = 1; $i <= $tableNum; $i++){
        $evenOdd = $evenOdd eq 'even' ? 'odd' : 'even';
        my $size = getTableSize($i);
        print <<END_PRINT;
                <div style="width:790$px; height: 44$px; float:left">
                    <div style="width: 96$px; height: 40$px" align="left" class="side">
                        Table&nbsp;$i<br />
                        <span style="font-size: 12px">size&nbsp;$size</ppan>
                    </div>
END_PRINT
        $j = -3;
        while($j < $totalSpan ){
            my $time = getTime($startTime+$j);
            my $block = $startTime+$j;
            my @reserve = getReservation( $day, $month, $year, $block, $i);
            if($reserve[0] ){
                my ($name, $number, $phone) = @reserve;
                my $span;
                if($j < 0 ){
                    $span = 4 + $j;
                    $j = $span;
                }else{
                    $span = $j + 4 < $totalSpan  ? 4 : $totalSpan - $j;
                    $j += $span;
                }
                my $tempBlock = $blocksize * $span + ($span - 1 ) * 16 - 1;# for every missed border and margin
                if($span == 1){$tempBlock+=1}
                print <<END_PRINT;
                    <div class="$evenOdd" style="width: $tempBlock$px; height: 40$px"
                    onclick="updateCancel('$name', '$number', '$time', '$date', '$phone')" >
                        $name</div>
END_PRINT
            }else{
                if($j >= 0 ) {
                    print <<END_PRINT;
                        <div class="$evenOdd" style="width: $blocksize$px; height: 40$px"
                        onclick="updateReserve('$time', '$date')">&nbsp;</div>
END_PRINT
                }
                $j++;
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

#print the reservation tables for IE
sub printIETables{
    my $date = shift;
    my $startTime = shift;
    my $endTime = shift;
    my ($month, $day, $year) = split ( /\D/, $date );
    my $totalSpan = $endTime - $startTime;
    my $tableNum = getTotalTables();
    my $blocksize = int(684 / ($totalSpan)) - 8;
    my $evenOdd = 'odd';
    my $px = 'px';
    my $j = -3;
    #Print the table head
    print <<END_PRINT;
    <div class="mainTable">
        <div class="TLcorner"><img src="images/corner.png" width="11" height="11" /></div>
        <div class="TRcorner"><img src="images/TRcorner.png" width="11" height="11" /></div>
            <div class="topShell" style="width: 800$px; height: 40$px">
                <div style="width: 96$px; height: 40$px" align="right" class="corner" >&nbsp;</div>
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
    $blocksize = 684 / $totalSpan - 16; #for borders and margins
    for(my $i = 1; $i <= $tableNum; $i++){
        $evenOdd = $evenOdd eq 'even' ? 'odd' : 'even';
    print <<END_PRINT;
                <div style="width:800$px; height: 44$px; float:left">
                    <div style="width: 96$px; height: 40$px" align="left" class="side">Table&nbsp;$i<br /></div>
END_PRINT
        $j = -3;
        while($j < $totalSpan ){
            my $time = getTime($startTime+$j);
            my $block = $startTime+$j;
            my @reserve = getReservation( $day, $month, $year, $block, $i);
            if($reserve[0] ){
                my ($name, $number, $phone) = @reserve;
                my $span;
                if($j < 0 ){
                    $span = 4 + $j;
                    $j = $span;
                }else{
                    $span = $j + 4 < $totalSpan  ? 4 : $totalSpan - $j;
                    $j += $span;
                }
                my $tempBlock = ($blocksize + 12) * $span;# for every missed border 
                print <<END_PRINT;
                    <div class="$evenOdd" style="width: $tempBlock$px; height: 40$px"
                    onclick="updateCancel('$name', '$number', '$time', '$date', '$phone')" >
                        $name</div>
END_PRINT
            }else{
                if($j >= 0 ) {
                    print <<END_PRINT;
                        <div class="$evenOdd" style="width: $blocksize$px; height: 40$px"
                        onclick="updateReserve('$time', '$date')">&nbsp;</div>
END_PRINT
                }
                $j++;
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
1;