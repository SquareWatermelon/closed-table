#contains useful HTML
use strict;
use misc;

#Prints the header with CSS etc.
sub printHead{
        print <<END_PRINT;
Content-type: text/html\n\n
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.o$
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-31j">
<link href="css/CT.css" rel="stylesheet" type="text/css" />
<link href="css/Table.css" rel="stylesheet" type="text/css" />
<link href="css/Buttons.css" rel="stylesheet" type="text/css" />
<title>Closed Table</title>
<script type="text/javascript">
function updateCancel(name, number, time, date, phone){
    var oName = document.getElementById('rmName');
    var oNumber = document.getElementById('rmNumber');
    var oTime = document.getElementById('rmTime');
    var oDate = document.getElementById('rmDate');
    var oPhone = document.getElementById('rmPhone');
    oName.value = name;
    oNumber.value = number;
    oTime.value = time;
    oDate.value = date;
    oPhone.value = phone;
}
function updateReserve(time, date){
    var mTime = document.getElementById('mkTime');
    var mDate = document.getElementById('mkDate');
    mTime.value = time;
    mDate.value = date;
}
function setPrintState(field, state){
    document.getElementById('navForm').printState.value = state;
    document.getElementById('navForm').submit();
}
function clearText(field){
    if (field.defaultValue == field.value) field.value = '';
    else if (field.value == '') field.value = field.defaultValue;
}
function mkAlert(text){
    alert(text);
}
</script>
</head>
END_PRINT
}
#field.form

1;
