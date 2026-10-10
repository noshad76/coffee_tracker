package com.coffeeaholic.app

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import kotlin.math.ln
import kotlin.math.pow
import kotlin.math.roundToInt

class MetabolismWidgetProvider : HomeWidgetProvider() {

    data class DecayResult(
        val activeMg: Int,
        val statusText: String,
        val hoursToClear: String,
        val safeTime: String
    )

    companion object {
        const val PREFS_NAME = "HomeWidgetPreferences"
        const val ACTION_REFRESH_METABOLISM = "com.coffeeaholic.app.ACTION_REFRESH_METABOLISM"
        const val REFRESH_BTN_REQUEST_CODE = 1001
        const val ALARM_REQUEST_CODE = 2002

        fun calculateDecay(drinksData: String?, nowMs: Long = System.currentTimeMillis()): DecayResult {
            if (drinksData.isNullOrBlank()) {
                return DecayResult(0, "Sleep-Safe Now", "0", "Safe Now")
            }

            var totalActive = 0.0
            val entries = drinksData.split(",").mapNotNull { item ->
                val parts = item.split(":")
                if (parts.size == 2) {
                    val time = parts[0].toLongOrNull()
                    val mg = parts[1].toDoubleOrNull()
                    if (time != null && mg != null) Pair(time, mg) else null
                } else null
            }

            for ((time, mg) in entries) {
                val elapsedHours = (nowMs - time) / (1000.0 * 3600.0)
                if (elapsedHours >= 0) {
                    totalActive += mg * 0.5.pow(elapsedHours / 6.0)
                }
            }

            val activeMg = totalActive.roundToInt()
            if (activeMg <= 50) {
                return DecayResult(activeMg, "Sleep-Safe Now", "0", "Safe Now")
            }

            val hoursRemaining = 6.0 * (ln(totalActive / 50.0) / ln(2.0))
            val targetTimeMs = nowMs + (hoursRemaining * 3600.0 * 1000.0).toLong()

            val nowDate = Calendar.getInstance().apply { timeInMillis = nowMs }
            val targetDate = Calendar.getInstance().apply { timeInMillis = targetTimeMs }
            val isSameDay = nowDate.get(Calendar.DAY_OF_YEAR) == targetDate.get(Calendar.DAY_OF_YEAR) &&
                            nowDate.get(Calendar.YEAR) == targetDate.get(Calendar.YEAR)

            val timeFormat = SimpleDateFormat("h:mm a", Locale.getDefault())
            val formattedTime = timeFormat.format(Date(targetTimeMs))

            val statusText = when {
                isSameDay -> "Safe by $formattedTime"
                hoursRemaining < 24.0 -> "Safe Tmrw $formattedTime"
                else -> "Safe in ~${hoursRemaining.roundToInt()}h"
            }

            val hoursToClear = if (hoursRemaining < 1.0) {
                "< 1"
            } else if (hoursRemaining % 1.0 == 0.0) {
                hoursRemaining.toInt().toString()
            } else {
                String.format(Locale.US, "%.1f", hoursRemaining)
            }

            return DecayResult(activeMg, statusText, hoursToClear, formattedTime)
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        startPeriodicUpdate(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        stopPeriodicUpdate(context)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH_METABOLISM) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, MetabolismWidgetProvider::class.java)
            val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            val widgetData = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            val drinksData = widgetData.getString("metabolism_drinks_data", null)
            val decay = calculateDecay(drinksData)

            val timeFormat = SimpleDateFormat("h:mm a", Locale.getDefault())
            val updatedTime = timeFormat.format(Date())
            widgetData.edit()
                .putInt("metabolism_active_mg", decay.activeMg)
                .putString("metabolism_status_text", decay.statusText)
                .putString("metabolism_hours_to_clear", decay.hoursToClear)
                .putString("metabolism_last_updated", updatedTime)
                .apply()

            allWidgetIds.forEach { widgetId ->
                val options = appWidgetManager.getAppWidgetOptions(widgetId)
                val views = buildRemoteViews(context, widgetData, decay, updatedTime, options)
                appWidgetManager.updateAppWidget(widgetId, views)
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
        val drinksData = widgetData.getString("metabolism_drinks_data", null)
        val decay = calculateDecay(drinksData)
        val timeFormat = SimpleDateFormat("h:mm a", Locale.getDefault())
        val updatedTime = widgetData.getString("metabolism_last_updated", null) ?: timeFormat.format(Date())

        val views = buildRemoteViews(context, widgetData, decay, updatedTime, newOptions)
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        startPeriodicUpdate(context)

        val drinksData = widgetData.getString("metabolism_drinks_data", null)
        val decay = calculateDecay(drinksData)
        val timeFormat = SimpleDateFormat("h:mm a", Locale.getDefault())
        val updatedTime = widgetData.getString("metabolism_last_updated", null) ?: timeFormat.format(Date())

        appWidgetIds.forEach { widgetId ->
            val options = appWidgetManager.getAppWidgetOptions(widgetId)
            val views = buildRemoteViews(context, widgetData, decay, updatedTime, options)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun buildRemoteViews(
        context: Context,
        widgetData: SharedPreferences,
        decay: DecayResult,
        updatedTime: String,
        options: Bundle?
    ): RemoteViews {
        val minWidth = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0) ?: 0
        val minHeight = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0) ?: 0
        val isTall = minHeight >= 105 && minWidth >= 170
        val isUltraNarrow = minWidth in 1..180
        val theme = WidgetThemeHelper.resolve(widgetData)
        val activeMg = decay.activeMg
        val isSleepSafe = activeMg <= 50

        return RemoteViews(context.packageName, R.layout.widget_metabolism).apply {
            val launchIntent = Intent(context, MainActivity::class.java).apply {
                action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
                data = Uri.parse("coffeeaholic://metabolism")
            }
            val pendingLaunch = PendingIntent.getActivity(
                context,
                90,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            setOnClickPendingIntent(R.id.widget_container, pendingLaunch)

            // Theming backgrounds and text colors
            setInt(R.id.widget_container, "setBackgroundResource", theme.cardBgRes)
            setInt(R.id.widget_header_icon, "setColorFilter", theme.textMuted)
            setTextColor(R.id.widget_title, theme.textMuted)
            setTextColor(R.id.widget_updated_text, theme.textMuted)

            setInt(R.id.widget_refresh_btn, "setBackgroundResource", theme.btnBgRes)
            setInt(R.id.widget_refresh_btn, "setColorFilter", theme.textMuted)

            setTextColor(R.id.widget_active_mg, theme.textPrimary)
            setTextColor(R.id.widget_active_unit, theme.textMuted)

            // Status pill text - in narrow screens, use concise representation
            val displayStatus = if (minWidth in 1..210 && !isSleepSafe && !decay.statusText.contains("Safe by")) {
                "Safe ~${decay.hoursToClear}h"
            } else {
                decay.statusText
            }
            setTextViewText(R.id.widget_status_text, displayStatus)

            if (isSleepSafe) {
                setInt(R.id.widget_status_text, "setBackgroundResource", R.drawable.widget_pill_green)
                setTextColor(R.id.widget_status_text, context.getColor(R.color.widget_status_green))
            } else if (displayStatus.contains("Tmrw") || displayStatus.contains("~") || displayStatus.contains("Tomorrow")) {
                setInt(R.id.widget_status_text, "setBackgroundResource", R.drawable.widget_pill_amber)
                setTextColor(R.id.widget_status_text, context.getColor(R.color.widget_status_amber))
            } else {
                setInt(R.id.widget_status_text, "setBackgroundResource", R.drawable.widget_pill_blue)
                setTextColor(R.id.widget_status_text, context.getColor(R.color.widget_status_blue))
            }

            setTextViewText(R.id.widget_active_mg, activeMg.toString())
            setTextViewText(R.id.widget_updated_text, updatedTime)

            val refreshIntent = Intent(context, MetabolismWidgetProvider::class.java).apply {
                action = ACTION_REFRESH_METABOLISM
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context,
                REFRESH_BTN_REQUEST_CODE,
                refreshIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            setOnClickPendingIntent(R.id.widget_refresh_btn, refreshPendingIntent)

            val halfLifeMg = (activeMg * 0.5).roundToInt()
            val todayTotal = widgetData.getSafeInt("today_total_mg", activeMg)
            val todayLimit = widgetData.getSafeInt("today_limit_mg", 400)

            if (isTall) {
                // === LARGE / TALL MODE: Rich full-height dashboard ===
                setViewVisibility(R.id.widget_metrics_box, View.GONE)
                setViewVisibility(R.id.widget_large_today_box, View.VISIBLE)
                setViewVisibility(R.id.widget_milestones_row, View.VISIBLE)
                setViewVisibility(R.id.widget_large_clearance_footnote, View.VISIBLE)
                setViewVisibility(R.id.widget_updated_text, View.VISIBLE)

                // Theme Today's Total box
                setInt(R.id.widget_large_today_box, "setBackgroundResource", theme.btnBgRes)
                setTextColor(R.id.widget_large_today_header, theme.textMuted)
                setTextColor(R.id.widget_large_today_total, theme.brandAccent)
                setTextColor(R.id.widget_large_today_limit, theme.textMuted)
                setTextViewText(R.id.widget_large_today_total, "$todayTotal mg")
                setTextViewText(R.id.widget_large_today_limit, "Limit: $todayLimit mg")

                // Theme & bind 3 Milestone cards
                setInt(R.id.widget_milestone_1_card, "setBackgroundResource", theme.btnBgRes)
                setTextColor(R.id.widget_milestone_1_title, theme.textMuted)
                setTextColor(R.id.widget_milestone_1_mg, theme.textPrimary)
                setTextColor(R.id.widget_milestone_1_sub, theme.textMuted)
                setTextViewText(R.id.widget_milestone_1_mg, "$activeMg mg")

                setInt(R.id.widget_milestone_2_card, "setBackgroundResource", theme.btnBgRes)
                setTextColor(R.id.widget_milestone_2_title, theme.textMuted)
                setTextColor(R.id.widget_milestone_2_mg, context.getColor(R.color.widget_status_amber))
                setTextColor(R.id.widget_milestone_2_sub, theme.textMuted)
                setTextViewText(R.id.widget_milestone_2_mg, "$halfLifeMg mg")

                setInt(R.id.widget_milestone_3_card, "setBackgroundResource", theme.btnBgRes)
                setTextColor(R.id.widget_milestone_3_title, theme.textMuted)
                setTextColor(R.id.widget_milestone_3_time, context.getColor(R.color.widget_status_green))
                setTextColor(R.id.widget_milestone_3_sub, theme.textMuted)
                setTextViewText(R.id.widget_milestone_3_time, decay.safeTime)

                // Footnote
                setTextColor(R.id.widget_large_clearance_footnote, theme.brandAccent)
                val footnoteText = if (isSleepSafe) {
                    "✓ Sleep ready • System clear"
                } else {
                    "Clears to safe sleep level in ~${decay.hoursToClear} hours"
                }
                setTextViewText(R.id.widget_large_clearance_footnote, footnoteText)
            } else {
                // === COMPACT / SHORT MODE ===
                setViewVisibility(R.id.widget_large_today_box, View.GONE)
                setViewVisibility(R.id.widget_milestones_row, View.GONE)
                setViewVisibility(R.id.widget_large_clearance_footnote, View.GONE)

                if (isUltraNarrow) {
                    setViewVisibility(R.id.widget_metrics_box, View.GONE)
                    setViewVisibility(R.id.widget_updated_text, View.GONE)
                } else {
                    setViewVisibility(R.id.widget_metrics_box, View.VISIBLE)
                    setViewVisibility(R.id.widget_updated_text, View.VISIBLE)

                    setInt(R.id.widget_metrics_box, "setBackgroundResource", theme.btnBgRes)
                    setTextColor(R.id.widget_in_6h_label, theme.textMuted)
                    setTextColor(R.id.widget_half_life_text, context.getColor(R.color.widget_status_amber))
                    setTextViewText(R.id.widget_half_life_text, "$halfLifeMg mg")

                    setTextColor(R.id.widget_today_label, theme.textMuted)
                    setTextColor(R.id.widget_today_total_text, theme.brandAccent)
                    setTextViewText(R.id.widget_today_total_text, "$todayTotal / $todayLimit mg")

                    setTextColor(R.id.widget_clears_label, theme.textMuted)
                    setTextColor(R.id.widget_clearance_notice, theme.textPrimary)
                    val clearDisplay = if (isSleepSafe) "0h" else "~${decay.hoursToClear}h"
                    setTextViewText(R.id.widget_clearance_notice, clearDisplay)
                }
            }
        }
    }

    private fun startPeriodicUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
        val intent = Intent(context, MetabolismWidgetProvider::class.java).apply {
            action = ACTION_REFRESH_METABOLISM
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val interval = 5 * 60 * 1000L
        val triggerAt = SystemClock.elapsedRealtime() + interval
        alarmManager.setInexactRepeating(
            AlarmManager.ELAPSED_REALTIME,
            triggerAt,
            interval,
            pendingIntent
        )
    }

    private fun stopPeriodicUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
        val intent = Intent(context, MetabolismWidgetProvider::class.java).apply {
            action = ACTION_REFRESH_METABOLISM
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
}
