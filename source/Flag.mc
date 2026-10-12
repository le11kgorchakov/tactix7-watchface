import Toybox.Graphics;
import Toybox.Lang;

module Flag {

    const RED = 0xFF0000;
    const WHITE = 0xFFFFFF;
    const BLUE = 0x0000AA;
    const STRIPES = 13;
    const CANTON_STRIPES = 7;
    const CANTON_WIDTH_RATIO = 0.45;
    const STAR_ROWS = 9;
    const STAR_RADIUS = 2;

    function draw(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        for (var i = 0; i < STRIPES; i++) {
            dc.setColor(i % 2 == 0 ? RED : WHITE, RED);
            var top = height * i / STRIPES;
            dc.fillRectangle(0, top, width, height * (i + 1) / STRIPES - top);
        }

        var cantonWidth = (width * CANTON_WIDTH_RATIO).toNumber();
        var cantonHeight = height * CANTON_STRIPES / STRIPES;
        dc.setColor(BLUE, BLUE);
        dc.fillRectangle(0, 0, cantonWidth, cantonHeight);
        drawStars(dc, cantonWidth, cantonHeight);
    }

    // 9 rows alternating 6 and 5 stars, as on the 50-star flag.
    function drawStars(dc as Graphics.Dc, cantonWidth as Number, cantonHeight as Number) as Void {
        dc.setColor(WHITE, BLUE);
        var columnStep = cantonWidth / 12.0;
        var rowStep = cantonHeight / (STAR_ROWS + 1.0);
        for (var row = 0; row < STAR_ROWS; row++) {
            var y = (rowStep * (row + 1)).toNumber();
            var offset = row % 2 == 0 ? 1 : 2;
            var count = row % 2 == 0 ? 6 : 5;
            for (var col = 0; col < count; col++) {
                dc.fillCircle((columnStep * (offset + col * 2)).toNumber(), y, STAR_RADIUS);
            }
        }
    }
}
