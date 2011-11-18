$(document).ready(function() {
    updateClock();
    
    setInterval("updateClock()", 1000);
});

function updateClock() {
    var now = new Date();
    
    $('#clock-month').text(padZero(now.getMonth() + 1, 2));
    $('#clock-day').text(padZero(now.getDate(), 2));
    $('#clock-year').text(now.getFullYear());
    $('#clock-hour').text(padZero(twentyFourHoursToTwelveHours(now.getHours()), 2));
    $('#clock-minute').text(padZero(now.getMinutes(), 2));
    $('#clock-second').text(padZero(now.getSeconds(), 2));
    $('#clock-ampm').text(AMorPM(now.getHours()));
}

function twentyFourHoursToTwelveHours(hours) {
    if(hours == 0) {
        return 12;
    }
    else {
        return (hours > 12) ? hours - 12 : hours;
    }
}

function AMorPM(hours) {
    return (hours < 12) ? "AM" : "PM";
}

function padZero(value, width) {
    width -= value.toString().length;
    if ( width > 0 )
    {
        return new Array( width + (/\./.test( value ) ? 2 : 1) ).join( '0' ) + value;
    }
    return value;
}