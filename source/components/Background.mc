using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

class Background extends Ui.Drawable {
	hidden var topColor, bottomColor;
    hidden var width;
    hidden var height;
    hidden var centerX;
    hidden var centerY;
    hidden var radius;


    function initialize(params) {
        Drawable.initialize(params);

        topColor = params.get(:topColor);
        bottomColor = params.get(:bottomColor);      
    }

    function draw(dc) {
        // Clear the screen
        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
        // dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.clear();
        return;

        width = dc.getWidth();
        height = dc.getHeight();      
        centerX = width / 2;
        centerY = height / 2;
        // drawBGLines(dc);
        drawBGPoints(dc);


        // dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);	
        // dc.fillCircle(centerX, centerY, radius - 30);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);	
        dc.fillCircle(centerX, centerY, 30);

        drawHand(dc, 10, 15, Gfx.COLOR_BLACK, 0, radius);
        drawHand(dc, 30, 15, Gfx.COLOR_BLACK, 0, radius);
        drawHand(dc, 50, 15, Gfx.COLOR_BLACK, 0, radius);

        dc.setPenWidth(20);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(centerX, centerY, radius - 10);

        for (var i = 0; i < 60 ; i = i + 5) {
            drawHand(dc, i, 4, Gfx.COLOR_DK_GREEN, radius - 4, radius);
        }
    }

    function drawBGPoints(dc) {
        dc.setPenWidth(2);
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);

        var step = 2;
        var rim = 25;
        // var r = radius - rim;

        // for (var i = rim; i < width - rim; i = i + step) {
        //     for (var j =  rim + (i % (step * 2)); j < height - rim; j = j + step * 2) {
        //         var diff = Math.sqrt(Math.pow(i - centerX, 2) + Math.pow(j - centerY, 2));
        //         if (diff < r && diff > rim) {
        //             dc.drawPoint(i, j);
        //         }

        //     }
        // }
        for (var r = 45; r < radius - 10; r = r + step * 4) {
            for (var x = 0; x < 360; x = x + step * 2) {
                if (!(x > 267 && x < 273) && !(x > 27 && x < 33) && !(x > 147 && x < 153)) {
                    dc.drawArc(centerX, centerY, r, Gfx.ARC_CLOCKWISE, x, x - 1);
                    dc.drawArc(centerX, centerY, r + step * 2, Gfx.ARC_CLOCKWISE, x + step, x + step - 1);
                }
            }
        }
    }

    function drawBGLines(dc) {
        var distance = 9;
        var penWidth = 1;
        var fullLine = radius - 50 - ((radius - 50) % 8);

        // triangle
        var sideB = distance;
        var sideA = sideB/Math.sqrt(3);
        var sideC = sideB * 2/Math.sqrt(3);


        // var rightAngle =  30 * Math.PI / 180;
        // var leftAngle =  -180 * Math.PI / 180;

        dc.setPenWidth(penWidth);
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);



        var topAngle = 90 * Math.PI / 180;
        var rightAngle = 210 * Math.PI / 180;
        var leftAngle = 330 * Math.PI / 180;
        var coordinates = [
            [Math.cos(topAngle), Math.sin(topAngle)],
            [Math.cos(rightAngle), Math.sin(rightAngle)],
            [Math.cos(leftAngle), Math.sin(leftAngle)],
        ];

        var line = coordinates[0];
        var c = [radius, radius, radius + line[0] * radius,  radius - line[1] * radius];
        dc.drawLine(c[0], c[1], c[2], c[3]);
        System.println("START==========================================================");
        System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0], c[1], c[2], c[3]]));

        for(var j = 0; j < 10; j += 1) {
            var pushX = sideB * j;
            var pushY = sideA * j;
            dc.drawLine(c[0] + pushX, c[1] - pushY, c[2] + pushX, c[3] - pushY);
            dc.drawLine(c[0] - pushX, c[1] - pushY, c[2] - pushX, c[3] - pushY);
            System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0] + pushX, c[1] - pushY, c[2] + pushX, c[3] - pushY]));
            System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0] - pushX, c[1] - pushY, c[2] - pushX, c[3] - pushY]));
        }

        line = coordinates[1];
        c = [radius, radius, radius + line[0] * radius,  radius - line[1] * radius];
        dc.drawLine(c[0], c[1], c[2], c[3]);
        System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0], c[1], c[2], c[3]]));

        for(var j = 0; j < 9; j += 1) {
            var pushX = sideB * j;
            var pushY = sideA * j;
            var pushY2 = sideC * j;
            dc.drawLine(c[0] - pushX, c[1] - pushY, c[2] - pushX, c[3] - pushY);
            dc.drawLine(c[0], c[1] + pushY2, c[2], c[3] + pushY2);
            System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0] - pushX, c[1] - pushY, c[2] - pushX, c[3] - pushY]));
            System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0], c[1] + pushY2, c[2], c[3] + pushY2]));
        }

        line = coordinates[2];
        c = [radius, radius, radius + line[0] * radius,  radius - line[1] * radius];
        dc.drawLine(c[0], c[1], c[2], c[3]);
        System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0], c[1], c[2], c[3]]));

        for(var j = 0; j < 9; j += 1) {
            var pushX = sideB * j;
            var pushY = sideA * j;
            var pushY2 = sideC * j;
            dc.drawLine(c[0] + pushX, c[1] - pushY, c[2] + pushX, c[3] - pushY);
            dc.drawLine(c[0], c[1] + pushY2, c[2], c[3] + pushY2);
            System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0] + pushX, c[1] - pushY, c[2] + pushX, c[3] - pushY]));
            System.println(Lang.format("[$1$,$2$],[$3$,$4$]", [c[0], c[1] + pushY2, c[2], c[3] + pushY2]));
        }
        System.println("END==========================================================");
    }
}