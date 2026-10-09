import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.onDelete,
  });

  final T value;
  final String label;
  final IconData? icon;
  final VoidCallback? onDelete;
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.height = 44,
  });

  final T value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final selectedItem = items.firstWhere(
      (item) => item.value == value,
      orElse: () => items.first,
    );

    final activeColor = palette.isDark ? palette.brand300 : palette.brand600;

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: palette.surfaceRaised,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: palette.stone700),
          ),
        ),
      ),
      child: PopupMenuButton<T>(
        position: PopupMenuPosition.under,
        offset: const Offset(0, 4),
        color: palette.surfaceRaised,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.stone700),
        ),
        onSelected: onChanged,
        itemBuilder: (context) {
          final menuEntries = <PopupMenuEntry<T>>[];
          for (var i = 0; i < items.length; i++) {
            final item = items[i];
            final isSelected = item.value == value;

            menuEntries.add(
              PopupMenuItem<T>(
                value: item.value,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 16,
                        color: isSelected ? activeColor : palette.textMuted,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? activeColor : palette.textPrimary,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected) ...[
                      Icon(Icons.check_rounded, size: 16, color: activeColor),
                      if (item.onDelete != null) const SizedBox(width: 6),
                    ],
                    if (item.onDelete != null)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                          item.onDelete!();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 17,
                            color: palette.stateDanger,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );

            if (i < items.length - 1) {
              menuEntries.add(
                PopupMenuItem<T>(
                  enabled: false,
                  height: 1,
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: palette.stone700,
                  ),
                ),
              );
            }
          }
          return menuEntries;
        },
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: palette.stone900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.stone800),
          ),
          child: Row(
            children: [
              if (selectedItem.icon != null) ...[
                Icon(
                  selectedItem.icon,
                  size: 16,
                  color: palette.isDark ? palette.brand300 : palette.brand600,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  selectedItem.label,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: palette.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
