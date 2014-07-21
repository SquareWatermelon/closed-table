#!usr/bin/perl
#Author Raul
use strict;
use misc;
use Digest::MD5 qw(md5 md5_hex md5_base64);
#$1 = |;

my $userExists = 0; #user already exists
my $isValidPass = 0; #invalid pass
my $isValidEmail = 0; #invalid email
my $isValidName = 0;
my $alreadyReserved = 0; #time slot already reserved
my $isUsersEmail = 0;
my $isUsersPassword = 0;

#return 1 if the user already exists
sub userExists{
    my $user = shift;
    my ($userCheck, $dummy, $dummy2);
    my $filename = "users.txt";
    open(USERS, "<$filename") || alert( "Couldnt open $filename");
    while(<USERS>){
        chomp;
        ($userCheck, $dummy, $dummy2) = split(/:/, $_);
        if($userCheck eq $user){
            $userExists = 1;
            close(USERS);
            return $userExists;    
        }
    }    
    close(USERS);
    $userExists = 0;
    return $userExists;
}



#mkUser("raul", "raulmatias7\@gmail.com", "password");
#mkUser("carlos", "carlos.matias", "fgr4rr");
#mkUser("tania", "tania.matias", "dsfwrrf");
#rmUser("carlos");
#if (isUsersEmail("raul", "raulmatias7\@gmail.com") == 0){
#print"not email\n";}
#else{
#print"is email\n";}
#if (userExists("raul") == 0){
#print"no exists\n";}
#else{
#print"exists\n";}
#if(isUsersPassword("raul", "password") == 0){
#print"not pword\n";}
#else{
#print"is pword\n";}
#if(isValidPassword("Raul0724**") == 0){
#print"invalid pass\n";}
#else{
#print"valid pass\n";}
#if(isValidName("raul0724*") == 0){
#print"invalid name\n";}
#else{
#print"valid name\n";}
#tempPassword("raul");
#sub mkPDF{
#   return pdf; # a pdf of current reservations
#}

#sub mkTable{
#   $numberOfSeats
#}

#Stores username and password in a file name "users.txt"
#if file does not exist it will be created.
#The password is scrambled using MD5 before being stored.
sub mkUser{

    my ($username, $email, $userPass) = @_;   
    my $filename = "users.txt";
    my ($scrambledPass, $userCheck, $dummy, $dummy2, @entries);
    open(USERS, "+<$filename");
    while(<USERS>){
        chomp;     
        my ($userCheck, $dummy, $dummy2) = split(/:/, $_);
        if($userCheck eq $username){return $userExists}; ################
    }
    $scrambledPass = md5_hex($userPass);
    print USERS "$username\:$email\:$scrambledPass\n";
    close(USERS);
    $userExists = 1;###############################
    return $userExists;
}


#removes user
sub rmUser{
    my $username = shift;
    my $filename = "users.txt";
    my $tempFile = "tempfile.txt";
    open (USERS, "<$filename");
    open (TEMPFILE, ">>$tempFile");
    while(<USERS>){
        my ($temp, $dummy, $dummy2)  = split(/:/, $_);
        if($temp eq $username){next;}
        print TEMPFILE $_;
    }
    close (USERS);
    close (TEMPFILE);
    unlink $filename;
    rename $tempFile, $filename;
}

#sub mkReserve{
#   return $alreadyReserved; #error, 0 if already reserved 1 if not


#returns 1 if the email belongs to the user
sub isUsersEmail{
    my($user, $email) = @_;
    my $filename = "users.txt";   
    open(USERS, "<$filename");
    while(<USERS>){
        chomp;
        my ($userCheck, $emailCheck, $dummy) = split(/:/, $_);
        if($userCheck eq $user && $emailCheck eq $email){
            $isUsersEmail = 1;
            close(USERS);
            return $isUsersEmail;
        }
    }
    close(USERS);
    $isUsersEmail = 0;
    return $isUsersEmail;
}


#Creates a temporary password fo the user.
#Updates "users.txt"
#emails user the temp password.
#sub mkEmail{
#    my $username = shift;    
#    my $filename = "users.txt";
#    my $tempFile = "temp_users.txt";
#    my $message = "Here is your temporary password, please change your password
#        as soon as possible\n\n";
#    my $passSize = 12;
#    my $output;
#    my $tempPass = generatePassword($passSize);
#    my $scrambledPass = md5_hex($tempPass);
#    my($name, $email, $pass);
#    open(USERS, "<$filename");
#    open(TEMPFILE, ">>$tempFile");
#    while(<USERS>){
#        ($name, $email, $pass) = split(/:/, $_);
#        if($name eq $username){
#            $output = join(":", $username, $email, $scrambledPass);            
#            next;
#        }
#        print TEMPFILE $_;   
#    }
#    print TEMPFILE "$output\n";
#    close (TEMPFILE);
#    close (USERS);
#    unlink $filename;
#    rename $tempFile, $filename;
#    
#    open (MAILH, "|mail -s \"Recovery password\" $email") || alert("cant open mail");
#    print MAILH "$message $tempPass";
#    close (MAILH);    
#}

sub tempPassword{
    my $username = shift;
    my $filename = "users.txt";
    my $tempFile = "temp_users.txt";
    my $message = "Here is your temporary password, please change your password
        as soon as possible\n\n";
    my $passSize = 12;
    my $output;
    my $tempPass = generatePassword($passSize);
    my $scrambledPass = md5_hex($tempPass);
    my($name, $email, $pass);
    open(USERS, "<$filename");
    open(TEMPFILE, ">>$tempFile");
    while(<USERS>){
        ($name, $email, $pass) = split(/:/, $_);
        if($name eq $username){
            $output = join(":", $username, $email, $scrambledPass);
            next;
        }
        print TEMPFILE $_;
    }
    print TEMPFILE "$output\n";
    close (TEMPFILE);
    close (USERS);
    unlink $filename;
    rename $tempFile, $filename;

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
    open (TEMPFILE, ">>$tempFile");
    open (USERS, "<$filename");
    while(<USERS>){
        my ($name, $email, $password) = split(/:/, $_);
        if($name eq $username){
            $temp = join(":", $name, $email, $scrambledPass);
            next;
        }
        print TEMPFILE $_;
    }
    print TEMPFILE $temp;
#    alert("$newPassword");
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

#sub getStatistics{
#   return @list # list of statistics
#}

#Ensures that the user entered the correct password.
#Checks the file "users.txt"  for username and matches
#the users password.
sub isUsersPassword{
    my($username, $userPass) = @_;
    my $filename = "users.txt";
    my $scrambledPass = md5_hex($userPass);
    open(USERS, "$filename");
    while(<USERS>){
        chomp;    
        my($userCheck, $dummy2, $passCheck) = split(/:/, $_);
        if($userCheck eq $username && $passCheck eq $scrambledPass){
            $isUsersPassword = 1;
            close(USERS);
            return $isUsersPassword;
        }
    }
    close(USERS);
    $isUsersPassword = 0;
    return $isUsersPassword;
}

#returns 1 if the password is valid
sub isValidPassword{
    my $password = shift;
    if($password =~ m/((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@\#$%*&]).{6,15})/){
        $isValidPass = 1;
        return $isValidPass;   
    }
    $isValidPass = 0;
    return $isValidPass;
}

#returns 1 if the name is valid
sub isValidName{
    my $name = shift;
    if($name =~ /^\w{6,12}$/){
        $isValidName = 1;
        return $isValidName;
    }
    $isValidName = 0;
    return $isValidName;
}


1;
