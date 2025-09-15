
package com.example.routin_flutter.services

import android.content.Context
import android.content.pm.PackageManager
import android.graphics.drawable.BitmapDrawable
import android.graphics.Bitmap
import android.util.Base64
import java.io.ByteArrayOutputStream

object AppInfoHelper {
    private val appInfoCache = mutableMapOf<String, Map<String, Any?>>()

    fun getAppInfo(context: Context, packageName: String): Map<String, Any?> {
        appInfoCache[packageName]?.let { return it }

        return try {
            val pm: PackageManager = context.packageManager
            val appInfo = pm.getApplicationInfo(packageName, 0)
            val label = pm.getApplicationLabel(appInfo).toString()

            val drawable = pm.getApplicationIcon(appInfo)
            var iconBase64: String? = null
            if (drawable is BitmapDrawable) {
                val bitmap: Bitmap = drawable.bitmap
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                val bytes = stream.toByteArray()
                iconBase64 = Base64.encodeToString(bytes, Base64.NO_WRAP)
            }

            val info = mapOf(
                "packageName" to packageName,
                "appName" to label,
                "icon" to iconBase64
            )
            appInfoCache[packageName] = info
            info
        } catch (e: Exception) {
            val fallback = mapOf(
                "packageName" to packageName,
                "appName" to packageName,
                "icon" to null
            )
            appInfoCache[packageName] = fallback
            fallback
        }
    }
}