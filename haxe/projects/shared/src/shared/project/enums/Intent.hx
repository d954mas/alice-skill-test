package shared.project.enums;


import shared.project.model.World;
import shared.base.struct.ContextStruct;
import shared.base.enums.ContextName;

@:expose @:keep
enum abstract Intent(String) {
    var MAIN_WELCOME = "main.welcome";
    var MAIN_FALLBACK = "main.fallback";
    var MAIN_ERROR = "main.error";
}


interface IntentChecker {

    public function check(world:World, intent:Intent, ?data:Dynamic):Bool;
}

class IntentCheckerTrue implements IntentChecker {
    public function new() {
    }
    public function check(world:World, intent:Intent, ?data:Dynamic):Bool {
        return true;
    }
}

class IntentCheckerContexts implements IntentChecker {
    var contexts:Array<ContextName>;

    public function new(contexts:Array<ContextName>) {
        this.contexts = contexts;
    }

    public function check(world:World, intent:Intent, ?data:Dynamic):Bool {
        for (ctx in contexts) {if (!world.storage.contexts.contexts.exists(Std.string(ctx))) {return false;}}
        return true;
    }
}

@:expose @:keep class Intents {
    public static var intentCanProcessChecks:Map<Intent, IntentChecker> = new Map();


    public static function init() {
        intentCanProcessChecks = new Map();
        intentCanProcessChecks[Intent.MAIN_WELCOME] = new IntentCheckerTrue();
        intentCanProcessChecks[Intent.MAIN_FALLBACK] = new IntentCheckerTrue();
        intentCanProcessChecks[Intent.MAIN_ERROR] = new IntentCheckerTrue();
    }

    public static function isIntent(name:Intent) {
        return intentCanProcessChecks.exists(name);
    }

    public static function canProcess(world:World, intent:Intent, ?data:Dynamic, throwExeption:Bool = false) {
        var checker = Intents.intentCanProcessChecks.get(intent);
        if (checker == null) {
            trace("unknown intent " + intent);
            if (throwExeption) {throw "unknown intent " + intent;}
            return false;
        } else {
            return checker.check(world, intent, data);
        }
    }

}