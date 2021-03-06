package shared;

import shared.utils.ResponseBuilder.ResponseDef;
import shared.Shared.OutputResponse;
import jsoni18n.I18n;
import shared.base.SpeechCommands;
import shared.utils.SpeechBuilder;
import shared.project.utils.TimeUtils;
import Array;
import shared.base.Localization;
import shared.base.output.ModelOutputResponse;
import shared.base.output.ModelOutputResultCode;
import shared.base.struct.ContextStruct;
import shared.project.enums.Intent;
import shared.project.intent_processors.IntentProcessor;
import shared.project.model.World;
import shared.project.storage.Storage;

@:expose @:keep class Shared {
    private var i18n:I18n;
    public var world:World;
    private var intentProcessor:IntentProcessor;
    private var storageBackupJson:String;

    public function new(storageJson:String) {
        storageBackupJson = storageJson;
        var storage:StorageStruct = Storage.restore(storageJson);
        world = new World(storage);
        i18n = Localization.getI18n(storage.profile.locale);
        world.setI18n(i18n);
        intentProcessor = new IntentProcessor(world, this, i18n);
    }

    public function setConversationID(id:String) {
        world.storageGet().profile.conversationIdCurrent = id;
    }

    public function setUUID(uuid:String) {
        world.storageGet().profile.uuid = uuid;
    }

    //called only in backend
    public function updateServerTime(?time:Float) {
        world.storageGet().timers.serverLastTime = time != null ? time : TimeUtils.getCurrentTime();
    }

    public function updateTime() {
        var prevTime = world.storageGet().timers.time;
        world.timers.update(true);
        world.storageGet().timers.timerDelta = world.storageGet().timers.time - prevTime;
    }

    public function postProcessIntent(response:OutputResponse) {
    }

    public function processIntent(intentStart:Intent, ?data:Dynamic):OutputStruct {
        world.intent = intentStart;
        updateTime();

        world.storageGet().stat.intentIdx++;
        try {
            world.canProcessIntent(world.intent, data, true);

            var response:OutputResponse = intentProcessor.processIntent(world.intent, data);
            postProcessIntent(response);

            var speechBuilder:SpeechBuilder = new SpeechBuilder();
            if (!world.speechBuilder.isEmpty()) {
                speechBuilder.text(world.speechBuilder.buildText());
                world.speechBuilder = new SpeechBuilder();
            }

            if (!intentProcessor.speechBuilder.isEmpty()) {
                speechBuilder.text(intentProcessor.speechBuilder.buildText());
                intentProcessor.speechBuilder = new SpeechBuilder();
            }

            if (!speechBuilder.isEmpty()) {
                //this.getNativeApi().convAsk(speechBuilder.build());
            }


            if (response.modelResult.code == ModelOutputResultCode.EXIT) {

            }
            if (response.modelResult.code == ModelOutputResultCode.EXIT_AND_SAVE) {

            }


            //  flush();
            //  world.eventClear();
            var out = outputGet();
            out.response = response;
            out.intent = world.intent;
            out.response.response = world.responseBuilder.getResult();
            world.responseBuilder.clear();
            return out;
            // out.intent = world.intent;
            //  out.response = response;
            //  nativeApi.convAskHtmlResponse(haxe.Json.stringify(out));
        } catch (error:String) {
            world.timers.update();
            return processError(error);
        }


    }

    public function processIntentStringResult(intentStart:Intent, ?data:Dynamic):String {
        return haxe.Json.stringify(processIntent(intentStart, data));
    }


    private function processError(error:String):OutputStruct {
        //reset states
        world.storageReset(Storage.restore(storageBackupJson));

        var out = outputGet();
        var intent:Intent = Intent.MAIN_ERROR;
        out.intent = intent;

        var code:ModelOutputResultCode = ModelOutputResultCode.ERROR;
        var modelResult:ModelOutputResponse = {code : ModelOutputResultCode.ERROR, data:error};

        out.response = {
            modelResult : modelResult,
            response : new Array<ResponseDef>()
        };

        return out;
    }


    public function outputGet():OutputStruct {
        return {
            storage:world.storageOutputGet()
        }
    }


    //Load all heavy dependencies. Localizations,configs and etc.
    public static function load() {
        var time = TimeUtils.getCurrentTime();
        Intents.init();
        Localization.load();
        SpeechCommands.load();
        trace("load shared" + (TimeUtils.getCurrentTime() - time));
    }

    public static function jsonToDynamic(json:String) {
        return haxe.Json.parse(json);
    }
}


typedef OutputResponse = {
    var modelResult:ModelOutputResponse;
    var response:Array<ResponseDef>;
}

typedef OutputStruct = {
    var storage:Dynamic;
    @:optional var intent:Intent;
    @:optional var response:OutputResponse;
}


