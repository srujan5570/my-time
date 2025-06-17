package com.example.my_time

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import com.castarsdk.android.CastarSdk

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.my_time/service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val clientId = call.argument<String>("clientId") ?: ""
                    if (clientId.isNotEmpty()) {
                        GlobalScope.launch(Dispatchers.IO) {
                            CastarSdk.Start(this@MainActivity, clientId)
                        }
                        result.success(true)
                    } else {
                        result.error("NO_CLIENT_ID", "Client ID is null or empty", null)
                    }
                }
                "stopService" -> {
                    GlobalScope.launch(Dispatchers.IO) {
                        CastarSdk.Stop()
                    }
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
