package com.justai.jaicf.template

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonConfiguration


@Serializable
data class ConfigData(val ALISA_OAUTH_TOKEN: String)


class Config {
    companion object {
        lateinit var CONFIG: ConfigData
        private val JSON = Json(JsonConfiguration.Stable.copy(strictMode = false, encodeDefaults = false))
        fun load() {
            val isHeroku = System.getenv("ALISA_OUTH_TOKEN") != null;
            if (isHeroku) {
                CONFIG = ConfigData(System.getenv("ALISA_OUTH_TOKEN"));
            }else{
                val fileContent = Config::class.java.getResource("/config.json").readText()
                CONFIG = JSON.parse(ConfigData.serializer(), fileContent)
            }

        }
    }
}