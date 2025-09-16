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
        val begin = end - 1000L * 60 * 60 * 24 * 5

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
                "lastTimeUsed" to it.lastTimeUsed,
                "firstTimeStamp" to it.firstTimeStamp
            )
        }
    }

    /**
     * ดึงรายการเหตุการณ์การใช้งานย้อนหลัง 1 วัน
     */
    private fun getUsageEvents(): List<Map<String, Any?>> {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val end = System.currentTimeMillis()
        val begin = end - 24L * 60 * 60 * 1000

        val evs = usm.queryEvents(begin, end)
        val e = android.app.usage.UsageEvents.Event()
        val out = mutableListOf<Map<String, Any?>>()

        val interested = setOf(
            android.app.usage.UsageEvents.Event.ACTIVITY_RESUMED,
            android.app.usage.UsageEvents.Event.ACTIVITY_STOPPED,
        )

        while (evs.hasNextEvent()) {
            evs.getNextEvent(e)
            if (e.eventType in interested) {
                val info = com.example.routin_flutter.services.AppInfoHelper
                    .getAppInfo(this, e.packageName ?: "")
                out.add(
                    mapOf(
                        "packageName" to (e.packageName ?: ""),
                        "className" to e.className,
                        "appName" to info["appName"],
                        "icon" to info["icon"],
                        "eventType" to e.eventType,
                        "timeStamp" to e.timeStamp
                    )
                )
            }
        }
        return out
    }
}