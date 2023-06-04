package;

#if ansi
import ANSI;
#end

class Logs
{
    //This is a glue fix for it to compile on windows, i'll make it work properly on windows later.
    public static function trace(str:String, level:DebugLevel = INFO #if ansi,  color:ANSI.Attribute = DefaultForeground #else, color:Dynamic #end) {
        #if ansi Sys.print(ANSI.set(White)); #end
        Sys.println(prepareAnsiTrace(level) #if ansi + ANSI.set(color) #end + str);
        #if ansi Sys.print(ANSI.set(DefaultForeground)); #end
    }

    #if ansi
    private static function prepareAnsiTrace(level:DebugLevel = INFO) {
        /*TIME STUFF*/
        var time = Date.now();
        final hour:String = Std.string(time.getHours());
        final min:String = Std.string(time.getMinutes());
        final sec:String = Std.string(time.getSeconds());
        final format = formatTime(hour, min, sec);

        /*LEVEL STUFF*/
        var lv:String = switch (level) {
            case ERROR: ANSI.set(Red) + '  ERROR  ';
            case WARNING: ANSI.set(Yellow) + '  WARNING  ';
            case INFO: ANSI.set(Cyan) + '  INFORMATION  ';
        }

        var out:String = ANSI.set(Magenta) + '[  ${format[0]}:${format[1]}:${format[2]}  |' + lv + '] ';

        return out;
    }
    #end

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