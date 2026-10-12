import Toybox.Graphics;
import Toybox.Lang;

// Two footprints, the right one a step ahead, centered vertically on y.
module StepsIcon {

    const WIDTH = 18;

    function draw(dc as Graphics.Dc, x as Number, y as Number, grow as Number) as Void {
        drawFoot(dc, x + 4, y + 2, grow);
        drawFoot(dc, x + 14, y - 4, grow);
    }

    function drawFoot(dc as Graphics.Dc, x as Number, y as Number, grow as Number) as Void {
        dc.fillEllipse(x, y - 3, 4 + grow, 6 + grow);
        dc.fillEllipse(x, y + 8, 3 + grow, 3 + grow);
    }
}
