package shared.project.model.base;
//model handle all it data in storage
//model can restore it state from storage.For example unit
//can get it prototype by id from storage
import shared.project.storage.Storage.StorageStruct;
class BaseModel {
    private var world:World;
    private var storage:StorageStruct;

    public function new(world:World) {
        this.world = world;
        this.storage = this.world.storageGet();
    }

    public function modelRestore():Void {
    }
}
