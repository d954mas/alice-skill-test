package shared.utils;

typedef ResponseDef = {
    type:String,
    data:Dynamic
}

class ResponseBuilder {
    private var result:Array<ResponseDef>;

    public function new() {
        result = new Array();
    }

    public function getResult():Array<ResponseDef> {
        return result;
    }

    public function clear() {
        result = new Array();
    }

    public function say(text:String) {
        result.push({type:"say", data:{text:text}});
    }


}
