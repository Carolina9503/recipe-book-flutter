plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.recipe_book"
    compileSdk = 34
    // Cambiado para usar la versión instalada del NDK (requerido para compilar correctamente)
    ndkVersion = "27.0.12077973" 

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.recipe_book"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        getByName("release") { // 💡 CAMBIO: se reemplazó `release {}` por `getByName("release") {}` para Kotlin DSL
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true // 💡 CAMBIO: se cambió `minifyEnabled true` a `isMinifyEnabled = true`
            isShrinkResources = true // 💡 CAMBIO: se cambió `shrinkResources true` a `isShrinkResources = true`
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.github.bumptech.glide:glide:4.12.0") // 💡 CAMBIO: se usaron paréntesis y comillas dobles para Kotlin DSL
    annotationProcessor("com.github.bumptech.glide:compiler:4.12.0") // 💡 CAMBIO
    implementation("com.squareup.retrofit2:retrofit:2.9.0") // 💡 CAMBIO
    implementation("com.squareup.okhttp3:okhttp:4.9.0") // 💡 CAMBIO
}
