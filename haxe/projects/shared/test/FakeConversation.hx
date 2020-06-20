package ;

import shared.Shared;

class FakeConversation {
    public function new() {
        clear();
    }

    public function clear() {

    }


    public function getShared(initClientStorage = false):Shared {
        var shared = new Shared("{}", "{}", true);
        shared.world.storageGet().version = {
            version:"0",
            time:0,
            server:"test",
        }
        shared.updateServerTime();
        return shared;
    }


}
