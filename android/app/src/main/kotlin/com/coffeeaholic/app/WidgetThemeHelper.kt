package com.coffeeaholic.app

import android.content.SharedPreferences
import android.graphics.Color

fun SharedPreferences.getSafeInt(key: String, fallback: Int = 0): Int {
    val raw = try {
        this.all[key]
    } catch (_: Exception) {
        null
    } ?: return fallback

    return when (raw) {
        is Number -> raw.toInt()
        is String -> raw.toIntOrNull() ?: fallback
        else -> fallback
    }
}

object WidgetThemeHelper {

    data class ThemeColors(
        val preset: String,
        val cardBgRes: Int,
        val btnBgRes: Int,
        val textPrimary: Int,
        val textMuted: Int,
        val brandAccent: Int
    )

    fun resolve(prefs: SharedPreferences): ThemeColors {
        val preset = prefs.getString("theme_preset", "coffee") ?: "coffee"

        val cardBgRes = when (preset) {
            "ocean" -> R.drawable.widget_card_bg_ocean
            "forest" -> R.drawable.widget_card_bg_forest
            "amber" -> R.drawable.widget_card_bg_amber
            "coffeeLight" -> R.drawable.widget_card_bg_coffee_light
            "oceanLight" -> R.drawable.widget_card_bg_ocean_light
            "forestLight" -> R.drawable.widget_card_bg_forest_light
            "amberLight" -> R.drawable.widget_card_bg_amber_light
            else -> R.drawable.widget_card_bg_coffee
        }

        val btnBgRes = when (preset) {
            "ocean" -> R.drawable.widget_btn_bg_ocean
            "forest" -> R.drawable.widget_btn_bg_forest
            "amber" -> R.drawable.widget_btn_bg_amber
            "coffeeLight" -> R.drawable.widget_btn_bg_coffee_light
            "oceanLight" -> R.drawable.widget_btn_bg_ocean_light
            "forestLight" -> R.drawable.widget_btn_bg_forest_light
            "amberLight" -> R.drawable.widget_btn_bg_amber_light
            else -> R.drawable.widget_btn_bg_coffee
        }

        val isLight = preset.contains("Light")
        val fallbackPrimary = if (isLight) Color.parseColor("#1E1510") else Color.WHITE
        val fallbackMuted = if (isLight) Color.parseColor("#664F42") else Color.parseColor("#AFA399")
        val fallbackAccent = if (isLight) Color.parseColor("#8A4620") else Color.parseColor("#E2C4A8")

        val textPrimary = prefs.getSafeInt("theme_text_primary", fallbackPrimary)
        val textMuted = prefs.getSafeInt("theme_text_muted", fallbackMuted)
        val brandAccent = prefs.getSafeInt("theme_brand_accent", fallbackAccent)

        return ThemeColors(preset, cardBgRes, btnBgRes, textPrimary, textMuted, brandAccent)
    }
}
