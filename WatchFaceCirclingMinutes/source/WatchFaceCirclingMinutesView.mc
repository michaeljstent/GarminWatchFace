using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Math;
using Toybox.Time.Gregorian as TimeInfo;

class WatchFaceCirclingMinutesView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours]);
        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);
        view.setColor(0xa0a0a0);

		var minutes = Lang.format(clockTime.min.format("%02d"));
        var viewMin = View.findDrawableById("Minutes");
        viewMin.setText(minutes);
        
        //Color Minutes
        if (Sys.getSystemStats().battery > 50) {
			viewMin.setColor(0x20ff20);
		}
		else if (Sys.getSystemStats().battery > 25) {
			viewMin.setColor(0xffff00);
		}
		else if (Sys.getSystemStats().battery > 10) {
			viewMin.setColor(0xff8000);
		} 
		else {
			viewMin.setColor(0xff80800);
		}	        
        
        //Place Minutes
        var r = 80;
        var theta = (clockTime.min * Toybox.Math.PI / 30);
        var xFact = Toybox.Math.sin(theta) * r;
        var yFact = Toybox.Math.cos(theta) * r;
        viewMin.setLocation(dc.getWidth()/2 + xFact, 78 - yFact);
        
        //Place Dow
        var dow = View.findDrawableById("DoW");
        var timeNow = Toybox.Time.now();
        var information = TimeInfo.info(timeNow, Toybox.Time.FORMAT_MEDIUM);
        dow.setText(information.day_of_week.substring(0,2));
        dow.setLocation(dc.getWidth()/2 - 53, 96);
        dow.setColor(0xffffff);
        
        //Place date
        var date = View.findDrawableById("Date");
        date.setText(Lang.format("$1$",[information.day]));
        date.setLocation(dc.getWidth()/2 + 33, 96);
        date.setColor(0xffffff);
       
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}