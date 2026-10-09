import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/app_dropdown.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/drink_artwork.dart';
import '../onboarding/models/favorite_drink.dart';
import '../tracking/models/tracking_models.dart';
import '../tracking/providers/tracking_providers.dart';
import 'providers/custom_locations_provider.dart';
import 'widgets/manage_locations_dialog.dart';

class LogDrinkSheet extends ConsumerStatefulWidget {
  const LogDrinkSheet({super.key, this.initialRecord});
  final DrinkRecord? initialRecord;

  @override
  ConsumerState<LogDrinkSheet> createState() => _LogDrinkSheetState();
}

class _LogDrinkSheetState extends ConsumerState<LogDrinkSheet> {
  late final TextEditingController name;
  late final TextEditingController caffeine;
  late final TextEditingController volume;
  late final TextEditingController cafeName;
  late final TextEditingController price;
  late final TextEditingController note;

  String temperature = 'Hot';
  String location = 'home';
  String cupStyle = 'Ceramic Mug (Default)';
  String selectedDrinkId = 'latte';
  TimeOfDay time = TimeOfDay.now();
  bool saving = false;
  String? error;
  String? photoPath;

  @override
  void initState() {
    super.initState();
    final record = widget.initialRecord;
    if (record != null) {
      photoPath = record.photoPath;
      name = TextEditingController(text: record.name);
      caffeine = TextEditingController(text: '${record.caffeineMg}');
      volume = TextEditingController(text: '${record.volumeMl}');
      price = TextEditingController(
        text: (record.priceCents / 100).toStringAsFixed(2),
      );
      note = TextEditingController(text: record.note ?? '');
      if (record.location == 'home') {
        location = 'home';
        cafeName = TextEditingController(text: '');
      } else if (record.location == 'cafe') {
        location = 'cafe';
        cafeName = TextEditingController(text: record.cafeName ?? '');
      } else if (record.location == 'work') {
        location = 'work';
        cafeName = TextEditingController(text: record.cafeName ?? '');
      } else {
        location = 'custom';
        cafeName = TextEditingController(
          text:
              record.cafeName ??
              (record.location != 'custom' ? record.location : ''),
        );
      }
      final knownCupStyles = const [
        'Ceramic Mug (Default)',
        'Paper Takeaway Cup',
        'Glass Cup',
        'Thermos Tumbler',
      ];
      if (record.cupStyle.startsWith('artwork:')) {
        final raw = record.cupStyle.substring('artwork:'.length);
        final parts = raw.split('|cup:');
        selectedDrinkId = parts[0];
        if (parts.length > 1 && knownCupStyles.contains(parts[1])) {
          cupStyle = parts[1];
        } else {
          cupStyle = 'Ceramic Mug (Default)';
        }
      } else {
        cupStyle = knownCupStyles.contains(record.cupStyle)
            ? record.cupStyle
            : 'Ceramic Mug (Default)';
        selectedDrinkId =
            FavoriteDrink.fullLogCatalog
                .where(
                  (drink) =>
                      drink.name.toLowerCase() == record.name.toLowerCase(),
                )
                .map((drink) => drink.id)
                .firstOrNull ??
            'other';
      }
      time = TimeOfDay.fromDateTime(record.localTime);
    } else {
      name = TextEditingController(text: 'Latte');
      caffeine = TextEditingController(text: '120');
      volume = TextEditingController(text: '300');
      cafeName = TextEditingController();
      price = TextEditingController(text: '3.50');
      note = TextEditingController();
      time = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    for (final controller in [name, caffeine, volume, cafeName, price, note]) {
      controller.dispose();
    }
    super.dispose();
  }

  InputDecoration _inputDeco(
    BuildContext context, {
    String? labelText,
    String? hintText,
  }) {
    final palette = AppTheme.paletteOf(context);
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: palette.textSubtle, fontSize: 13),
      hintText: hintText,
      hintStyle: TextStyle(color: palette.textSubtle, fontSize: 13),
      filled: true,
      fillColor: palette.stone900,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.stone800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.brand500, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.stateDanger),
      ),
    );
  }

  List<AppDropdownItem<String>> _buildLocationItems(List<String> customPlaces) {
    return [
      const AppDropdownItem(
        value: 'home',
        label: 'Home Brew (\$0.50)',
        icon: Icons.home_outlined,
      ),
      const AppDropdownItem(
        value: 'cafe',
        label: 'At Cafe',
        icon: Icons.local_cafe_outlined,
      ),
      const AppDropdownItem(
        value: 'work',
        label: 'Work / Office',
        icon: Icons.business_outlined,
      ),
      for (final place in customPlaces)
        if (place != 'home' && place != 'cafe' && place != 'work')
          AppDropdownItem(
            value: place,
            label: place,
            icon: Icons.place_outlined,
          ),
      if (location != 'home' &&
          location != 'cafe' &&
          location != 'work' &&
          !customPlaces.contains(location))
        AppDropdownItem(
          value: location,
          label: location,
          icon: Icons.place_outlined,
        ),
      const AppDropdownItem(
        value: '__manage_custom__',
        label: 'Manage Locations...',
        icon: Icons.tune_rounded,
      ),
    ];
  }

  void _showManageLocationsDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => ManageLocationsDialog(
        currentLocation: location,
        onLocationSelected: (newLoc) {
          setState(() {
            location = newLoc;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final customLocations =
        ref.watch(customLocationsProvider).valueOrNull ?? [];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheetTop),
          ),
          border: Border(top: BorderSide(color: palette.stone700, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            shrinkWrap: true,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialRecord == null ? 'Log Drink' : 'Edit Drink',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: palette.textMuted, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // DRINK Section
              _fieldLabel(context, 'DRINK'),
              const SizedBox(height: 8),
              SizedBox(
                height: 98,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final drink in FavoriteDrink.fullLogCatalog)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () => setState(() {
                            selectedDrinkId = drink.id;
                            name.text = drink.id == 'other'
                                ? 'Custom drink'
                                : drink.name;
                            caffeine.text = '${drink.caffeineMg}';
                            volume.text = '${drink.volumeMl}';
                          }),
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: 68,
                            child: Column(
                              children: [
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: palette.surfaceRaised,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: selectedDrinkId == drink.id
                                          ? palette.brand500
                                          : (drink.id == 'other'
                                                ? palette.stone700
                                                : Colors.transparent),
                                      width: selectedDrinkId == drink.id
                                          ? 2
                                          : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: DrinkArtwork(id: drink.id, size: 42),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  drink.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedDrinkId == drink.id
                                        ? palette.textPrimary
                                        : palette.textSecondary,
                                    fontSize: 11,
                                    fontWeight: selectedDrinkId == drink.id
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // DRINK NAME & CAFFEINE (MG)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, 'DRINK NAME'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: name,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 14,
                          ),
                          decoration: _inputDeco(
                            context,
                            labelText: 'Drink Name',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, 'CAFFEINE (MG)'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: caffeine,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 14,
                          ),
                          decoration: _inputDeco(
                            context,
                            labelText: 'Caffeine (mg)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // VOLUME (ML) & TEMPERATURE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, 'VOLUME (ML)'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: volume,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 14,
                          ),
                          decoration: _inputDeco(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, 'TEMPERATURE'),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: _toggleOptionButton(
                                context,
                                label: 'Hot',
                                icon: Icons.local_fire_department,
                                selected: temperature == 'Hot',
                                onTap: () =>
                                    setState(() => temperature = 'Hot'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _toggleOptionButton(
                                context,
                                label: 'Iced',
                                icon: Icons.ac_unit,
                                selected: temperature == 'Iced',
                                onTap: () =>
                                    setState(() => temperature = 'Iced'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // LOCATION & SPENDING
              _fieldLabel(context, 'LOCATION & SPENDING'),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: AppDropdown<String>(
                      value: location,
                      items: _buildLocationItems(customLocations),
                      onChanged: (val) {
                        if (val == '__manage_custom__') {
                          _showManageLocationsDialog();
                        } else {
                          setState(() {
                            location = val;
                          });
                        }
                      },
                    ),
                  ),
                  if (location != 'home') ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 95,
                      child: TextField(
                        controller: price,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 13,
                        ),
                        decoration: _inputDeco(context, hintText: 'Price (\$)'),
                      ),
                    ),
                  ],
                ],
              ),
              if (location == 'cafe') ...[
                const SizedBox(height: 8),
                TextField(
                  controller: cafeName,
                  style: TextStyle(color: palette.textPrimary, fontSize: 13),
                  decoration: _inputDeco(
                    context,
                    hintText: 'Cafe Name (e.g. Blue Bottle)',
                  ),
                ),
              ],
              const SizedBox(height: 14),

              // CUP STYLE & TIME
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, 'CUP STYLE'),
                        const SizedBox(height: 6),
                        AppDropdown<String>(
                          value: cupStyle,
                          items: [
                            const AppDropdownItem(
                              value: 'Ceramic Mug (Default)',
                              label: 'Ceramic Mug (Default)',
                              icon: Icons.coffee_rounded,
                            ),
                            const AppDropdownItem(
                              value: 'Paper Takeaway Cup',
                              label: 'Paper Takeaway Cup',
                              icon: Icons.takeout_dining_rounded,
                            ),
                            const AppDropdownItem(
                              value: 'Glass Cup',
                              label: 'Glass Cup',
                              icon: Icons.local_bar_rounded,
                            ),
                            const AppDropdownItem(
                              value: 'Thermos Tumbler',
                              label: 'Thermos Tumbler',
                              icon: Icons.water_drop_outlined,
                            ),
                            if (!const [
                              'Ceramic Mug (Default)',
                              'Paper Takeaway Cup',
                              'Glass Cup',
                              'Thermos Tumbler',
                            ].contains(cupStyle))
                              AppDropdownItem(
                                value: cupStyle,
                                label: cupStyle,
                                icon: Icons.coffee_rounded,
                              ),
                          ],
                          onChanged: (value) =>
                              setState(() => cupStyle = value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, 'TIME'),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final selected = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );
                            if (selected != null) {
                              setState(() => time = selected);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: palette.stone900,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: palette.stone800),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  time.format(context),
                                  style: TextStyle(
                                    color: palette.textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: palette.textSubtle,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // NOTE & PHOTO (OPTIONAL)
              _fieldLabel(context, 'NOTE & PHOTO (OPTIONAL)'),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: note,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: _inputDeco(
                        context,
                        hintText: 'E.g. with oat milk & honey',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (photoPath != null && File(photoPath!).existsSync()) ...[
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: _pickPhoto,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: palette.surfaceRaised,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: palette.brand500),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(
                              File(photoPath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: InkWell(
                            onTap: () => setState(() => photoPath = null),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: palette.stateDanger,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    InkWell(
                      onTap: _pickPhoto,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: palette.stone800,
                          border: Border.all(color: palette.stone800),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 16,
                              color: palette.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Photo',
                              style: TextStyle(
                                color: palette.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    error!,
                    style: TextStyle(color: palette.stateDanger, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),

              // Big Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.brand500,
                    disabledBackgroundColor: palette.brand500.withValues(
                      alpha: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    saving
                        ? 'Saving...'
                        : (widget.initialRecord == null
                              ? 'Log Entry'
                              : 'Save Changes'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppTheme.paletteOf(context).textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _toggleOptionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final palette = AppTheme.paletteOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected
              ? palette.brand500.withValues(alpha: 0.15)
              : palette.stone800,
          border: Border.all(
            color: selected ? palette.brand500 : palette.stone800,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? palette.brand300 : palette.textSubtle,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? palette.brand300 : palette.textSecondary,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final mg = int.tryParse(caffeine.text.trim());
    final ml = int.tryParse(volume.text.trim());
    final dollars = location == 'home'
        ? 0.5
        : double.tryParse(price.text.trim()) ?? 0;
    if (name.text.trim().isEmpty ||
        mg == null ||
        mg < 0 ||
        ml == null ||
        ml <= 0 ||
        dollars < 0) {
      setState(() => error = 'Enter a drink name, valid caffeine, and volume.');
      return;
    }
    final now = widget.initialRecord?.localTime ?? DateTime.now();
    final local = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    setState(() {
      saving = true;
      error = null;
    });
    final String savedLocation;
    final String? savedPlaceName;
    if (location == 'home') {
      savedLocation = 'home';
      savedPlaceName = null;
    } else if (location == 'cafe') {
      savedLocation = 'cafe';
      savedPlaceName = cafeName.text.trim().isEmpty
          ? null
          : cafeName.text.trim();
    } else if (location == 'work') {
      savedLocation = 'work';
      savedPlaceName = cafeName.text.trim().isEmpty
          ? null
          : cafeName.text.trim();
    } else {
      final customName = cafeName.text.trim();
      savedLocation = customName.isNotEmpty ? customName : 'custom';
      savedPlaceName = customName.isNotEmpty ? customName : null;
    }

    try {
      final draft = DrinkDraft(
        name: name.text.trim(),
        caffeineMg: mg,
        volumeMl: ml,
        consumedAtUtc: local.toUtc(),
        priceCents: (dollars * 100).round(),
        temperature: temperature,
        location: savedLocation,
        cupStyle: selectedDrinkId != 'other'
            ? 'artwork:$selectedDrinkId|cup:$cupStyle'
            : cupStyle,
        cafeName: savedPlaceName,
        note: note.text.trim().isEmpty ? null : note.text.trim(),
        photoPath: photoPath,
      );
      final controller = ref.read(trackingControllerProvider.notifier);
      if (widget.initialRecord == null) {
        await controller.addDrink(draft);
      } else {
        await controller.updateDrink(widget.initialRecord!.id, draft);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = 'Could not save drink. Try again.';
        });
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.paletteOf(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.card),
        ),
      ),
      builder: (ctx) {
        final palette = AppTheme.paletteOf(ctx);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_rounded,
                    color: palette.brand400,
                  ),
                  title: Text(
                    'Take Photo',
                    style: TextStyle(color: palette.textPrimary),
                  ),
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_rounded,
                    color: palette.brand400,
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: TextStyle(color: palette.textPrimary),
                  ),
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
                if (photoPath != null)
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline_rounded,
                      color: palette.stateDanger,
                    ),
                    title: Text(
                      'Remove Photo',
                      style: TextStyle(color: palette.stateDanger),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => photoPath = null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      try {
        final picked = await picker.pickImage(
          source: source,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );
        if (picked != null) {
          setState(() => photoPath = picked.path);
        }
      } catch (e) {
        debugPrint('Image picker error: $e');
        if (mounted) {
          final isCamera = source == ImageSource.camera;
          final msg = isCamera
              ? 'Camera unavailable. Try choosing from gallery.'
              : 'Could not access photo library. Check device permissions.';
          AppToast.show(context, msg, isError: true);
        }
      }
    }
  }
}
