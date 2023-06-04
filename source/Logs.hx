package;

#if ansi
import ANSI;
#end

class Logs
{
    //This is a glue fix for it to compile on windows, i'll make it work properly on windows later.
    public static function trace(str:String, level:DebugLevel = INFO #if ansi,  color:ANSI.Attribute = DefaultForeground #else, ?color:Dynamic #end) {
        #if ansi Sys.print(ANSI.set(White)); #end
        Sys.println(prepareAnsiTrace(level) #if ansi + ANSI.set(color) #end + str);
        #if ansi Sys.print(ANSI.set(DefaultForeground)); #end
    }

    
    private static function prepareAnsiTrace(level:DebugLevel = INFO) {
        /*TIME STUFF*/
        var time = Date.now();
        final hour:String = Std.string(time.getHours());
        final min:String = Std.string(time.getMinutes());
        final sec:String = Std.string(time.getSeconds());
        final format = formatTime(hour, min, sec);

        /*LEVEL STUFF*/
        var lv:String = switch (level) {
            case ERROR: #if ansi ANSI.set(Red) + #end '  ERROR  ';
            case WARNING: #if ansi ANSI.set(Yellow) + #end '  WARNING  ';
            case INFO: #if ansi ANSI.set(Cyan) + #end '  INFORMATION  ';
        }

        var out:String = #if ansi ANSI.set(Magenta) + #end'[  ${format[0]}:${format[1]}:${format[2]}  |' + lv + '] ';

        return out;
    }

    private static function formatTime(hour:String, minute:String, second:String):Array<String> {
        var arr:Array<String> = [hour, minute, second];
        for (i in 0...arr.length) {
            if (arr[i].length == 1){
                arr[i] = '0' + arr[i];
            }
        }
        return arr;
    }
}

enum abstract DebugLevel(Int) {
    var ERROR = 0;
    var WARNING = 1;
    var INFO = 3;
}