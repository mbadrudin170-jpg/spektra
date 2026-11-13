package com.example.spektra

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

// Menyalurkan event tombol Volume Up/Down ke Flutter lewat EventChannel
// `spektra/tombol_volume` (dipakai tes diagnostik). Tombol lain dan perilaku
// bawaan (perubahan volume) tidak diubah.
class MainActivity : FlutterActivity() {
    private var volumeSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "spektra/tombol_volume")
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    volumeSink = events
                }

                override fun onCancel(arguments: Any?) {
                    volumeSink = null
                }
            })
    }

    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        if (event.action == KeyEvent.ACTION_DOWN &&
            (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP ||
                event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN)
        ) {
            volumeSink?.send(
                if (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP) "up" else "down",
            )
        }
        return super.dispatchKeyEvent(event)
    }
}
