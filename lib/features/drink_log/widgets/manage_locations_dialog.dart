import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../providers/custom_locations_provider.dart';

class ManageLocationsDialog extends ConsumerStatefulWidget {
  const ManageLocationsDialog({
    super.key,
    this.currentLocation,
    this.onLocationSelected,
  });

  final String? currentLocation;
  final ValueChanged<String>? onLocationSelected;

  @override
  ConsumerState<ManageLocationsDialog> createState() =>
      _ManageLocationsDialogState();
}

class _ManageLocationsDialogState extends ConsumerState<ManageLocationsDialog> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final newName = _textController.text.trim();
    if (newName.isNotEmpty) {
      ref.read(customLocationsProvider.notifier).addLocation(newName);
      widget.onLocationSelected?.call(newName);
      _textController.clear();
    }
  }

  void _handleRemove(String name) {
    ref.read(customLocationsProvider.notifier).removeLocation(name);
    if (widget.currentLocation == name) {
      widget.onLocationSelected?.call('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final places = ref.watch(customLocationsProvider).valueOrNull ?? [];
    final customPlaces = places
        .where((p) => p != 'home' && p != 'cafe' && p != 'work')
        .toList();

    return AlertDialog(
      backgroundColor: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: BorderSide(color: palette.stone700),
      ),
      title: Text(
        'Manage Locations',
        style: TextStyle(
          color: palette.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'New location (e.g. Gym)',
                      hintStyle: TextStyle(
                        color: palette.textSubtle,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: palette.stone900,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.stone800),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: palette.brand500,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _handleAdd(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.brand500,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.control),
                    ),
                  ),
                  onPressed: _handleAdd,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: customPlaces.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No custom locations saved yet.',
                        style: TextStyle(
                          color: palette.textMuted,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: customPlaces.length,
                      separatorBuilder: (_, index) =>
                          Divider(color: palette.stone800, height: 1),
                      itemBuilder: (c, idx) {
                        final place = customPlaces[idx];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.place_outlined,
                            color: palette.brand300,
                            size: 20,
                          ),
                          title: Text(
                            place,
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: palette.stateDanger,
                              size: 20,
                            ),
                            tooltip: 'Delete location',
                            onPressed: () => _handleRemove(place),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: palette.surfaceRaised,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Done',
            style: TextStyle(color: palette.textPrimary),
          ),
        ),
      ],
    );
  }
}
