using Toybox.Graphics as Gfx;
using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as Act;
using Toybox.Application as App;
using Toybox.Position as Position;

class SimpleAnalogView extends Ui.WatchFace {
    var isAwake = true;
    var isStaticLayerRendered = false;
    var staticLayer;
    var secondLayer;

    function initialize() {
        WatchFace.initialize();

        // staticLayer = new WatchUi.Layer({});
        // addLayer(staticLayer);

        // setLayout(Rez.Layouts.Static(staticLayer.getDc()));

        // secondLayer = new WatchUi.Layer({});

        // addLayer(secondLayer);
        activityInfo = Activity.getActivityInfo();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.Second(dc));

        // View.findDrawableById("date").setText(getDateString());
        // View.findDrawableById("bottomRight").setText("");
        // View.findDrawableById("bottomLeft").setText(getHeartRate());
    }

    function onUpdate(dc as Dc) {
        centerX = dc.getWidth() / 2;
        centerY = dc.getHeight() / 2;
        radius = dc.getHeight() / 2;

        info = Act.getInfo();

        dc.setAntiAlias(true);

        if (!isStaticLayerRendered) {
            View.onUpdate(dc);
            isStaticLayerRendered = true;
        }
        View.onUpdate(dc);
    }

    function onEnterSleep() {
        isAwake = false;
        Ui.requestUpdate();
    }

    function onExitSleep() {
        isAwake = true;
    }
}
