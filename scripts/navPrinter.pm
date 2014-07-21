#Author: Robert "Square Watermelon" Tolda
#Contains page printing subs for Closed Table
################################################################################

use strict;


#prints the Navigation bar at the top of the screen
sub printNav{
    my $user = shift;
    my $form = getNavForm($user);
    print <<END_PRINT;
<!-- Title Bar -->
  <table width="100%" border="0" align="center" cellpadding="6" cellspacing="0" class="Navigation" summary="Closed Table Navigation">
    <tr>
      <td width="250">
        <div class="float">
            <img src="images/armsmall.png" height="36" alt="Thumbs Up!" />
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


#Returns a string containing the appropriate navigation bar links for the user
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
            <a href="javascript: setPrintState(\'userHome\')">Home</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(\'userActivity\')">My&nbsp;Activity</a>&nbsp;|&nbsp;'
    }else{ 
        $out .= '
            <a href="javascript: setPrintState(\'adminHome\')">Home</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(\'users\')">Users</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(\'tables\')">Tables</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(\'setPDF\')">Create&nbsp;PDF</a>&nbsp;|&nbsp;
            <a href="javascript: setPrintState(\'userActivity\')">User&nbsp;Activity</a>&nbsp;|&nbsp;';
    }
    $out .= '
            <a href="javascript:setPrintState(\'startReserve\')">Reservations</a>&nbsp;|&nbsp;
            <a href="javascript:setPrintState(\'mkPassword\')">Change&nbsp;Password</a>
        </form>';
    return $out;
}

1;
