#Author Robert "Square Watermelon" Tolda
#Takes the given state and performs the appropriate action.
#returns the page to print
#and the message to give the user
#and the message to write to the log.
################################################################################

use strict;
#use Switch;
use v5.10.1;
use misc;
#use test;
use tableMaker;
use userDatabase;
use reservations;
#use tables;

#current format        mkReserve($mkName, $mkNumber, $mkBlock, $mkPhone, @mkDate);

#Takes the given state and performs the appropriate action.
#returns the page to print
#and the message to give the user
#and the message to write to the log.
sub chooseSuccess{
    my %in = %{shift @_};
    my $state = $in{'state'};
    for($state){
    when ("getTables")    {
        my ($startTime, $endTime, $date) = 
            ($in{'startTime'}, 
             $in{'endTime'}, 
             $in{'date'});
        return ('reserve', 
                0,
                "\tThey viewed tables from $startTime to $endTime on $date.\n")
    }
    when ("mkPDF")    {
        my $date = $in{'date'};
        my ($month, $day, $year) = split ( /\D/, $date);
        printPDF( $day, $month, $year );
        return ('PDF', 
                0,
                "\tThey viewed a tables PDF from $date.\n")
    }
    when ("mkTPass")      {
        my $emailUser = $in{'emailUser'};
        tempPassword( $emailUser );
        return ('login', 
                'Email Sent',
                "\tThey had there password changed via forgot password.\n");
    }
    when ("mkPassword")   { 
        updatePassword($in{'userName'}, $in{'newPassword'});
        my $ps = isAdmin($in{'userName'}) ? 'adminHome' : 'userHome';
        return ($ps,
                'Password Changed!: )',
                "\tThey successfully changed their password.\n");
    }
    when ("mkReserve")    {
        my ($mkName, $mkNumber, $mkDate, $mkTime, $mkPhone, $user) = 
            ($in{'mkName'}, $in{'mkNumber'}, $in{'mkDate'}, $in{'mkTime'}, 
            $in{'mkPhone'}, $in{'userName'});
        my $mkBlock = getBlock($mkTime);
        my ($month, $day, $year ) = split ( /\D/, $mkDate);
        mkReservation($day, $month, $year, $mkBlock, $mkName, $mkNumber, $mkPhone, $user);
#        mkReserve($mkName, $mkNumber, $mkBlock, $mkPhone, @mkDate);
    return ('reserve',
            'Reservation Made',
            "\tThey successfully made a reservation under $mkName for $mkNumber"
            . " on $mkDate at $mkTime.\n" );
    }
    when ("mkTable")      {
        my $mkTableNumber = $in{'mkTableNumber'};
        makeTable($mkTableNumber);
        return ( 'adminHome',
                'Table Made! : )',
                "\tThey successfully added a table of size $mkTableNumber.\n");
    }
    when ("mkUser")       {
        my ( $mkUserName, $mkPassword, $mkEmail, $mkAdmin ) = 
            ($in{'mkUserName'}, $in{'mkPassword'}, $in{'mkEmail'}, $in{'isAdmin' });
        $mkAdmin = ($mkAdmin eq 'isAdmin') ? 1 : 0;
        mkUser($mkUserName, $mkEmail, $mkPassword, $mkAdmin);
        return ( 'adminHome',
                 'User Made!^___^',
                 "\tThey successfully added a user named $mkUserName.\n");
    }
    when ("rmReserve")    {
        my ($rmName, $rmNumber, $rmTime, $rmDate) = 
            ($in{'rmName'},
            $in{'rmNumber'},
            $in{'rmTime'},
            $in{'rmDate'});
        my $rmBlock = getBlock($rmTime);
        my ($month, $day, $year) = split (/\D/, $rmDate);
#        print "$day, $month, $year, $rmBlock, $rmName";
        removeReservation($day, $month, $year, $rmBlock, $rmName);
        return ('reserve',
                'Reservation Removed.',
                "\tThey successfully removed a reservation for $rmNumber under" . 
                "$rmName at $rmTime on $rmDate.\n");
    }
    when ("rmTable")      {
        my $rmTableNumber = $in{'rmTableNumber'};
        removeTable($rmTableNumber);
        return ('adminHome',
                'Table Removed',
                "\tThey successfully removed a table of size $rmTableNumber.\n");
    }
    when ("rmUser")       {
        my $rmUserName = $in{'rmUserName'};
        rmUser($rmUserName);
        return ('adminHome',
                'User Removed',
                "\tThey successfully removed a user named $rmUserName.\n");
    }
    when ("startMyLog")   {
        my $rmUserName = $in{'rmUserName'};
        return ('userActivity',
                '',
                "\tThey veiwed the log of $rmUserName.\n");
        
    }
    when ("tryLogin")     {
        my $ps = isAdmin($in{'userName'}) ? 'adminHome' : 'userHome';
        return ($ps,
                0,
                "\tThey successfully logged in.\n");
    }
    default                { 
        return (0,
                'Bad submission error 13!' . $in{"state"},
                'Bad submission error 13!' . $in{"state"});
    }
    }
}

1;
