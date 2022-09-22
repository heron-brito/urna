package com.example.urna

import io.flutter.embedding.android.FlutterActivity
// Heron
import com.tekartik.sqflite.SqflitePlugin

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // ImagePickerPlugin.registerWith(registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"))
        SqflitePlugin.registerWith(registrarFor("com.tekartik.sqflite.SqflitePlugin"))

    }    
}
