package com.justai.jaicf.mongo

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.justai.jaicf.context.BotContext
import com.justai.jaicf.context.manager.BotContextManager
import com.mongodb.client.MongoCollection
import com.mongodb.client.model.Filters
import com.mongodb.client.model.UpdateOptions
import org.bson.Document

//Копия стандартного. Только хранить game не в сериализованном виде, а в виде json.
//Нужно чтобы можно было делать запросы в mongo db
class MongoBotContextManagerGame(
        private val collection: MongoCollection<Document>
) : BotContextManager {

    private val mapper = jacksonObjectMapper().enableDefaultTyping()

    override fun loadContext(clientId: String): BotContext {
        return collection
                .find(Filters.eq("_id", clientId))
                .iterator().tryNext()?.let { doc ->
                    if (doc.containsKey("game")) {
                        doc.set("game", doc.get("game", Document::class.java).toJson())
                    }
                    val model = mapper.readValue(doc.toJson(), BotContextModelGame::class.java)
                    BotContext(model._id, model.dialogContext).apply {
                        result = model.result
                        client.putAll(model.client)
                        session.putAll(model.session)
                        client["game"] = model.game
                    }


                } ?: BotContext(clientId)
    }

    override fun saveContext(botContext: BotContext) {
        var gameStorage: String = botContext.client["game"] as String;

        botContext.client["game"] = "game";
        BotContextModelGame(
                _id = botContext.clientId,
                result = botContext.result,
                client = botContext.client.toMap(),
                session = botContext.session.toMap(),
                dialogContext = botContext.dialogContext,
                game = "game"
        ).apply {
            var resultJson = mapper.writeValueAsString(this);
            resultJson = resultJson.replaceFirst("\"game\":\"game\"", "\"game\":" + gameStorage);
            val doc = Document.parse(resultJson)
            collection.replaceOne(Filters.eq("_id", _id), doc, UpdateOptions().upsert(true))
        }
    }
}