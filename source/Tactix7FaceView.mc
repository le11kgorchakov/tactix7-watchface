import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Tactix7FaceView extends WatchUi.WatchFace {

    private const ROW_OFFSET = 62;
    private const OWNER_NAME_OFFSET = 94;
    private const OWNER_NAME = "Alexey Gorchakov";
    private const TIME_WIDTH_RATIO = 0.85;
    private const TIME_MAX_SIZE = 140;
    private const TIME_MIN_SIZE = 60;
    private const OUTLINE_WIDTH = 2;
    private const ICON_GAP = 5;
    private const STATS_GAP = 16;
    private const JUSTIFY = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

    private var _timeFont as Graphics.FontType = Graphics.FONT_NUMBER_THAI_HOT;
    private var _outlined as Boolean = false;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Graphics.Dc) as Void {
        _timeFont = largestTimeFont(dc);
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        _outlined = now.min == 0 && FaceSettings.isEnabled(FaceSettings.HOURLY_FLAG_KEY);
        if (_outlined) {
            Flag.draw(dc);
        } else {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();
        }

        drawLabel(dc, cx, cy - OWNER_NAME_OFFSET, Graphics.FONT_TINY, OWNER_NAME, Graphics.COLOR_WHITE, JUSTIFY);
        drawLabel(dc, cx, cy - ROW_OFFSET, Graphics.FONT_MEDIUM, formatDate(now), Graphics.COLOR_WHITE, JUSTIFY);
        drawStats(dc, cx, cy + ROW_OFFSET);
        drawTime(dc, cx, cy, now);
    }

    private function drawStats(dc as Graphics.Dc, cx as Number, y as Number) as Void {
        var font = Graphics.FONT_SMALL;
        var left = Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER;
        var steps = formatSteps();
        var battery = formatBatteryLeft();
        var stepsWidth = dc.getTextWidthInPixels(steps, font);
        var batteryWidth = dc.getTextWidthInPixels(battery, font);
        var percent = System.getSystemStats().battery.toNumber();
        var x = cx - (StepsIcon.WIDTH + ICON_GAP + stepsWidth + STATS_GAP + BatteryIcon.WIDTH + ICON_GAP + batteryWidth) / 2;

        if (_outlined) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            StepsIcon.draw(dc, x, y, OUTLINE_WIDTH);
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        StepsIcon.draw(dc, x, y, 0);
        x += StepsIcon.WIDTH + ICON_GAP;

        drawLabel(dc, x, y, font, steps, Graphics.COLOR_WHITE, left);
        x += stepsWidth + STATS_GAP;

        BatteryIcon.draw(dc, x, y, percent, Graphics.COLOR_WHITE, _outlined, OUTLINE_WIDTH);
        x += BatteryIcon.WIDTH + ICON_GAP;
        drawLabel(dc, x, y, font, battery, Graphics.COLOR_WHITE, left);
    }

    private function drawLabel(dc as Graphics.Dc, x as Numeric, y as Numeric, font as Graphics.FontType, text as String, color as Number, justify as Number) as Void {
        if (_outlined) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            for (var dx = -OUTLINE_WIDTH; dx <= OUTLINE_WIDTH; dx += OUTLINE_WIDTH) {
                for (var dy = -OUTLINE_WIDTH; dy <= OUTLINE_WIDTH; dy += OUTLINE_WIDTH) {
                    dc.drawText(x + dx, y + dy, font, text, justify);
                }
            }
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, text, justify);
    }

    private function drawTime(dc as Graphics.Dc, cx as Number, cy as Number, now as Gregorian.Info) as Void {
        var hours = (now.hour as Number).format("%02d");
        var minutes = (now.min as Number).format("%02d");
        var hoursWidth = dc.getTextWidthInPixels(hours, _timeFont);
        var colonWidth = dc.getTextWidthInPixels(":", _timeFont);
        var minutesWidth = dc.getTextWidthInPixels(minutes, _timeFont);
        var x = cx - (hoursWidth + colonWidth + minutesWidth) / 2;
        var left = Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER;

        drawLabel(dc, x, cy, _timeFont, hours, FaceSettings.getColor(FaceSettings.HOURS_KEY), left);
        x += hoursWidth;
        if (FaceSettings.isEnabled(FaceSettings.SHOW_COLON_KEY)) {
            drawLabel(dc, x, cy, _timeFont, ":", FaceSettings.getColor(FaceSettings.COLON_KEY), left);
        }
        x += colonWidth;
        drawLabel(dc, x, cy, _timeFont, minutes, FaceSettings.getColor(FaceSettings.MINUTES_KEY), left);
    }

    // Widest possible time string is sized to fit; falls back to the bitmap font without vector font support.
    private function largestTimeFont(dc as Graphics.Dc) as Graphics.FontType {
        if (!(Graphics has :getVectorFont)) {
            return Graphics.FONT_NUMBER_THAI_HOT;
        }
        var maxWidth = dc.getWidth() * TIME_WIDTH_RATIO;
        for (var size = TIME_MAX_SIZE; size >= TIME_MIN_SIZE; size -= 4) {
            var font = Graphics.getVectorFont({:face => ["RobotoCondensedBold", "BionicBold"], :size => size});
            if (font == null) {
                return Graphics.FONT_NUMBER_THAI_HOT;
            }
            if (dc.getTextWidthInPixels("00:00", font) <= maxWidth) {
                return font;
            }
        }
        return Graphics.FONT_NUMBER_THAI_HOT;
    }

    private function formatDate(now as Gregorian.Info) as String {
        return Lang.format("$1$/$2$/$3$", [
            (now.month as Number).format("%02d"),
            (now.day as Number).format("%02d"),
            (now.year as Number).format("%04d")
        ]);
    }

    private function formatSteps() as String {
        var steps = ActivityMonitor.getInfo().steps;
        return steps == null ? "0" : steps.toString();
    }

    private function formatBatteryLeft() as String {
        var stats = System.getSystemStats();
        if (!(stats has :batteryInDays) || stats.batteryInDays == null) {
            return stats.battery.toNumber() + "%";
        }
        var days = stats.batteryInDays as Float;
        if (days >= 1) {
            return days.toNumber() + "d";
        }
        return (days * 24).toNumber() + "h";
    }
}
