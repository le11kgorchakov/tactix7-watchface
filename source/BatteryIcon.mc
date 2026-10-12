import Toybox.Graphics;
import Toybox.Lang;

// Battery outline filled to the charge level, centered vertically on y.
module BatteryIcon {

    const BODY_WIDTH = 22;
    const HEIGHT = 13;
    const PEN = 2;
    const INSET = 3;
    const NUB_WIDTH = 3;
    const NUB_HEIGHT = 6;
    const WIDTH = BODY_WIDTH + NUB_WIDTH;

    function draw(dc as Graphics.Dc, x as Number, y as Number, percent as Number, color as Number, outlined as Boolean, outlineWidth as Number) as Void {
        var top = y - HEIGHT / 2;

        if (outlined) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillRectangle(x - outlineWidth, top - outlineWidth, WIDTH + 2 * outlineWidth, HEIGHT + 2 * outlineWidth);
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(PEN);
        dc.drawRectangle(x, top, BODY_WIDTH, HEIGHT);
        dc.setPenWidth(1);
        dc.fillRectangle(x + BODY_WIDTH, y - NUB_HEIGHT / 2, NUB_WIDTH, NUB_HEIGHT);

        var fillWidth = (BODY_WIDTH - 2 * INSET) * percent / 100;
        if (fillWidth > 0) {
            dc.fillRectangle(x + INSET, top + INSET, fillWidth, HEIGHT - 2 * INSET);
        }
    }
}
