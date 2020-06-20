package com.justai.jaicf.mongo

import com.justai.jaicf.context.DialogContext

data class BotContextModelGame(
    val _id: String,

    val result: Any?,
    val game: String?,

    val client: Map<String, Any?>,
    val session: Map<String, Any?>,
    val dialogContext: DialogContext
)