package shared.project.model.shop;
import shared.project.storage.Storage.BoosterStruct;
import shared.project.enums.BoosterName;
import shared.project.configs.GameConfig;
import Array;
import shared.base.enums.ContextName;
import shared.base.event.ModelEventName;
import shared.base.output.ModelOutputResponse;
import shared.base.output.ModelOutputResultCode;
import shared.project.enums.BattleState;
import shared.project.model.base.BaseProjectModel;
import shared.project.model.event.Data.BattleMainWordChangedEventData;
import shared.project.model.event.Data.BattleUserSayWordEventData;
import shared.project.prototypes.Levels;
import shared.project.storage.Storage.BattlePlayedWord;
import shared.project.storage.Storage.ServerBattleWordStruct;
import shared.project.utils.Words;
import shared.project.utils.WordUtils;

class ShopModel extends BaseProjectModel {

    private function check():Void {
        Assert.assert(world.contextExist(ContextName.SHOP), "no shop content");
    }

    public function buyHP() {
        //called not from shop
        if (world.resourcesModel.hpCanRestore()) {
            if (world.resourcesModel.goldCanSpend(GameConfig.SHOP_PRICES.HP.price)) {
                world.resourcesModel.goldSpend(GameConfig.SHOP_PRICES.HP.price);
                ds.resources.hp = Math.ceil(Math.min(ds.resources.hp + GameConfig.SHOP_PRICES.HP.count, GameConfig.MAX_HP));
            }
        }
    }

    public function canBuyBooster(name:BoosterName) {
        return world.resourcesModel.goldCanSpend(costBooster(name));
    }

    public function canBuyPack(pack:ShopPackCost):Bool {
        return world.resourcesModel.goldCanSpend(pack.price);
    }

    public function buyStonesPack(pack:ShopPackCost) {
        check();
        Assert.assert(canBuyPack(pack), "can't buy");
        world.resourcesModel.goldSpend(pack.price);
        world.resourcesModel.stonesAdd(pack.count);
    }

    public function costBooster(name:BoosterName):Int {
        var price:Null<Int> = GameConfig.SHOP_PRICES.BOOSTERS.get(Std.string(name));
        if (price == null) {throw "no price for booster:" + name;}
        return price;
    }

    public function buyBooster(name:BoosterName) {
        Assert.assert(canBuyBooster(name), "can't buy");
        world.resourcesModel.goldSpend(costBooster(name));
        world.resourcesModel.boostersAdd(name, 1);
    }

    public function buyMoneyPack1() {
        check();
        ds.resources.gold += GameConfig.SHOP_PRICES.MONEY[0].count;
    }

    public function buyMoneyPack2() {
        check();
        ds.resources.gold +=  GameConfig.SHOP_PRICES.MONEY[1].count;
    }

    public function buyMoneyPack3() {
        check();
        ds.resources.gold +=  GameConfig.SHOP_PRICES.MONEY[2].count;
    }
}
