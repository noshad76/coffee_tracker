package com.coffeeaholic.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

class QuickLogWidgetProvider : HomeWidgetProvider() {

    companion object {
        const val ACTION_LOG_DRINK = "com.coffeeaholic.app.ACTION_LOG_DRINK"
        const val PREFS_NAME = "HomeWidgetPreferences"

        data class QuickDrinkItem(
            val id: String,
            val name: String,
            val caffeineMg: Int,
            val volumeMl: Int,
            val artworkId: String,
            val iconRes: Int
        )

        val catalogDrinks = listOf(
            QuickDrinkItem("espresso", "Espresso", 75, 30, "espresso", R.drawable.ic_drink_espresso),
            QuickDrinkItem("americano", "Americano", 150, 250, "americano", R.drawable.ic_drink_mug),
            QuickDrinkItem("matcha", "Matcha", 70, 250, "matcha", R.drawable.ic_drink_tea),
            QuickDrinkItem("latte", "Latte", 120, 300, "latte", R.drawable.ic_drink_latte),
            QuickDrinkItem("coldbrew", "Cold Brew", 200, 350, "cold_brew", R.drawable.ic_drink_coldbrew),
            QuickDrinkItem("cappuccino", "Cappuccino", 80, 180, "cappuccino", R.drawable.ic_drink_latte),
            QuickDrinkItem("tea", "Black Tea", 50, 200, "tea", R.drawable.ic_drink_tea),
            QuickDrinkItem("energy", "Energy Drink", 80, 250, "energy", R.drawable.ic_drink_energy)
        )

        fun resolveIcon(id: String): Int {
            return when {
                id.contains("espresso") -> R.drawable.ic_drink_espresso
                id.contains("americano") || id.contains("black") -> R.drawable.ic_drink_mug
                id.contains("latte") || id.contains("cappuccino") -> R.drawable.ic_drink_latte
                id.contains("cold") || id.contains("brew") -> R.drawable.ic_drink_coldbrew
                id.contains("tea") || id.contains("matcha") -> R.drawable.ic_drink_tea
                id.contains("energy") -> R.drawable.ic_drink_energy
                else -> R.drawable.ic_drink_mug
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_LOG_DRINK) {
            val drinkId = intent.data?.getQueryParameter("id") ?: "espresso"
            val widgetData = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            val drink = findDrink(drinkId, widgetData)
            val nowMs = System.currentTimeMillis()

            // 1. Append to pending_widget_logs so Flutter's MainShell guarantees ingestion on resume
            val pendingLogs = widgetData.getString("pending_widget_logs", "") ?: ""
            val logEntry = "${drink.id}|${drink.name}|${drink.caffeineMg}|${drink.volumeMl}|${drink.artworkId}|$nowMs"
            val updatedPending = if (pendingLogs.isBlank()) logEntry else "$pendingLogs;$logEntry"

            // 2. Insert directly into Drift SQLite database if available
            insertDrinkToDatabase(context, drink)

            // 3. Append to SharedPreferences decay timeline data
            val existing = widgetData.getString("metabolism_drinks_data", "") ?: ""
            val updated = if (existing.isBlank()) "$nowMs:${drink.caffeineMg}" else "$existing,$nowMs:${drink.caffeineMg}"
            val currentToday = widgetData.getSafeInt("today_total_mg", 0) + drink.caffeineMg

            widgetData.edit()
                .putString("pending_widget_logs", updatedPending)
                .putString("metabolism_drinks_data", updated)
                .putInt("today_total_mg", currentToday)
                .apply()

            // 3. Immediately notify Metabolism widget to refresh numbers
            val refreshIntent = Intent(context, MetabolismWidgetProvider::class.java).apply {
                action = MetabolismWidgetProvider.ACTION_REFRESH_METABOLISM
            }
            context.sendBroadcast(refreshIntent)

            // 4. Send persistent heads-up confirmation notification (ONLY one feedback notification, no redundant toast)
            sendLoggedNotification(context, drink, currentToday)

            // 5. Update QuickLog widgets immediately
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = android.content.ComponentName(context, QuickLogWidgetProvider::class.java)
            val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            val drinksList = getSixDrinks(widgetData)
            allWidgetIds.forEach { widgetId ->
                val options = appWidgetManager.getAppWidgetOptions(widgetId)
                updateWidgetView(context, appWidgetManager, widgetId, drinksList, widgetData, options)
            }
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        val widgetData = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val drinksList = getSixDrinks(widgetData)
        updateWidgetView(context, appWidgetManager, appWidgetId, drinksList, widgetData, newOptions)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val drinksList = getSixDrinks(widgetData)

        appWidgetIds.forEach { widgetId ->
            val options = appWidgetManager.getAppWidgetOptions(widgetId)
            updateWidgetView(context, appWidgetManager, widgetId, drinksList, widgetData, options)
        }
    }

    private fun updateWidgetView(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int,
        drinksList: List<QuickDrinkItem>,
        widgetData: SharedPreferences,
        options: Bundle?
    ) {
        val minWidth = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0) ?: 0
        val minHeight = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0) ?: 0
        val theme = WidgetThemeHelper.resolve(widgetData)

        val views = RemoteViews(context.packageName, R.layout.widget_quick_log).apply {
            // Background card & top bar
            setInt(R.id.widget_container, "setBackgroundResource", theme.cardBgRes)
            setInt(R.id.widget_header_icon, "setColorFilter", theme.textMuted)
            setTextColor(R.id.widget_title, theme.textMuted)
            setTextColor(R.id.widget_quick_subtitle, theme.textMuted)

            setInt(R.id.widget_custom_log_btn, "setBackgroundResource", theme.btnBgRes)
            setTextColor(R.id.widget_custom_log_btn, theme.brandAccent)

            // Background tap opens App Today
            val openAppIntent = Intent(context, MainActivity::class.java).apply {
                action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
                data = Uri.parse("coffeeaholic://today")
            }
            val openAppPendingIntent = PendingIntent.getActivity(
                context,
                99,
                openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            setOnClickPendingIntent(R.id.widget_container, openAppPendingIntent)

            // Header adaptations for compact sizes
            val isNarrow = minWidth in 1..180
            val isUltraNarrow = minWidth in 1..150

            setViewVisibility(R.id.widget_custom_log_btn, if (isNarrow) View.GONE else View.VISIBLE)
            setViewVisibility(R.id.widget_quick_subtitle, if (isNarrow) View.GONE else View.VISIBLE)

            // "+ Custom" tap opens custom log sheet
            val customLogIntent = Intent(context, MainActivity::class.java).apply {
                action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
                data = Uri.parse("coffeeaholic://log")
            }
            val customLogPendingIntent = PendingIntent.getActivity(
                context,
                98,
                customLogIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            setOnClickPendingIntent(R.id.widget_custom_log_btn, customLogPendingIntent)

            // Responsive Height: Show Row 2 when tall enough (>= 100dp)
            val showRow2 = minHeight >= 100
            setViewVisibility(R.id.widget_drinks_row_2, if (showRow2) View.VISIBLE else View.GONE)

            // 6 Drink slots (Row 1: 0,1,2; Row 2: 3,4,5)
            val drinkSlots = listOf(
                Triple(R.id.widget_drink_btn_0, R.id.widget_drink_name_0, Pair(R.id.widget_drink_mg_0, R.id.widget_drink_icon_0)),
                Triple(R.id.widget_drink_btn_1, R.id.widget_drink_name_1, Pair(R.id.widget_drink_mg_1, R.id.widget_drink_icon_1)),
                Triple(R.id.widget_drink_btn_2, R.id.widget_drink_name_2, Pair(R.id.widget_drink_mg_2, R.id.widget_drink_icon_2)),
                Triple(R.id.widget_drink_btn_3, R.id.widget_drink_name_3, Pair(R.id.widget_drink_mg_3, R.id.widget_drink_icon_3)),
                Triple(R.id.widget_drink_btn_4, R.id.widget_drink_name_4, Pair(R.id.widget_drink_mg_4, R.id.widget_drink_icon_4)),
                Triple(R.id.widget_drink_btn_5, R.id.widget_drink_name_5, Pair(R.id.widget_drink_mg_5, R.id.widget_drink_icon_5))
            )

            drinksList.forEachIndexed { index, drink ->
                val (btnId, nameId, mgAndIcon) = drinkSlots[index]
                val (mgId, iconId) = mgAndIcon

                // Only hide 3rd column in extremely narrow (< 150dp) 1-cell widgets
                if (isUltraNarrow && (index == 2 || index == 5)) {
                    setViewVisibility(btnId, View.GONE)
                } else {
                    setViewVisibility(btnId, View.VISIBLE)
                }

                // Always show mg for complete, balanced buttons
                setViewVisibility(mgId, View.VISIBLE)

                setTextViewText(nameId, drink.name)
                setTextViewText(mgId, "${drink.caffeineMg} mg")
                setImageViewResource(iconId, drink.iconRes)

                // Theme button & colors
                setInt(btnId, "setBackgroundResource", theme.btnBgRes)
                setTextColor(nameId, theme.textPrimary)
                setTextColor(mgId, theme.brandAccent)
                setInt(iconId, "setColorFilter", theme.brandAccent)

                // BROADCAST INTENT: Logs drink directly without opening app!
                val logBroadcastIntent = Intent(context, QuickLogWidgetProvider::class.java).apply {
                    action = ACTION_LOG_DRINK
                    data = Uri.parse("coffeeaholic://quicklog?id=${drink.id}")
                }
                val logPendingIntent = PendingIntent.getBroadcast(
                    context,
                    100 + index,
                    logBroadcastIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(btnId, logPendingIntent)
            }
        }

        appWidgetManager.updateAppWidget(widgetId, views)
    }

    private fun getSixDrinks(widgetData: SharedPreferences): List<QuickDrinkItem> {
        val count = widgetData.getSafeInt("quick_drink_count", 0)
        val userDrinks = mutableListOf<QuickDrinkItem>()

        for (i in 0 until count) {
            val id = widgetData.getString("quick_drink_${i}_id", null) ?: continue
            val name = widgetData.getString("quick_drink_${i}_name", "Coffee") ?: "Coffee"
            val mg = widgetData.getSafeInt("quick_drink_${i}_mg", 75)
            val iconRes = resolveIcon(id)
            userDrinks.add(QuickDrinkItem(id, name, mg, 250, id, iconRes))
        }

        val result = mutableListOf<QuickDrinkItem>()
        result.addAll(userDrinks)

        if (result.size < 6) {
            for (catalog in catalogDrinks) {
                if (result.none { it.id == catalog.id }) {
                    result.add(catalog)
                }
                if (result.size >= 6) break
            }
        }

        return result.take(6)
    }

    private fun findDrink(drinkId: String, widgetData: SharedPreferences): QuickDrinkItem {
        val drinks = getSixDrinks(widgetData)
        return drinks.find { it.id == drinkId } ?: catalogDrinks.find { it.id == drinkId } ?: QuickDrinkItem(
            drinkId,
            "Coffee",
            80,
            250,
            "espresso",
            R.drawable.ic_drink_mug
        )
    }

    private fun getDriftDatabaseFile(context: Context): File? {
        val dataDir = context.filesDir.parentFile
        val candidatePaths = listOf(
            File(dataDir, "app_flutter/coffeeaholic.sqlite"),
            File(context.filesDir, "coffeeaholic.sqlite"),
            File(dataDir, "databases/coffeeaholic.sqlite"),
            File(dataDir, "databases/coffeeaholic"),
            context.getDatabasePath("coffeeaholic.sqlite"),
            context.getDatabasePath("coffeeaholic")
        )
        for (candidate in candidatePaths) {
            if (candidate.exists()) {
                return candidate
            }
        }
        if (dataDir != null && dataDir.exists()) {
            try {
                val found = dataDir.walkTopDown().maxDepth(3).firstOrNull { file ->
                    file.isFile && file.name.startsWith("coffeeaholic") &&
                    !file.name.endsWith("-journal") && !file.name.endsWith("-wal") && !file.name.endsWith("-shm")
                }
                if (found != null) return found
            } catch (_: Exception) {}
        }
        return null
    }

    private fun insertDrinkToDatabase(context: Context, drink: QuickDrinkItem) {
        try {
            val dbFile = getDriftDatabaseFile(context)
            if (dbFile != null && dbFile.exists()) {
                val db = SQLiteDatabase.openDatabase(dbFile.absolutePath, null, SQLiteDatabase.OPEN_READWRITE)
                val values = ContentValues().apply {
                    put("name", drink.name)
                    put("caffeine_mg", drink.caffeineMg)
                    put("volume_ml", drink.volumeMl)
                    put("consumed_at_utc", System.currentTimeMillis() / 1000)
                    put("price_cents", 0)
                    put("temperature", "Hot")
                    put("location", "home")
                    put("cup_style", "artwork:${drink.artworkId}")
                }
                db.insert("drink_entries", null, values)
                db.close()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun sendLoggedNotification(context: Context, drink: QuickDrinkItem, todayTotalMg: Int) {
        try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager ?: return
            val channelId = "coffeeaholic_quicklog"

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    channelId,
                    "Quick Log Confirmations",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Instant confirmation when logging drinks from home screen widget"
                    enableVibration(true)
                }
                notificationManager.createNotificationChannel(channel)
            }

            val openAppIntent = Intent(context, MainActivity::class.java).apply {
                action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
                data = Uri.parse("coffeeaholic://today")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                2001,
                openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Notification.Builder(context, channelId)
            } else {
                @Suppress("DEPRECATION")
                Notification.Builder(context)
            }

            val notification = builder
                .setSmallIcon(R.drawable.ic_widget_coffee)
                .setContentTitle("☕ ${drink.name} Logged")
                .setContentText("+${drink.caffeineMg} mg caffeine • Today: $todayTotalMg mg")
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .build()

            notificationManager.notify(7001, notification)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
