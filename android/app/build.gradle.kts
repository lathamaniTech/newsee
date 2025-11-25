plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ubi.agriuat"
    compileSdk = 35
    // ndkVersion = flutter.ndkVersion
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
        applicationId = "com.ubi.agriuat"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        //minSdk = flutter.minSdkVersion
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = "ubiagri"
            keyPassword = "sysarc@ubiagri1234"
            storeFile = file("D:\\Lathamani\\GitHub\\ubi_flutter_github\\ubi_project\\uat_keystore\\ubi_agri_keystore.jks")
            storePassword = "sysarc@ubiagri1234"
        }
    }
 
    buildTypes {
        getByName("release") {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

  //  buildTypes {
       // release {
            // TODO: uncomment thi below three lines before for the release build.
            // This obfuscates Java/Kotlin code.
            // minifyEnabled true
            // shrinkResources true
            // proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
          //  signingConfig = signingConfigs.getByName("debug")
         //   }
   // }
}

flutter {
    source = "../.."
}
