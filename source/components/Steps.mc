using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as Act;

class Steps extends Ui.Drawable {
    var color;
    var pointRadius;
    var distance;

    function initialize(params) {
        Drawable.initialize(params);

        color = params.get(:color);
        pointRadius = params.get(:radius);
        distance = params.get(:distance);
    }

    function draw(dc as Dc) {   
        if (info.steps >= info.stepGoal) {
            fillPoint(dc, info.steps.toFloat() / info.stepGoal.toFloat(), color, pointRadius, distance);
        } else {
            drawPoint(dc, info.steps.toFloat() / info.stepGoal.toFloat(), color, pointRadius, distance);
        }
    }

}
