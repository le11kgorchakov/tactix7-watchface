import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

module FaceSettings {

    const HOURS_KEY = "HoursColor";
    const MINUTES_KEY = "MinutesColor";
    const COLON_KEY = "ColonColor";
    const SHOW_COLON_KEY = "ShowColon";
    const HOURLY_FLAG_KEY = "HourlyFlag";

    const NAMES = ["White", "Light Gray", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink"];
    const COLORS = [
        Graphics.COLOR_WHITE,
        Graphics.COLOR_LT_GRAY,
        Graphics.COLOR_RED,
        Graphics.COLOR_ORANGE,
        Graphics.COLOR_YELLOW,
        Graphics.COLOR_GREEN,
        Graphics.COLOR_BLUE,
        Graphics.COLOR_PURPLE,
        Graphics.COLOR_PINK
    ];

    function getColor(key as String) as Number {
        var value = Properties.getValue(key);
        return value instanceof Number ? value : Graphics.COLOR_WHITE;
    }

    function isEnabled(key as String) as Boolean {
        var value = Properties.getValue(key);
        return value instanceof Boolean ? value : true;
    }

    function colorName(color as Number) as String {
        var index = COLORS.indexOf(color);
        return index >= 0 ? NAMES[index] : "Custom";
    }
}

class SettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Customize"});
        addItem(new WatchUi.MenuItem("Hours color", FaceSettings.colorName(FaceSettings.getColor(FaceSettings.HOURS_KEY)), FaceSettings.HOURS_KEY, null));
        addItem(new WatchUi.ToggleMenuItem("Show colon", null, FaceSettings.SHOW_COLON_KEY, FaceSettings.isEnabled(FaceSettings.SHOW_COLON_KEY), null));
        addItem(new WatchUi.MenuItem("Colon color", FaceSettings.colorName(FaceSettings.getColor(FaceSettings.COLON_KEY)), FaceSettings.COLON_KEY, null));
        addItem(new WatchUi.MenuItem("Minutes color", FaceSettings.colorName(FaceSettings.getColor(FaceSettings.MINUTES_KEY)), FaceSettings.MINUTES_KEY, null));
        addItem(new WatchUi.ToggleMenuItem("Hourly US flag", "First minute of each hour", FaceSettings.HOURLY_FLAG_KEY, FaceSettings.isEnabled(FaceSettings.HOURLY_FLAG_KEY), null));
    }
}

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var key = item.getId() as String;
        if (item instanceof WatchUi.ToggleMenuItem) {
            Properties.setValue(key, item.isEnabled());
            WatchUi.requestUpdate();
            return;
        }
        WatchUi.pushView(new ColorPickerMenu(item.getLabel(), key), new ColorPickerDelegate(item, key), WatchUi.SLIDE_LEFT);
    }
}

class ColorPickerMenu extends WatchUi.Menu2 {

    function initialize(title as String, key as String) {
        Menu2.initialize({:title => title});
        var current = FaceSettings.getColor(key);
        for (var i = 0; i < FaceSettings.COLORS.size(); i++) {
            var color = FaceSettings.COLORS[i];
            addItem(new WatchUi.MenuItem(FaceSettings.NAMES[i], color == current ? "Selected" : null, color, null));
        }
    }
}

class ColorPickerDelegate extends WatchUi.Menu2InputDelegate {

    private var _parentItem as WatchUi.MenuItem;
    private var _key as String;

    function initialize(parentItem as WatchUi.MenuItem, key as String) {
        Menu2InputDelegate.initialize();
        _parentItem = parentItem;
        _key = key;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var color = item.getId() as Number;
        Properties.setValue(_key, color);
        _parentItem.setSubLabel(FaceSettings.colorName(color));
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.requestUpdate();
    }
}
