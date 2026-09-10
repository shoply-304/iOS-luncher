package com.cretivoza.ioslauncher

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "ios_launcher/system"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "installedApps" -> {
                        val pm = packageManager
                        val intent = Intent(Intent.ACTION_MAIN, null)
                        intent.addCategory(Intent.CATEGORY_LAUNCHER)
                        val apps = pm.queryIntentActivities(intent, PackageManager.MATCH_ALL)
                            .map {
                                mapOf(
                                    "packageName" to it.activityInfo.packageName,
                                    "label" to it.loadLabel(pm).toString()
                                )
                            }
                            .distinctBy { it["packageName"] }
                            .sortedBy { (it["label"] as String).lowercase() }
                        result.success(apps)
                    }
                    "launchApp" -> {
                        val packageName = call.argument<String>("packageName")
                        if (packageName == null) {
                            result.error("ARG", "Missing packageName", null)
                        } else {
                            val launch = packageManager.getLaunchIntentForPackage(packageName)
                            if (launch != null) {
                                launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(launch)
                                result.success(true)
                            } else {
                                result.success(false)
                            }
                        }
                    }
                    "openWifi" -> {
                        startActivity(Intent(Settings.ACTION_WIFI_SETTINGS))
                        result.success(true)
                    }
                    "openBluetooth" -> {
                        startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
                        result.success(true)
                    }
                    "openNetwork" -> {
                        startActivity(Intent(Settings.ACTION_WIRELESS_SETTINGS))
                        result.success(true)
                    }
                    "openDisplay" -> {
                        startActivity(Intent(Settings.ACTION_DISPLAY_SETTINGS))
                        result.success(true)
                    }
                    "openSystemSettings" -> {
                        startActivity(Intent(Settings.ACTION_SETTINGS))
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
