using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as Act;
using Toybox.Weather as Weather;
using Toybox.System as Sys;
using Toybox.Position;

class SunriseSunset extends Ui.Drawable {
    var sunriseColor;
    var sunsetColor;
    var pointRadius;
    var distance;

    // somewere in Ostrava
    var gLocationLat = 49.8346453;
    var gLocationLng = 18.2820442;

    function initialize(params) {
        Drawable.initialize(params);

        sunriseColor = params.get(:sunriseColor);
        sunsetColor = params.get(:sunsetColor);
        pointRadius = params.get(:radius);
        distance = params.get(:distance);

        var location = activityInfo.currentLocation;

		if (location) {
			location = location.toDegrees(); // Array of Doubles.
			gLocationLat = location[0].toFloat();
			gLocationLng = location[1].toFloat();

			Application.getApp().setProperty("LastLocationLat", gLocationLat);
			Application.getApp().setProperty("LastLocationLng", gLocationLng);
		// If current location is not available, read stored value from Object Store, being careful not to overwrite a valid
		// in-memory value with an invalid stored one.
		} else {
			var lat = Application.getApp().getProperty("LastLocationLat");
			if (lat != null) {
				gLocationLat = lat;
			}

			var lng = Application.getApp().getProperty("LastLocationLng");
			if (lng != null) {
				gLocationLng = lng;
			}
		}
    }

    function draw(dc as Dc) {
        if (gLocationLat != null && gLocationLng != null) {
            var sun = getSunTimes(gLocationLat, gLocationLng, null, false);

            fillPoint(dc, sun[0].toFloat() / 12.0, sunsetColor, pointRadius, distance);
            fillPoint(dc, sun[1].toFloat() / 12.0, sunriseColor, pointRadius, distance);
        }
    }
}
