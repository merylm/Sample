// Allow the form's input fields to be saved to a cookie and then recovered if there is an error, or if the
//      internet connection is lost. For use by the Roast Batch Detail page.

// Using the jQuery serialize() function didn't work - I think because the resulting cookie length was > 4K ???

function getQueryStringValue(name) {
    // Get a single value from the URL's QueryString. If QueryString doesn't exist or "name" is not in QueryString, then return empty string
    var queryString = window.location.search;

    var regex = new RegExp("[?&]" + name + "=([^&]+)", "i");
    //var regex = /[?&]batchid=([^&]+)/;  // Hard coded name
    //alert("getQueryStringValue: " + name + " from " + queryString + " using regex " + regex.source);
    
    var matches = queryString.match(regex);
    if (matches == null)
        return ""
    else
        return matches[1];
}

function deleteAllCookies() {
    // This function was used for debugging only
    var cookies = document.cookie.split(";");

    for (var i = 0; i < cookies.length; i++) {
        var cookie = cookies[i];
        var eqPos = cookie.indexOf("=");
        var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
        document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
        document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
    }
}

 function createCookie(name, value, days) {
     //deleteAllCookies();
     if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    }
    else expires = "";
    document.cookie = name + "=" + value + expires + "; path=/";
    //alert(value.length + " " + value);
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function saveInputs(batch, form) {
    //alert("saving batch " + batch + ", form " + form.id + ", no of controls " + form.length);
    var str = batch + "|";
    var str2 = "batchid=" + batch + "\n";  // for debugging only
    for (var i = 0; i < form.length; i++) {
        var ctl = form[i];
        var value = ctl.value;
        if (ctl.type == "checkbox")
            value = ctl.checked;
        if (ctl.name.substring(0, 2) != "__" & ctl.type != "submit" & ctl.name.indexOf("ScriptManager") == -1) {
            str = str + value + "|";
            str2 = str2 + ctl.name + "(" + ctl.type + ") " + "=" + value + "\n";
        }
    }
    //alert(str2);
    createCookie("MyRoastBatch", str, 1);
}

function saveBatchid(batch) {
    // Replace batchid in cookie with latest value (eg. after inserting record & retrieving @@IDENTITY column)
    // The existing batchid will probably be blank
    var str = readCookie("MyRoastBatch");
    var regex = /[^|]*/;  // all characters preceding the first "|"
    str = str.replace(regex, batch);
    createCookie("MyRoastBatch", str, 1);
}

function recoverInputs(batch, form) {
    //alert("recovering batch " + batch);
    var str = readCookie("MyRoastBatch");
    var str2 = "" // for debugging only

    // If the current batch id is non-blank (ie. Edit mode), then the current batch id and saved batch id must agree.
    var start = str.indexOf("|");
    var savedBatch = str.substring(0, start);
    //alert("saved batch = " + savedBatch);
    if (batch != "")
        if (batch != savedBatch) {
            alert("Recovery failed. Unable to recover inputs because the saved inputs are for a different batch. (Saved id = " + savedBatch + ").");
            return;
        }
    
    start = start + 1;
    for (var i = 0; i < form.length; i++) {
        var ctl = form[i];
        if (ctl.name.substring(0, 2) != "__" & ctl.type != "submit" & ctl.name.indexOf("ScriptManager") == -1) {
            
            // Get the next value from string
            end = str.indexOf("|", start);
            if (end != -1) {   // This should always be true but check anyway
                var value = str.substring(start, end);
                start = end + 1;
                str2 = str2 + ctl.name + "=" + value + "\n";
            }
            if (ctl.type == "checkbox")
                ctl.checked = (value == "true")
            else
                ctl.value = value;
        }
    }
    //alert(str2);
}

/*
// Set up a timer to save the contents of the form when idle time is detected
// The saveInputs() function must also be called when the "Insert"/"Update" button is clicked

var timeElapsed;
var timeLimitInSecs = 3;

function resetTimer() {
    alert("resetting");
    clearTimeout(timeElapsed);
    timeElapsed = setTimeout(doSomething, timeLimitInSecs * 1000)
}

function doSomething() {
    alert(timeLimitInSecs + " seconds have elapsed.");
    resetTimer();
}

// Start the timer
window.onload = resetTimer;
document.onmousemove = resetTimer;
document.onkeypress = resetTimer;
//window.addEventListener('keydown', resetTimer, false);
//window.addEventListener("click", resetTimer, false);
*/