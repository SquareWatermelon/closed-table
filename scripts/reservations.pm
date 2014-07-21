#!/usr/bin/perl
use strict;
use warnings;
use PDF::API2;

#Author:
#Raul Matias rem2174@columbia.edu
#Functions relating to the making of reservations

#Makes a reservation
sub mkReservation{
	my($day, $month, $year, $time, $name, $numberOfPeople, $phone, $userSubmitted) = @_;#the info needed for each reservation
	my $date = join("/", $month, $day, $year);#joins day month and year into day/month/year
    my $filename = "reservations.txt";#the file used to store reservations
    open(DATE, "<$filename") or die "can't open file";
	my $table = checkTable($date, $time, $name, $numberOfPeople);
	if($table == 0){return 0;}
	#gets an available table for the reservation
    while(<DATE>){
        chomp;     
        my ($dateMatch, $timeMatch, $tableMatch, $name, $numberOfPeople, $phone, $userSubmitted) = split(/:/, $_);
        if($dateMatch eq $date and $timeMatch eq $time and $tableMatch eq $table)#checks for conflicting reservations
		{
			close(DATE);
			return 0;
		}
    }
	my $info = join(":", $date, $time, $table, $name, $numberOfPeople, $phone, $userSubmitted);
	open(DATE, ">>$filename") or die "can't open file";
	print DATE "$info\n";#prints the reservation to file
    close(DATE);
    return 1;
}

#private sub for checking availability
sub checkAvailability{
	my ($date, $time, $table) = @_;
    my $filename = "reservations.txt";
	#each reservation consists of 4 time blocks. The following loop
	#ensures that a new reservation is not placed over an old reservation.
	#to that end, each reservation is checked by its reservation time
	#plus three hours before, and 3 hours after. That way it wont conflict
	#with an existing reservation.	
	my $i;
	my $lowerLimit = $time - 3;
	my $upperLimit = $time + 3;
	for($i = $lowerLimit; $i < $upperLimit; $i++){
    open(DATE, "<$filename") or die "can't open file";
		while(<DATE>){
		    chomp;
			if($_=~ /($date):($i):($table):([^:]*):([^:]*):([^:]*):([^:]*)/){
				return 0;
			}
		}
	}
	#close(DATE);
	return 1;
}

#private sub for checking for open table
sub checkTable{
	my ($date, $time, $name, $numberOfPeople) = @_;
	my $file = "tableList.txt";
	open(TABLE, "<$file") or die "can't open file";
	#looks for a table that has the capacity to accomodate the given reservation.
	#then call a helper method to check that the atble is not already occupied
	#on the given date and time.
	while(<TABLE>){
		my ($dummy, $tableNumber, $tableSize) = split(/:/, $_);
		if($numberOfPeople <= $tableSize){
			if(checkAvailability($date, $time, $tableNumber) == 1){#calls helper method
				close(TABLE);
				return $tableNumber;#returns table number of an available table
			}
		}
		#else{return 0;}#returns 0 if there is no empty table.
	}
	close (TABLE);
	return 0;#returs 0 if there is no table of the necessary size
}

#removes a reservation from the system, bases on the date, time, table, and name 
sub removeReservation{
    my ($day, $month, $year, $time, $name) = @_;
	my $date = join("/", $month, $day, $year);
    my $filename = "reservations.txt";
    my $tempFile = "tempfile.txt";
    open (DATE, "<$filename");
    open (TEMPFILE, ">>$tempFile");
	#searches for the reservation and prints out all reservations EXCEPT the matching reservation
	#into a new file. 
    while(<DATE>){
        my ($dateMatch, $timeMatch, $tableMatch, $nameMatch, $peopleMatch, $phoneMatch, $usernameMatch)  = split(/:/, $_);
        if($dateMatch eq $date and $timeMatch eq $time, and $nameMatch eq $name){next;}
        print TEMPFILE $_;
    }
    close (DATE);
    close (TEMPFILE);
    unlink $filename;
    rename $tempFile, $filename;
}

#returns the table reservations for a given date
sub getReservation{
	my ($day, $month, $year, $time, $table) = @_;
	my $date = join("/", $month, $day, $year);
	my $filename = "reservations.txt";
	open (DATE, "<$filename");
	my @appointment;# array used to store the appointments
	while(<DATE>){
		if($_=~ /($date):($time):($table):([^:]*):([^:]*):([^:]*):([^:]*)/){
				
			my $dateMatch = $1;
			my $timeMatch = $2;
			my $tableMatch = $3;
			my $name = $4;
			my $people = $5;
			my $number = $6;
			my $user = $7;			
			push @appointment, $name, $people, $number;
			return @appointment;
		}
	}
	close(DATE);
	return undef;
}

#helper method for PDF making
#returns the reservations for a given date.
sub getTableForPDF{
	my ($day, $month, $year) = @_;
	my $date = join("/", $day, $month, $year);
	my @tables;
	my $filename = "reservations.txt";
	open (DATE, "<$filename");
	while(<DATE>){
		my($dateMatch, $time, $table, $name, $numberOfPeople, $phone, $userSubmitted) = split(/:/, $_);
		if($dateMatch eq $date){
			my @reservations = [$dateMatch, $time, $table, $name, $numberOfPeople, $phone, $userSubmitted];
			push @tables, @reservations;
		}
	}
	return @tables;
	close(DATE);
}

sub printPDF{
	my ($day, $month, $year) = @_;
	my @array = getTableForPDF($day, $month, $year);
	#create a pdf file
	my $pdf = PDF::API2->new();
	#add page
	my $page = $pdf->page;
	#Add page size
	$pdf->mediabox('Letter');
	# Add font to the PDF
    my $font = $pdf->corefont('Helvetica-Bold');
	
	#print to page
	my $col = 700;
	#my $info;
	my $text;
	foreach my $row(@array){
	my $info;
		foreach my $val(@$row){
			$text = $page->text();
			$text->font($font, 16);
			$text->translate(0, $col -= 3);#moves text down one line
			$info.= "$val   ";
			#$text->text($info);
			if($col < 100)#adds addtional pages
			{
				$page = $pdf->page;
				$col = 700;
			}		
		}
		$text->text($info);

	}
	$pdf->saveas('/home/rmt2131/html/cs3157/data/reserve.pdf');#change this to suited location**	
}

1;
