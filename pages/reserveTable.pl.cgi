        print 'Content-type: text/html\n\n';

    #print the other rows;
    for(my $i = 0; $i < $tableNum; $i++){
        $evenOdd = $evenOdd eq 'even' ? 'odd' : 'even';
    print <<END_PRINT;
        <table width="100%"> 
            <tr class="$evenOdd">
                <th align="left" class="side" scope="row">Table&nbsp;$i<br />
                </th>
END_PRINT
        for(my $j = 0; $j < $totalSpan; $j++){
            my $reservation = $tables[$i]{ $j + $startTime };
            if($reservation){
                my $span = $j + 4 < $totalSpan  ? 4 : $totalSpan - $j;
                my $tempBlock = 100 / $span;
                my $time = getTime($startTime+$j);
                $j += $span - 1;
                print <<END_PRINT;
                <td width="$tempBlock%" colspan="$span"
                onclick="updateCancel('$reservation', '2', '$time', '1/1/1', '5555555555')" >
                    $reservation</td>
END_PRINT
            }else {
                print <<END_PRINT;
                <td width="$blocksize%">&nbsp;</td>
END_PRINT
            }
        }
        print <<END_PRINT;
            </tr>
END_PRINT
        }
        $totalSpan+=1;
        print <<END_PRINT;
            <tr class="spacer">
                <th colspan = "$totalSpan">&nbsp;</th>
            </tr>
        </table>
END_PRINT
}
