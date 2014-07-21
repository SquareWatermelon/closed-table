#Author Robert "Square Watermelon" Tolda
#For functions that only handle logging
################################################################################

use strict;

#returns the complete log if passed '' or a of a user if passed their name.
sub getLog{
    my $user = shift;
    local $/= undef;
    open (my $PLOGH, 'data/log.txt') || alert("Could Not Open Log!");
    my $pLog = <$PLOGH>;
    $pLog = formatLog($pLog, $user);
    close($PLOGH);
    return $pLog;
}

#formats the log according to the user or for all users (if passed '')
sub formatLog{
    my $pLog = shift;
    my $user = shift;
    my $break = '<br />';
    my $arrow = '->';
    my $htmlArrow = '<br />--&gt;';
    my $htmlTab = '&emsp;&emsp;&emsp;';

    $pLog .= $break . 'End of Log';
    if($user ne ''){
        my $newLog = '';
        while ($pLog =~ m/$arrow(User $user attempted)([^-]*)($arrow|End of Log)/g){
            $newLog .= ($2) . $break;
        }
        $pLog = $newLog;
        $pLog =~ s/They //seg;
    }
    $pLog =~ s/\n/$break/seg;
    $pLog =~ s/$arrow/$htmlArrow/seg;
    $pLog =~ s/\t/$htmlTab/seg;
    $htmlTab = $break . '&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;';
    $pLog =~ s/\\n/$htmlTab/seg;
    return $pLog;
}

1;