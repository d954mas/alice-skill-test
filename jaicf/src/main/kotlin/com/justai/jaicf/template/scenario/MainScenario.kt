package com.justai.jaicf.template.scenario

import com.justai.jaicf.activator.catchall.catchAll
import com.justai.jaicf.activator.event.EventActivator
import com.justai.jaicf.activator.event.event
import com.justai.jaicf.channel.yandexalice.AliceChannel
import com.justai.jaicf.channel.yandexalice.AliceEvent
import com.justai.jaicf.channel.yandexalice.api.alice
import com.justai.jaicf.model.scenario.Scenario
import com.justai.jaicf.template.utils.Utils
import com.justai.jaicf.template.utils.shared_result.SharedResult
import com.mongodb.util.JSON
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonConfiguration
import org.slf4j.LoggerFactory
import java.util.HashMap


object MainScenario : Scenario() {

    data class HaxeResultResponseModelResult(
            var modelResult: String
    )

    data class HaxeResultResponse(
            var modelResult: HaxeResultResponseModelResult
    )

    data class HaxeResult(
            var response: HaxeResultResponse

    )

    private val LOGGER = LoggerFactory.getLogger(MainScenario::class.java)
    private val JSON = Json(JsonConfiguration.Stable.copy(strictMode = false, encodeDefaults = false))

    init {

        state("main", noContext = true) {
            activators {
                activators {
                    event(AliceEvent.START)
                }
                catchAll()
            }

            action {
                LOGGER.info("user_id:" + context.clientId)
                LOGGER.info("input:" + request.input)

                LOGGER.info("user storage:" + Utils.getGameStorageString(context));

                val model = Utils.getShared(context, request)

                var conversationID: String = request.alice?.accessToken ?: "0001"

                model.setConversationID(conversationID)
                model.setUUID(context.clientId)

                val intent: String
                val slots: MutableMap<String, String>;
                if (activator.event != null) {
                    intent = "main.welcome"
                    slots = HashMap()
                } else if (activator.catchAll != null) {
                    intent = "main.fallback"
                    slots = HashMap()
                } else {
                    intent = "main.fallback"
                    slots = HashMap()
                }



                LOGGER.info(String.format("intent:%s slots:%s", intent, slots.toString()));
                var result = model.processIntentStringResult(intent, slots)
                LOGGER.info("result:" + result)
                var parsedResult: SharedResult = JSON.parse(SharedResult.serializer(), result)

                context.client["game"] = parsedResult.storage.toString()


                reactions.say("Hi there!")
            }
        }
    }
}