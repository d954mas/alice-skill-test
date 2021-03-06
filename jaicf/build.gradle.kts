plugins {
    application
    kotlin("jvm") version "1.3.61"
    id("com.github.johnrengelman.shadow") version "5.0.0"
    kotlin("plugin.serialization") version "1.3.61"
}

group = "com.justai.jaicf"
version = "1.0.0"

val jaicf = "0.4.0"
val slf4j = "1.7.30"
val ktor = "1.3.1"


application {
    mainClassName = "com.justai.jaicf.template.ServerKt"
}

repositories {
    mavenLocal()
    mavenCentral()
    jcenter()
}

dependencies {
    implementation(kotlin("stdlib-jdk8"))

    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))


    implementation("org.slf4j:slf4j-log4j12:$slf4j")

    implementation("com.justai.jaicf:core:$jaicf")
    implementation("com.justai.jaicf:yandex-alice:$jaicf")
    implementation("com.justai.jaicf:mongo:$jaicf")

    implementation("io.ktor:ktor-server-netty:$ktor")
}

tasks {
    compileKotlin {
        kotlinOptions.jvmTarget = "1.8"
    }
    compileTestKotlin {
        kotlinOptions.jvmTarget = "1.8"
    }
}

tasks.withType<Jar> {
    manifest {
        attributes(
            mapOf(
                "Main-Class" to application.mainClassName
            )
        )
    }
}

tasks.create("stage") {
    dependsOn("shadowJar")
}
