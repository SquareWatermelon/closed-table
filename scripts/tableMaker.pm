#!/usr/bin/perl
use strict;
use warnings;

#Author
#Raul Matias rem2174@columbia.edu
#Functions relating to the creation of tables


#Stores a table. A table is represented by its seating capacity and a number.
sub makeTable{
    my $capacity = shift;
	my $tableNumber = getTotalTables() + 1;
	my $file = "tableList.txt";
	open(TABLE, ">>$file") or die "can't open file";
	#prints table info
	print TABLE "TABLE:$tableNumber:$capacity\n";
	close(TABLE);
}

#Returns the total amount of tables
sub getTotalTables{
	my $file = "tableList.txt";
	open(TABLE, "<$file") or die "can't open file";
    my $lines;
	#counts the tables
	while(<TABLE>){
		chomp;
        $lines++
    }
	return $lines;
	close(TABLE);
}

#Removes a table of the given capacity
sub removeTable{
	my $size = shift;
	my $file = "tableList.txt";
	my $tempFile = "temp.txt";
	my $reservations = "reservations.txt";
	open(TABLE, "<$file") or die "can't open file";
	open(TEMPFILE, ">>$tempFile");
	#Checks to see if the table is already reserved
	#If that is the case, the table cannot be deleted
	while(<RESERV>){
		if($_=~ /([^:]*):([^:]*):($size):([^:]*):([^:]*):([^:]*):([^:]*)/){
			return 0;
		}
	}
	my $i = 1;
	#searches file for table.
	#Writes data to new file EXCEPT the matching table
	while(<TABLE>){
		my ($table, $tableNum, $tableSize) = split(/:/, $_);
        if($size == $tableSize){
			$size = 0;
			next
		}
		#renumbers the tables
		my $info = join(":", $table, $i, $tableSize);
		$i++;
		print TEMPFILE "$info";
	}
	#closes files, deletes originals, and renames the tempfiles.
	close (TABLE);
    close (TEMPFILE);
    unlink $file;
    rename $tempFile, $file;
}

#used fo debugging. Prints the current tables
sub printTables{
	my $file = "tableList.txt";
	open(TABLE, "<$file") or die "can't open file";
	while(<TABLE>){
		chomp;
		my ($table, $tableNumber, $tableSize) = split(/:/, $_);
	}
	close(TABLE);
}

#Returns 1 if a table of the given capacity exists, returns 0 otherwise
sub tableExists{
	my $capacity = shift;
	my $file = "tableList.txt";
	open(TABLE, "<$file") or die "can't open file";
	while(<TABLE>){
		my ($dummy, $dummy2, $tableSize) = split(/:/, $_);
        if($capacity == $tableSize){
			return 1;
		}
	}
	close(TABLE);
	return 0;
}

#Returns the current capacity of the restaurant
sub restaurantCapacity{
	my $capacity;
	my $file = "tableList.txt";
	open(TABLE, "<$file") or die "can't open file";
	while(<TABLE>){
		chomp;
		my ($table, $dummy2, $tableSize) = split(/:/, $_);
		$capacity += $tableSize;
	}
	close(TABLE);
	return $capacity;
}

#returns the capacity of the table
sub getTableSize{
	my $tableMatch = shift;
	my $file = "tableList.txt";
	open(TABLE, "<$file") or die "can't open file";
	while(<TABLE>){
		my ($dummy, $tableNumber, $tableSize) = split(/:/, $_);
        if($tableMatch == $tableNumber){
			return $tableSize;
		}
	}
	close(TABLE);
	return 0;
}

#Checks to see if the table is already reserved
#If that is the case, the table cannot be deleted
sub isTableOccupied{
	my $table = shift;
	my $reservations = "reservations.txt";
	open(RESERV, "<$reservations");
	while(<RESERV>){
		if($_=~ /([^:]*):([^:]*):($table):([^:]*):([^:]*):([^:]*):([^:]*)/){
			return 0;
		}
	}
	return 1;
}

1;
