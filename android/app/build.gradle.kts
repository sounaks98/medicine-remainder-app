import java.util.Base64

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Android Studio Run → Environment variables: pass HUGGINGFACE_TOKEN into Dart compile.
val huggingFaceTokenFromEnv = System.getenv("HUGGINGFACE_TOKEN")
if (!huggingFaceTokenFromEnv.isNullOrBlank()) {
    val tokenDefine = Base64.getEncoder()
        .encodeToString("HUGGINGFACE_TOKEN=$huggingFaceTokenFromEnv".toByteArray(Charsets.UTF_8))
    val existingDartDefines = project.findProperty("dart-defines") as? String ?: ""
    val mergedDartDefines = if (existingDartDefines.isEmpty()) {
        tokenDefine
    } else {
        "$existingDartDefines,$tokenDefine"
    }
    project.extensions.extraProperties.set("dart-defines", mergedDartDefines)
}
android {
    namespace = "com.medicinereminder.medicine_remainder_app"
    // Latest stable at P0-06; align with README and Play policy over time.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.medicinereminder.medicine_remainder_app"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        // minSdk 30: LiteRT-LM (Gemma spike) requires API 30+; ML Kit still supported.
        minSdk = 30
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
        targetSdk = 35
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.mlkit:text-recognition:16.0.1")
    // Phase 2 SmolVLM ONNX load spike (P2-05).
    implementation("com.microsoft.onnxruntime:onnxruntime-android:1.20.0")
    androidTestImplementation("androidx.test:runner:1.6.2")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
}
