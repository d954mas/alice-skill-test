package shared.project.intent_processors;
import jsoni18n.I18n;
import shared.Shared.OutputResponce;
import shared.utils.SpeechBuilder;
import shared.base.enums.ContextName;
import shared.base.output.ModelOutputResponse;
import shared.base.output.ModelOutputResultCode;
import shared.project.enums.Intent;
import shared.project.model.World;
class IntentProcessor {

    private var world:World;
    private var i18n:I18n;
    private var shared:Shared;
    public var speechBuilder:SpeechBuilder;


    public function new(world:World, shared:Shared, i18n:I18n) {
        this.world = world;
        this.shared = shared;
        this.i18n = i18n;
        this.speechBuilder = new SpeechBuilder();
    }


    public function contextChange(name:ContextName, ?lifespan:Int, ?parameters:Dynamic) {
        this.world.contextChange(name, lifespan, parameters);
    }

    public function contextDelete(name:ContextName) {
        this.world.contextDelete(name);
    }

    public function contextExist(name:ContextName) {
        return this.world.contextExist(name);
    }

    public function getResult(modelResult:ModelOutputResponse) {
        return {modelResult : modelResult}
    }

    public function processIntent(intent:Intent, ?data:Dynamic):OutputResponce {
        this.speechBuilder = new SpeechBuilder();

        if (intent == Intent.MAIN_WELCOME) {
            return getResult({code:ModelOutputResultCode.SUCCESS});
        }

        //Server was updates
        if (world.storageGet().version.version != world.storageGet().profile.currentVersion) {
           // ask(i18n.tr("conv/server_was_update"));
            return getResult({code:ModelOutputResultCode.EXIT});
        }

        if (world.storageGet().profile.conversationIdCurrent != world.storageGet().profile.conversationIdAtStart) {
           // ask(i18n.tr("conv/play_multiple_devices"));
            return getResult({code:ModelOutputResultCode.EXIT});
        }

        var storage = world.storageGet();
        switch(intent){
            //region main
            case Intent.MAIN_FALLBACK:
            //    ask(i18n.tr("conv/fallback"));
                return getResult({code : ModelOutputResultCode.SUCCESS});
            default: throw "UnknownIntent:" + intent;
        }
        throw "UnknownIntent:" + intent;
    }
}
