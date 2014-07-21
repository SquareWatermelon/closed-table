#Author Robert "Square Watermelon" Tolda
#Contains short useful methods;
################################################################################

use strict;

#convert from nn to nn:nn
sub getTime{
    my $in = shift;
    my $out = "";
    $out .= int($in / 2);
    $out .= $in % 2 == 0 ? ":00" : ":30";
    return $out;
}

#convert from nn:nn to nn
sub getBlock{
    my $in = shift;
    my ($hours, $minutes) = split ( /:/, $in ); 
    return $hours * 2 + int($minutes / 30);
}

#returns the string without a '\n' at the end
sub scriptChomp{
    my $string = shift;
    my $stringLength = length($string);
    if (substr($string, $stringLength - 2, 2 ) eq '\n'){
        return substr($string, 0, $stringLength - 2);
    }
    return $string;
}

#enables the javascript in printhead to clear the default text in a field.
sub clear{ return "onfocus=\"clearText(this)\" onblur=\"clearText(this)\"" }

#Get the keys from standard in and split them into a hash from name to value.
sub splitKeys {
    my $in = shift;
    my ( @in, %input, $pair, @pair );
    @in = split( /&/, $in );
    foreach $pair (@in) {
        @pair = split( /=/, $pair );
        $input{ pop @pair } = pop @pair;
    }
    return ( \%input );
}

1;