package shared.project.storage;


import shared.base.struct.ContextStruct;
import shared.project.timers.BaseTimer.TimerStatus;
import haxe.DynamicAccess;

typedef VersionStorageStruct = {
    var version:String;
    var time:Int;
    var server:String;
}

typedef StatStorageStruct = {
    var startGameCounter:Int;
    var version:Int;
    var intentIdx:Int;
}

typedef TimerStorageStruct = {
    var startTime:Float; //-1 if disabled
    var endTime:Float; //-1 if disabled
    var timeLeft:Float; //-1 if disabled
    var status:TimerStatus; //-1 if disabled
}

typedef TimersStorageStruct = {
    var serverLastTime:Float; //time of last responce in server.Set when restore storage.Also set when intent processing done
    var clientDeltaTime:Float; //0 in server. In client it calc like, serverTime - clientTime
    var time:Float; //client system time + clientDeltaTime. Update when process intent in server. Or every frame in client
    var timerDelta:Float; //delta from prev update timer
}

typedef ContextsStorageStruct = {
    var contexts:DynamicAccess<ContextStruct>;
}

typedef ProfileStorageStruct = {
    var level:Int;
    var exp:Int;
    var cheatsEnabled:Bool;
    var uuid:String;
    var tag:String;//Чтобы различать наши стейты=)
    var name:String;
    var locale:String;

    //нужно чтобы запретить одновременную игру с нескольких аккаунтов.
    var conversationIdAtStart:String;
    var conversationIdCurrent:String;
    var currentVersion:String;
}


typedef StorageStruct = {
    var stat:StatStorageStruct;
    var version:VersionStorageStruct;
    var profile:ProfileStorageStruct;
    var contexts:ContextsStorageStruct;
    var timers:TimersStorageStruct;
}

//endregion
class Storage {
    private static inline var VERSION:Int = 1;

    public static function initNewStorage(data:StorageStruct, force = true) {
        if (data.stat == null || force) {
            data.stat = {
                version : VERSION,
                startGameCounter:0,
                intentIdx:0,
            }
            var uuid = "";
            if (data.profile != null && data.profile.uuid != null) {
                uuid = data.profile.uuid;
            }
            var tag = "";
            if (data.profile != null && data.profile.tag != null) {
                tag = data.profile.tag;
            }
            var idAtStart = "";
            var idCurrent = "";
            if (data.profile != null && data.profile.conversationIdAtStart != null) {
                idAtStart = data.profile.conversationIdAtStart;
            }
            if (data.profile != null && data.profile.conversationIdCurrent != null) {
                idCurrent = data.profile.conversationIdCurrent;
            }
            data.profile = {
                level:1,
                exp:0,
                cheatsEnabled:false,
                uuid:uuid,
                tag:tag,
                conversationIdAtStart:idAtStart,
                conversationIdCurrent:idCurrent,
                currentVersion:"",
                locale:"ru",
                name:"unknown"
            }
            data.timers = {
                clientDeltaTime:0,
                serverLastTime:0,
                time:0,
                timerDelta:0,
            }
            data.version = {
                time:0,
                version:"0",
                server:"unknown"
            }

            data.contexts = {contexts:{}};
        };
    }

    private static function migrations(data:StorageStruct) {
        if (data.stat == null) {
            initNewStorage(data);
            return;
        }
        data.stat.version = VERSION;
    }

    public static function restore(data:String):StorageStruct {
        var result:StorageStruct = haxe.Json.parse(data);
        migrations(result);
        return result;
    }
}
