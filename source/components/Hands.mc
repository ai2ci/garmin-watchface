using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class Hands extends Ui.Drawable {
    private var handType;
    private var handColor;
    private var handWidth;
    private var secondHandColor;
    private var hasSecondHand;
    private var secondHandWidth = 4;
    private var centerRadius;
    private var positions;

    function initialize(params) {
        Drawable.initialize(params);

        // positions = Application.loadResource(Rez.JsonData.positions);

        handType = params.get(:handType);
        handColor = params.get(:handColor);
        handWidth = params.get(:handWidth);
        secondHandColor = params.get(:secondHandColor); 
        hasSecondHand = params.get(:hasSecondHand); 
        centerRadius = params.get(:centerRadius); 
    }

    function draw(dc as Dc) {   
		var clockTime = Sys.getClockTime();

        // return;

        // minutes
        drawThickHand(dc, clockTime.min, radius * 0.9);
        // hours
        var hour = (clockTime.hour % 12) * 5 + Math.floor(clockTime.min / 12);
        drawThickHand(dc, hour, radius * 0.7);

        if (handType == 0 || handType == 1) {
            if (hasSecondHand) {
                // seconds
                drawHand(dc, clockTime.sec, secondHandWidth + 1, Gfx.COLOR_BLACK, centerRadius, radius - 3);
                drawHand(dc, clockTime.sec, secondHandWidth, secondHandColor, centerRadius, radius - 4);
                // oposite second tail
                drawHand(dc, clockTime.sec, secondHandWidth + 1, Gfx.COLOR_BLACK, -centerRadius, -centerRadius - 11);
                drawHand(dc, clockTime.sec, secondHandWidth, secondHandColor, -centerRadius, -centerRadius - 10);

                drawCenterCircle(dc, secondHandColor, centerRadius);
            } else {
                drawCenterCircle(dc, handColor, centerRadius);
            }
        } else if (handType == 2) {
            // seconds
            drawHand(dc, clockTime.sec, secondHandWidth + 1, Gfx.COLOR_BLACK, centerRadius, radius - 3);
            drawHand(dc, clockTime.sec, secondHandWidth, secondHandColor, centerRadius, radius - 4);
            // oposite second tail
            drawHand(dc, clockTime.sec, secondHandWidth * 2 + 1, Gfx.COLOR_BLACK, -centerRadius, -centerRadius - 25);
            drawHand(dc, clockTime.sec, secondHandWidth * 2, secondHandColor, -centerRadius, -centerRadius - 24);

            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.fillCircle(centerX, centerY, handWidth + 6); 

            dc.setPenWidth(secondHandWidth + 2);
            dc.setColor(secondHandColor, Gfx.COLOR_TRANSPARENT);
            dc.drawCircle(centerX, centerY, handWidth - 2); 
        }
    }

    function drawThickHand(dc, position, lenght) {
        if (handType == 0) {
            drawHand(dc, position, handWidth + 1, Gfx.COLOR_BLACK, 0, lenght);
            drawHand(dc, position, handWidth, handColor, 0, lenght);
            drawHand(dc, position, 5, Gfx.COLOR_BLACK, 45, lenght);
        } else if (handType == 1) {
            var topDistance = radius - lenght + handWidth / 1.5;
            var middleDistance = radius - lenght + handWidth * 8;
            position = position.toFloat() / 60.0;
            var centerRadius = handWidth / 2;
            dc.setColor(handColor, Gfx.COLOR_TRANSPARENT);

            var top = pointOnCircle(position, radius - lenght); // vrchol
            var left = pointOnCircle(position - 0.25, radius - centerRadius);
            var right = pointOnCircle(position + 0.25, radius - centerRadius);
            var leftTop = pointOnShiftedCircle(position, topDistance, left[0], left[1]);
            var rightTop = pointOnShiftedCircle(position, topDistance, right[0], right[1]);
            var middleLeftTop = pointOnShiftedCircle(position, middleDistance, left[0], left[1]);
            var middleRightTop = pointOnShiftedCircle(position, middleDistance, right[0], right[1]);

            dc.setPenWidth(4);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(left[0], left[1], middleLeftTop[0], middleLeftTop[1]);
            dc.drawLine(right[0], right[1], middleRightTop[0], middleRightTop[1]);
            dc.drawLine(middleLeftTop[0], middleLeftTop[1], middleRightTop[0], middleRightTop[1]);
            dc.setPenWidth(2);
            dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
            dc.drawLine(left[0], left[1], middleLeftTop[0], middleLeftTop[1]);
            dc.drawLine(right[0], right[1], middleRightTop[0], middleRightTop[1]);
            dc.drawLine(middleLeftTop[0], middleLeftTop[1], middleRightTop[0], middleRightTop[1]);

            // drawHand(dc, position * 60.0, handWidth, Gfx.COLOR_DK_GRAY, centerRadius, radius - middleDistance);
            dc.setColor(handColor, Gfx.COLOR_TRANSPARENT);
            dc.fillPolygon([middleLeftTop, leftTop, top, rightTop, middleRightTop]);
        } else if (handType == 2) {
            var sideDistance = radius - handWidth / 1.8;
            var topDistance = radius - lenght + handWidth / 1.5;
            var middleDistance = radius - lenght + handWidth * 1.5;
            position = position.toFloat() / 60.0;
            var centerRadius = handWidth / 2;

            var top = pointOnCircle(position, radius - lenght); // vrchol
            var topIn = pointOnCircle(position, middleDistance - handWidth / 2.5); // vrchol
            var leftOut = pointOnCircle(position - 0.25, sideDistance - handWidth / 2);
            var rightOut = pointOnCircle(position + 0.25, sideDistance - handWidth / 2);
            var leftIn = pointOnCircle(position - 0.25, sideDistance + handWidth);
            var rightIn = pointOnCircle(position + 0.25, sideDistance + handWidth);
            var leftTopIn = pointOnShiftedCircle(position, middleDistance, leftIn[0], leftIn[1]);
            var rightTopIn = pointOnShiftedCircle(position, middleDistance, rightIn[0], rightIn[1]);
            var leftTopOut = pointOnShiftedCircle(position, middleDistance, leftOut[0], leftOut[1]);
            var rightTopOut = pointOnShiftedCircle(position, middleDistance, rightOut[0], rightOut[1]);

            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.setPenWidth(1);
            dc.drawLine(rightIn[0], rightIn[1], rightTopIn[0], rightTopIn[1]);
            dc.drawLine(leftIn[0], leftIn[1], leftTopIn[0], leftTopIn[1]);
            dc.drawLine(topIn[0], topIn[1], rightTopIn[0], rightTopIn[1]);
            dc.drawLine(topIn[0], topIn[1], leftTopIn[0], leftTopIn[1]);

            dc.setPenWidth(3);
            dc.drawLine(rightOut[0], rightOut[1], rightTopOut[0], rightTopOut[1]);
            dc.drawLine(leftOut[0], leftOut[1], leftTopOut[0], leftTopOut[1]);

            dc.drawLine(top[0], top[1], rightTopOut[0], rightTopOut[1]);
            dc.drawLine(top[0], top[1], leftTopOut[0], leftTopOut[1]);

            dc.setColor(handColor, Gfx.COLOR_TRANSPARENT);
            dc.fillPolygon([
                rightIn, rightTopIn, topIn, leftTopIn, leftIn,
                leftOut, leftTopOut, top, rightTopOut, rightOut,
            ]);
        }
    }

    function drawCenterCircle(dc, color, centerRadius) {
        dc.setPenWidth(secondHandWidth + 1);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);	
        dc.drawCircle(centerX, centerY, centerRadius);

        dc.setPenWidth(secondHandWidth);
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);	
        dc.drawCircle(centerX, centerY, centerRadius);

        dc.setColor(handColor, Gfx.COLOR_TRANSPARENT);	
        dc.fillCircle(centerX, centerY, centerRadius - secondHandWidth); 
    }
}
