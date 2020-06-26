package com.justai.jaicf.template.utils.shared_result

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonObject

@Serializable
data class ResponseType(
        val type: String,
        val data: JsonObject
)

@Serializable
data class SharedResult(
        val response: Response,
        val intent: String,
        val storage: JsonObject
) {
    @Serializable
    data class Response(
            val modelResult: ModelResult,
            val response: Array<ResponseType>
    ) {
        @Serializable
        data class ModelResult(
                val code: String
        )
    }

}