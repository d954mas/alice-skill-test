package com.justai.jaicf.template.scenario

import com.justai.jaicf.activator.catchall.catchAll
import com.justai.jaicf.activator.event.EventActivator
import com.justai.jaicf.activator.event.event
import com.justai.jaicf.channel.yandexalice.AliceChannel
import com.justai.jaicf.channel.yandexalice.AliceEvent
import com.justai.jaicf.channel.yandexalice.api.alice
import com.justai.jaicf.model.scenario.Scenario
import org.slf4j.LoggerFactory
import java.util.HashMap

object MainScenario : Scenario() {
    private val LOGGER = LoggerFactory.getLogger(MainScenario::class.java)

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
                var conversationID: String = request.alice?.accessToken ?: "0001"
                val intent: String
                val slots: MutableMap<String, String>;
                if(activator.event != null){
                    intent = "main.start"
                    slots = HashMap()
                }else if (activator.catchAll != null) {
                    intent = "main.fallback"
                    slots = HashMap()
                } else {
                    intent = "main.fallback"
                    slots = HashMap()
                }
                LOGGER.info(String.format("intent:%s slots:%s", intent, slots.toString()));
                reactions.say("Hi there!")
            }
        }
    }
}