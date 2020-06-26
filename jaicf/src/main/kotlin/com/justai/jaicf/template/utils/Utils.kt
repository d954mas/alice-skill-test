package com.justai.jaicf.template.utils

import com.justai.jaicf.api.BotRequest
import com.justai.jaicf.context.BotContext
import kotlinx.serialization.json.*
import shared.Shared
import kotlin.collections.ArrayList
import kotlin.collections.HashMap


class Utils {
    companion object {
        private val json = Json(JsonConfiguration.Stable.copy(strictMode = false, encodeDefaults = false))

        fun getLocale(context: BotContext, request: BotRequest): String {
            return "ru";
        }

        fun getGameStorageString(context: BotContext): String {
            var game: String = context.client["game"] as String? ?: "{}"
            return game
        }

        fun chatApiToIntentName(name: String): String {
            var result = name.removeSuffix("/intent")
            result = result.removeSuffix("/pattern")
            result = result.replace("/", ".")
            if (result.startsWith(".")) {
                result = result.substring(1);
            }
            return result.trim();
        }

        fun jsonToMap(json: JsonObject): Map<String, Any> {
            val map: MutableMap<String, Any> = HashMap()

            val mapJson: Map<String, JsonElement> = json.toMap();

            for (pair in mapJson) {
                val key = pair.key
                var value: JsonElement = pair.value
                if (value.isNull) {

                } else if (value is JsonLiteral) {
                    if (value.isString) {
                        map.put(key, value.primitive.content)
                    } else if (value.booleanOrNull != null) {
                        map.put(key, value.boolean)
                    } else {
                        map.put(key, value.float)
                    }

                } else if (value is JsonObject) {
                    map.put(key, jsonToMap(value))
                } else if (value is JsonArray) {
                    map.put(key, jsonToArray(value.jsonArray))
                } else {
                    throw Exception("unknow json")
                }
            }
            return map
        }

        fun jsonToArray(json: JsonArray): List<Any> {
            var list: MutableList<Any> = ArrayList();
            for (value in json.content) {
                if (value is JsonPrimitive) {
                    list.add(value.primitive.content)
                } else if (value is JsonObject) {
                    list.add(jsonToMap(value))
                } else if (value is JsonArray) {
                    list.add((jsonToArray(value)))
                }
            }
            return list;
        }

        fun getShared(context: BotContext, request: BotRequest): Shared {
            return Shared(getGameStorageString(context))
        }

    }
}
