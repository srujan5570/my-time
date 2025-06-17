package com.example.my_time

import android.app.Application
import com.castarsdk.android.CastarSdk
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import io.flutter.plugin.common.MethodChannel

class MyApplication : Application() {
    companion object {
        var clientId: String = ""
        var uptime: Long = 0
        var isRunning: Boolean = false
        
        fun startSdk(context: Application) {
            if (clientId.isNotEmpty() && !isRunning) {
                GlobalScope.launch(Dispatchers.IO) {
                    CastarSdk.Start(context, clientId)
                    isRunning = true
                    // Start tracking uptime
                    startUptimeTracking()
                }
            }
        }
        
        fun stopSdk() {
            if (isRunning) {
                CastarSdk.Stop()
                isRunning = false
            }
        }
        
        private fun startUptimeTracking() {
            uptime = 0
            GlobalScope.launch(Dispatchers.IO) {
                while (isRunning) {
                    kotlinx.coroutines.delay(1000)
                    uptime++
                }
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        // The actual SDK start will be called from Flutter
    }
} 