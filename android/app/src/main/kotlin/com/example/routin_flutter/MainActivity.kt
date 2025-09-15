package com.example.routin_flutter

import android.app.usage.UsageStatsManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson
import com.example.routin_flutter.services.AppInfoHelper

class MainActivity: FlutterActivity() {
    private val CHANNEL = "wellbeing_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getTodayUsage" -> {
                        val usage = getTodayUsage()
                        result.success(Gson().toJson(usage))
                    }
                    "getUsageEvents" -> {
                        val events = getUsageEvents()
                        result.success(Gson().toJson(events))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * ดึงข้อมูลสรุปการใช้งานย้อนหลัง 1 วัน
     */
    private fun getTodayUsage(): List<Map<String, Any?>> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val end = System.currentTimeMillis()
        val begin = end - 1000L * 60 * 60 * 24 // 1 วันย้อนหลัง

        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY, begin, end
        )

        return stats.map {
            val info = AppInfoHelper.getAppInfo(this, it.packageName)
            mapOf(
                "packageName" to it.packageName,
                "appName" to info["appName"],
                "icon" to info["icon"], // base64
                "totalTimeUsed" to it.totalTimeInForeground,
                "lastTimeUsed" to it.lastTimeUsed
            )
        }
    }

    /**
     * ดึงรายการเหตุการณ์การใช้งานย้อนหลัง 1 วัน
     */
    private fun getUsageEvents(): List<Map<String, Any?>> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val end = System.currentTimeMillis()
        val begin = end - 1000L * 60 * 60 * 24 // 1 วันย้อนหลัง

        val events = usageStatsManager.queryEvents(begin, end)
        val event = android.app.usage.UsageEvents.Event()
        val list = mutableListOf<Map<String, Any?>>()

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == android.app.usage.UsageEvents.Event.MOVE_TO_FOREGROUND ||
                event.eventType == android.app.usage.UsageEvents.Event.MOVE_TO_BACKGROUND
            ) {
                val info = com.example.routin_flutter.services.AppInfoHelper.getAppInfo(this, event.packageName)

                list.add(
                    mapOf(
                        "packageName" to event.packageName,
                        "appName" to info["appName"],
                        "icon" to info["icon"],  // Base64 string
                        "eventType" to event.eventType, // 1 = Foreground, 2 = Background
                        "timeStamp" to event.timeStamp
                    )
                )
            }
        }
        return list
    }
}