package com.justai.jaicf.template

import com.justai.jaicf.channel.http.httpBotRouting
import com.justai.jaicf.channel.yandexalice.AliceChannel
import io.ktor.routing.routing
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty
import org.apache.log4j.BasicConfigurator
import shared.Shared


fun main() {
    BasicConfigurator.configure()
    Config.load()
    Shared.load()
    embeddedServer(Netty, System.getenv("PORT")?.toInt() ?: 8080) {
        routing {
            routing {
                httpBotRouting("/" to AliceChannel(
                        templateBot,
                        Config.CONFIG.ALISA_OAUTH_TOKEN))
            }
        }
    }.start(wait = true)
}