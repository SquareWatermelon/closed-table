#!/usr/bin/perl
#Author Raul
use strict;
use warnings;
use DBM::Deep;

#Stores a table. A table is represented by its seating capacity.
sub makeTable{
    my $capacity = shift;
	my $tables = DBM::Deep->new(
		file => "tables.db",
		type => DBM::Deep->TYPE_ARRAY,
	);
	my %timeslots;
	my @table = (\%timeslots, $capacity);
	$tables->push(\@table);
	#$tables->push();
    #$tables->push($capacity);	
}

#Returns the total amount of tables
sub getTotalTables{
	my $tables = DBM::Deep->new(
	    file => "tables.db",
	);
	return $tables->length();
}

#Removes a table of the given capacity
sub removeTable{
	my $capacity = shift;
	my $tables = DBM::Deep->new(
		file => "tables.db",
        type => DBM::Deep->TYPE_ARRAY,
	);
	my $index = 0;
	for(my $i = 0; $i < $tables->length(); $i++){
		if($tables->[$i]->[1] == $capacity){
			$tables->splice($index, 1);
			return 1;
		}
		$index++;
		return 0;
	}
}

#used fo debugging. Prints the current tables
#sub printTables{
#	my $tables = DBM::Deep->new(
#		file => "tables.db",
#	)
#	for($i = 0; $i < $tables->length(); $i++){
#		print $tables->[$i]->[1];
#	}
#}

#Returns 1 if a table of the given capacity exists, returns 0 otherwise
sub tableExists{
	my $capacity = shift;
	my $tables = DBM::Deep->new(
		file => "tables.db",
	);
	for(my $i = 0; $i < $tables -> length(); $i++){
		if($tables->[$i] == $capacity){
			return 1;
		}
		return 0;
	}
}

#Returns the current capacity of the restaurant
sub restaurantCapacity{
	my $tables = DBM::Deep->new(
		file => "tables.db",
	);
	my $capacity;
	for(my $i = 0; $i < $tables->length(); $i++){
		$capacity += $tables->[$i];
	}
	return $capacity;
}

1;
