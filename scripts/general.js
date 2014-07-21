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
    var mNumber = document.getElementById('mkNumber');
    mTime.value = time;
    mDate.value = date;
}
function setPrintState(state){
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