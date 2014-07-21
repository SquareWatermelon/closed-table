#!/usr/bin/perl
#Simple script that sends the users password to its email address.
#*******************************************************************************
use strict;
use HTML;

#Send an email
#sub email{
#    if( $user == undef ) {
#        print "Please provide the username";
#        return "login";
#    }
#    my($password, $email) = getPassword( $user );
#    tryEmail($email, $password);
#    return "login";
#}

#Try to send an email to the address sent by STDIN.
#sub tryEmail{
#    my $email = $in{"email"};
#    my $message = $in{"message"};
##    $message =~ s/\+/ /g;
#    chomp $email;
#    if($email =~ m/^\w+\@\w+\.\w{2,4}$/){ sendEmail($email, $message) }
#    else { print "Invalid email format.<br />"; }
#}

#send the email out.
sub mkEmail{
    my $email   = shift;
    my $message = shift;
    open (my $MAILH, "|mail -s \"New_Password\" " . $email );
#            ||  print "Error: Cannot open mail handle.<br />";
    if(defined $MAILH ){
        print $MAILH $message;
        close($MAILH);
#        print "Email sent successfully.<br />";
    }
}

1;