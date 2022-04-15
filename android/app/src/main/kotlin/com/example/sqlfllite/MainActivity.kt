package com.example.sqlfllite
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("162cc3e0-4c39-40e6-9f36-6201a2ebec56")
        MapKitFactory.setLocale("ru_RU")
        super.configureFlutterEngine(flutterEngine)
    }
}