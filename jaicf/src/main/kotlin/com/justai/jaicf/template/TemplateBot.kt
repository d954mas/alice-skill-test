package com.justai.jaicf.template

import com.justai.jaicf.BotEngine
import com.justai.jaicf.activator.catchall.CatchAllActivator
import com.justai.jaicf.activator.event.BaseEventActivator
import com.justai.jaicf.context.manager.InMemoryBotContextManager
import com.justai.jaicf.mongo.MongoBotContextManagerGame
import com.justai.jaicf.template.scenario.MainScenario
import com.mongodb.MongoClient
import com.mongodb.MongoClientURI

private val contextManager = System.getenv("MONGODB_URI")?.let { url ->
    val uri = MongoClientURI(url)
    val client = MongoClient(uri)
    MongoBotContextManagerGame(client.getDatabase(uri.database!!).getCollection("contexts"))

} ?: InMemoryBotContextManager

val templateBot = BotEngine(
        model = MainScenario.model,
        contextManager = contextManager,
        activators = arrayOf(
                BaseEventActivator,
                CatchAllActivator
        )
)