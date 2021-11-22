using Toybox.Graphics as Gfx;
using Toybox.Math as Math;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Date;
using Toybox.Position;

using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Activity as Activity;


// global variables
var centerX;
var centerY;
var radius;

var info;
var activityInfo;

// position is number 0 - 1;
function preparePoint(dc as Dc, position as Number, color as Number, pointRadius as Number, distance as Number) {
    dc.setPenWidth(pointRadius / 2);
    dc.setColor(color, Gfx.COLOR_TRANSPARENT);

    return pointOnCircle(position, distance);
}


// position is number 0 - 1;
function fillPoint(dc as Dc, position as Number, color as Number, pointRadius as Number, distance as Number) {
    var xy = preparePoint(dc, position, color, pointRadius, distance);
    dc.fillCircle(xy[0], xy[1], pointRadius);
}

// position is number 0 - 1;
function drawPoint(dc as Dc, position as Number, color as Number, pointRadius as Number, distance as Number) {
    var xy = preparePoint(dc, position, color, pointRadius, distance);
    dc.drawCircle(xy[0], xy[1], pointRadius);
}

function drawHand(dc, clockAngle, weight, color, start, end) {
    var angle = ((clockAngle * 6) - 90) * Math.PI / 180;
    var coordinates = [
        Math.round(radius + start * Math.cos(angle)),
        Math.round(radius + start * Math.sin(angle)),
        Math.round(radius + end * Math.cos(angle)),
        Math.round(radius + end * Math.sin(angle)),
    ];

    dc.setColor(color, Gfx.COLOR_BLACK);	
    dc.setPenWidth(weight);
    dc.drawLine(coordinates[0], coordinates[1], coordinates[2], coordinates[3]);
}

function toRad(alpha) {
    return alpha * Math.PI / 180;
}

function pointOnCircle(position, distance) {
    return pointOnShiftedCircle(position, distance, centerX, centerY);
}

function pointOnShiftedCircle(position, distance, shiftedX, shiftedY) {
    var angleDeg = (position.toFloat() * 360.0) - 90;
    var angle = angleDeg / 180.0 * Math.PI;
    var x = Math.round(shiftedX + (radius - distance) * Math.cos(angle));
    var y = Math.round(shiftedY + (radius - distance) * Math.sin(angle));

    return [x, y];
}

function getDateString() {
    var now = Time.now();
    var info = Calendar.info(now, Time.FORMAT_MEDIUM);        
    return Lang.format("$1$ $2$", [info.day_of_week.substring(0, 2).toUpper(), info.day]);
}

var logLenght = 5;
var logFormat = "$1$ $2$ $3$ $4$";
function log(arr as Array) {
    Sys.println(Lang.format(logFormat, arr));
}


/**
* With thanks to ruiokada. Adapted, then translated to Monkey C, from:
* https://gist.github.com/ruiokada/b28076d4911820ddcbbc
*
* Calculates sunrise and sunset in local time given latitude, longitude, and tz.
*
* Equations taken from:
* https://en.wikipedia.org/wiki/Julian_day#Converting_Julian_or_Gregorian_calendar_date_to_Julian_Day_Number
* https://en.wikipedia.org/wiki/Sunrise_equation#Complete_calculation_on_Earth
*
* @method getSunTimes
* @param {Float} lat Latitude of location (South is negative)
* @param {Float} lng Longitude of location (West is negative)
* @param {Integer || null} tz Timezone hour offset. e.g. Pacific/Los Angeles is -8 (Specify null for system timezone)
* @param {Boolean} tomorrow Calculate tomorrow's sunrise and sunset, instead of today's.
* @return {Array} Returns array of length 2 with sunrise and sunset as floats.
*                 Returns array with [null, -1] if the sun never rises, and [-1, null] if the sun never sets.
*/
function getSunTimes(lat, lng, tz, tomorrow) {

    // Use double precision where possible, as floating point errors can affect result by minutes.
    lat = lat.toDouble();
    lng = lng.toDouble();

    var now = Time.now();
    if (tomorrow) {
        now = now.add(new Time.Duration(24 * 60 * 60));
    }
    var d = Date.info(Time.now(), Time.FORMAT_SHORT);
    var rad = Math.PI / 180.0d;
    var deg = 180.0d / Math.PI;
    
    // Calculate Julian date from Gregorian.
    var a = Math.floor((14 - d.month) / 12);
    var y = d.year + 4800 - a;
    var m = d.month + (12 * a) - 3;
    var jDate = d.day
        + Math.floor(((153 * m) + 2) / 5)
        + (365 * y)
        + Math.floor(y / 4)
        - Math.floor(y / 100)
        + Math.floor(y / 400)
        - 32045;

    // Number of days since Jan 1st, 2000 12:00.
    var n = jDate - 2451545.0d + 0.0008d;
    //Sys.println("n " + n);

    // Mean solar noon.
    var jStar = n - (lng / 360.0d);
    //Sys.println("jStar " + jStar);

    // Solar mean anomaly.
    var M = 357.5291d + (0.98560028d * jStar);
    var MFloor = Math.floor(M);
    var MFrac = M - MFloor;
    M = MFloor.toLong() % 360;
    M += MFrac;
    //Sys.println("M " + M);

    // Equation of the centre.
    var C = 1.9148d * Math.sin(M * rad)
        + 0.02d * Math.sin(2 * M * rad)
        + 0.0003d * Math.sin(3 * M * rad);
    //Sys.println("C " + C);

    // Ecliptic longitude.
    var lambda = (M + C + 180 + 102.9372d);
    var lambdaFloor = Math.floor(lambda);
    var lambdaFrac = lambda - lambdaFloor;
    lambda = lambdaFloor.toLong() % 360;
    lambda += lambdaFrac;
    //Sys.println("lambda " + lambda);

    // Solar transit.
    var jTransit = 2451545.5d + jStar
        + 0.0053d * Math.sin(M * rad)
        - 0.0069d * Math.sin(2 * lambda * rad);
    //Sys.println("jTransit " + jTransit);

    // Declination of the sun.
    var delta = Math.asin(Math.sin(lambda * rad) * Math.sin(23.44d * rad));
    //Sys.println("delta " + delta);

    // Hour angle.
    var cosOmega = (Math.sin(-0.83d * rad) - Math.sin(lat * rad) * Math.sin(delta))
        / (Math.cos(lat * rad) * Math.cos(delta));
    //Sys.println("cosOmega " + cosOmega);

    // Sun never rises.
    if (cosOmega > 1) {
        return [null, -1];
    }
    
    // Sun never sets.
    if (cosOmega < -1) {
        return [-1, null];
    }
    
    // Calculate times from omega.
    var omega = Math.acos(cosOmega) * deg;
    var jSet = jTransit + (omega / 360.0);
    var jRise = jTransit - (omega / 360.0);
    var deltaJSet = jSet - jDate;
    var deltaJRise = jRise - jDate;

    var tzOffset = (tz == null) ? (Sys.getClockTime().timeZoneOffset / 3600) : tz;
    return [
        /* localRise */ (deltaJRise * 24) + tzOffset,
        /* localSet */ (deltaJSet * 24) + tzOffset
    ];
}

function onPosition(info) {
    var myLocation = info.position.toRadians();
    Sys.println(myLocation[0]); // latitude (e.g. 0.678197)
    Sys.println(myLocation[1]); // longitude (e.g -1.654588)
}

function getHeartRate() {
    var heartRate = "--";
    if (ActivityMonitor has :getHeartRateHistory) {
        heartRate = Activity.getActivityInfo().currentHeartRate;

        if (heartRate==null) {
            var HRH = ActivityMonitor.getHeartRateHistory(1, true);
            var HRS = HRH.next();

            if (HRS!=null && HRS.heartRate!= ActivityMonitor.INVALID_HR_SAMPLE){
                heartRate = HRS.heartRate;
            }
        }

        if (heartRate!=null) {
            heartRate = heartRate.toString();
        }
    }

    return heartRate;
}
