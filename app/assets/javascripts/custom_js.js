function change(radio) {
    if (radio.value.length <= 15) {
        document.getElementById("checked-tag").innerHTML = radio.value;
    }
    else {
        var length = 15;
        var truncatedVal = radio.value.substring(0,length)+ "...";
        document.getElementById("checked-tag").innerHTML = truncatedVal;
    }


}