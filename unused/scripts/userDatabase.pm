#!/usr/bin/perl
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);

#Author:
#Raul Matias rem2174@columbia.edu
#Functions relating to creating users


#returns 1 if the user already exists
sub userExists{
    my $user = shift;
    my ($userCheck, $dummy, $dummy2);
    my $filename = "users.txt";
	#searches userfile for username
    open(USERS, "<$filename") || die "couldn't open file";
    while(<USERS>){
        chomp;
        ($userCheck, $dummy, $dummy2) = split(/:/, $_);
        if($userCheck eq $user){
            close(USERS);
            return 1;    
        }
    }
    
    close(USERS);
    return 0;
}

#Returns the current users.
sub userList{
    my ($user, $dummy, $dummy2);
    my $filename = "users.txt";
	my @userList;
    open(USERS, "<$filename") || die "couldn't open file";
    while(<USERS>){
        ($user, $dummy, $dummy2) = split(/:/, $_);
		push @userList, $user;
    }
    
    close(USERS);
    return @userList;# The array of user names
}

#Stores username and password in a file named "users.txt"
#The password is scrambled using MD5 before being stored.
sub mkUser{
    my ($username, $email, $userPass, $isAdmin) = @_;   
    my $filename = "users.txt";
    my ($scrambledPass, $userCheck, $dummy, $dummy2, @entries);
	#opens file for reading
	#checks if user already exists. Returns 0 in that case
    open USERS, "<$filename" || die "couldn't open file";
    while(<USERS>){
        my ($userCheck, $dummy, $dummy2) = split(/:/, $_);
        if($userCheck eq $username){return 0};
    }
	#creates encrypted password
    $scrambledPass = md5_hex($userPass);
	#opens file for writing
	open USERS, ">>$filename" || die "couldn't open file";
	#print the user info into the file ":" used as delimiter
	print USERS "$username\:$email\:$scrambledPass\n";
	#if the user is an admin, writes the user into the admin file
	if($isAdmin == 1){
		open(ADMIN, ">>admin.txt");
		print ADMIN "$username\n";
		close(ADMIN);
	}
    close(USERS);
    return 1;
}

#removes user
sub rmUser{
    my $username = shift;
    my $filename = "users.txt";
	my $adminFile = "admin.txt";
	my $adminTemp = "adminTemp.txt";
    my $tempFile = "tempfile.txt";
	#opens files for reading
    open (USERS, "<$filename")|| die "couldn't open file";
	open(ADMIN, "<$adminFile")|| die "couldn't open file";
	#opens files for writing
    open (TEMPFILE, ">>$tempFile")|| die "couldn't open file";
	open (ADMINTEMP, ">>$adminTemp")|| die "couldn't open file";
	#searches file for username.
	#Writes data to new file EXCEPT the matching username
    while(<USERS>){
        my ($temp, $dummy, $dummy2)  = split(/:/, $_);
        if($temp eq $username){next;}
        print TEMPFILE $_;
    }
	#does the same as above if user is an admin
	while(<ADMIN>){
		chomp;
		my $temp = $_;
        if($temp eq $username){next;}
        print ADMINTEMP "$_\n";
    }
	#closes files, deletes originals, and renames the tempfiles.
    close (USERS);
    close (TEMPFILE);
    unlink $filename;
    rename $tempFile, $filename;
    close (ADMIN);
    close (ADMINTEMP);
    unlink $adminFile;
    rename $adminTemp, $adminFile;
}

#returns 1 if the email belongs to the user
sub isUsersEmail{
    my($user, $email) = @_;
    my $filename = "users.txt"; 
	#opens file for reading
	#checks for matching user and email  
    open(USERS, "<$filename")|| die "couldn't open file";
    while(<USERS>){
        chomp;
        my ($userCheck, $emailCheck, $dummy) = split(/:/, $_);
        if($userCheck eq $user && $emailCheck eq $email){
            close(USERS);
            return 1;
        }
    }
    close(USERS);
    return 0;
}

#checks to see if the user is an admin
sub isAdmin{
	my $user = shift;
	#opens file for reading
	#checks for matching username
	open(ADMIN, "+<admin.txt")|| die "couldn't open file";
	while(<ADMIN>){
		chomp;
		my $admin = $_;
		if($user eq $admin){
			close(ADMIN);
			return 1;
		}
	}
	close(ADMIN);
	return 0;
}
#Creates a temporary password fo the user.
#Updates "users.txt"
#emails user the temp password.
sub tempPassword{
    my $username = shift;    
    my $filename = "users.txt";
    my $tempFile = "temp_users.txt";
    my $message = "Here is your temporary password, please change your password
        as soon as possible\n\n";
    my $passSize = 12; #password size is 12
    my $output;
    my $tempPass = generatePassword($passSize);#calls helper function
	#encrypts password
    my $scrambledPass = md5_hex($tempPass);
    my($name, $email, $pass);
	#opens file for reading and temp file for writing
	#checks for matching user
    open(USERS, "<$filename")|| die "couldn't open file";
    open(TEMPFILE, ">>$tempFile")|| die "couldn't open file";
    while(<USERS>){
        ($name, $email, $pass) = split(/:/, $_);
        if($name eq $username){
			#updates user record
            $output = join(":", $username, $email, $scrambledPass);            
            next;
        }
        print TEMPFILE $_;   
    }
	#closes files, deletes originals, and renames the tempfiles.
    print TEMPFILE "$output\n";#prints to temp file
    close (TEMPFILE);
    close (USERS);
    unlink $filename;
    rename $tempFile, $filename;
    
	#emails user a new password
	#email script borrowed from lab assignment
    open (MAILH, "|mail -s \"Recovery password\" $email") || die "cant open mail";
    print MAILH "$message $tempPass";
    close (MAILH);    
}

#Updates the user's password.
sub updatePassword{
    my($username, $newPassword) = @_;
    my $filename = "users.txt";
    my $tempFile = "temp.txt";
    my $temp;
    my $scrambledPass = md5_hex($newPassword);
	#opens file for reading and temp file for writing
    open (TEMPFILE, ">>$tempFile")|| die "couldn't open file";
    open (USERS, "<$filename")|| die "couldn't open file";
    while(<USERS>){
        my ($name, $email, $password) = split(/:/, $_);
        if($name eq $username){
            $temp = join(":", $name, $email, $scrambledPass);
            next;
        }
        print TEMPFILE $_;
    }
	#closes files, deletes originals, and renames the tempfiles.
    print TEMPFILE $temp;
    close USERS;
    close TEMPFILE;
    unlink $filename;
    rename $tempFile, $filename;
    
}

#generates random password
#This code was adopted from code written by Kirk Brown
#found at: www.perl.about.com/od/perltutorials/a/genpassword.htm
sub generatePassword{

    my $length = shift;
    my $password;
    my $possible;
    $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
    while(length($password) < $length){
        $password .= substr($possible, (int(rand(length($possible)))), 1);
    }
    return $password;
}

#Ensures that the user entered the correct password.
#Checks the file "users.txt"  for username and matches
#the users password.
sub isUsersPassword{

    my($username, $userPass) = @_;
    my $filename = "users.txt";
    my $scrambledPass = md5_hex($userPass);
    open(USERS, "$filename")|| die "couldn't open file";
	#opens file for reading
	#searches for matching user info
    while(<USERS>){
        chomp;    
        my($userCheck, $dummy2, $passCheck) = split(/:/, $_);
        if($userCheck eq $username && $passCheck eq $scrambledPass){
            close(USERS);
            return 1;
        }
    }
    close(USERS);
    return 0;
}

#returns 1 if the password is valid
sub isValidPassword{
    my $password = shift;
	#regex for passwords. passwords must be between 6-15 characters.
	#and have one upper, one lower char, a number, and a special char
    if($password =~ m/((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@\#$%*&]).{6,15})/){
        return 1;   
    }
    return "Password must be between 6-15 characters.\nAnd must have one or more of the following:\nUppercase letter\nlowercase letter\nnumber\nthe folloing charcters: @ # $ % * &\n";
}

#returns 1 if the name is valid
sub isValidName{
    my $name = shift;
    if($name =~ /^\w{6,12}$/){#regex for valid name. name must be between 6-12 characters
        return 1;
    }
    return "name must be between 6-12 characters\n";
}

1;
