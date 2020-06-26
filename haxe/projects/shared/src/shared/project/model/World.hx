package shared.project.model;
import shared.utils.ResponseBuilder;
import jsoni18n.I18n;
import haxe.DynamicAccess;
import shared.base.struct.ContextStruct;
import shared.base.enums.ContextName;
import shared.project.enums.Intent;
import shared.utils.SpeechBuilder;
import shared.project.timers.Timers;
import shared.project.storage.Storage.StorageStruct;

@:expose @:keep
class World {
    @:nullSafety(Off) public var profileModel(default, null):ProfileModel;
    public var storage:StorageStruct;
    public var intent:Intent;
    public var timers:Timers;
    public var responseBuilder:ResponseBuilder;
    public var speechBuilder = new SpeechBuilder();
    public var speechBuilderTutorial = new SpeechBuilder();
    @:nullSafety(Off) public var i18n:I18n;

    public function new(storage:StorageStruct) {
        this.storage = storage;
        intent = Intent.MAIN_FALLBACK;
        timers = new Timers();
        responseBuilder = new ResponseBuilder();
        profileModel = new ProfileModel(this);

        timers.init(this);
    }

    public function setI18n(i18n:I18n) {
        this.i18n = i18n;
    }

    public function getLocalization(key:String, ?params:Map<String, Dynamic>) {
        return i18n.tr(key, params);
    }

    public function canProcessIntent(intent:Intent, ?data:Dynamic, throwExeption:Bool = false) {
        return Intents.canProcess(this, intent, data, throwExeption);
    }

    //region context
    public function contextExist(ctx:ContextName):Bool {
        var data:Null<ContextStruct> = contextGet(ctx);
        if (data == null) {return false;}
        else {
            return true;
        }
    }

    public function contextGet(ctx:ContextName):Null<ContextStruct> {
        return storage.contexts.contexts.get(Std.string(ctx));
    }

    public function contextChange(name:ContextName, lifespan:Int = 99999, ?parameters:Dynamic) {
        storage.contexts.contexts.set(Std.string(name), new ContextStruct(name, lifespan, parameters));
    }

    public function contextDelete(name:ContextName) {
        this.contextChange(name, 0, null);
    }

    public function contextDeleteAll() {
        storage.contexts.contexts = new DynamicAccess();
    }
    //endregion

    //region storage
    public function storageReset(storage:StorageStruct) {this.storage = storage;}

    public function storageGet():StorageStruct {return storage;}

    public function storageOutputGet():StorageStruct {
        return storageGet();
    }

}
