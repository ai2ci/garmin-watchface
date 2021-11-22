using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class Dial extends Ui.Drawable {
    private var dialSize = 60;
    private var color;
    private var width;
    private var height;
    private var pointSize;

    function initialize(params) {
        Drawable.initialize(params);

        color = params.get(:color);
        width = params.get(:width);
        height = params.get(:height);
        pointSize = dialSize / params.get(:points);
    }

    function draw(dc as Dc) {
        for (var i = 0; i < dialSize ; i = i + pointSize) {
            drawHand(dc, i, width, color, radius - height, radius);

            // dc.setColor(color, Gfx.COLOR_TRANSPARENT);
            // Sys.println(i+0.5);
            // Sys.println(i-0.5);
            // dc.drawArc(centerX, centerY, radius, Gfx.ARC_COUNTER_CLOCKWISE, i, i);
        }
    }
}
