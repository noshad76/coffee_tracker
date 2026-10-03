import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../../shared/widgets/drink_artwork.dart';
import '../../onboarding/models/favorite_drink.dart';
import '../../onboarding/providers/onboarding_providers.dart';

class EditQuickLogSheet extends ConsumerStatefulWidget {
  const EditQuickLogSheet({super.key, required this.initialFavoriteIds});

  final List<String> initialFavoriteIds;

  static Future<void> show(BuildContext context, List<String> currentIds) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditQuickLogSheet(initialFavoriteIds: currentIds),
    );
  }

  @override
  ConsumerState<EditQuickLogSheet> createState() => _EditQuickLogSheetState();
}

class _EditQuickLogSheetState extends ConsumerState<EditQuickLogSheet> {
  late List<String> _selectedIds;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = List<String>.from(widget.initialFavoriteIds);
  }

  void _removeDrink(String id) {
    setState(() {
      _selectedIds.remove(id);
    });
  }

  void _addDrink(String id) {
    if (_selectedIds.contains(id)) return;
    if (_selectedIds.length >= 10) {
      AppToast.show(
        context,
        'Maximum 10 quick log drinks allowed',
        isError: true,
      );
      return;
    }
    setState(() {
      _selectedIds.add(id);
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final candidateList = [
        ...widget.initialFavoriteIds,
        'espresso',
        'americano',
        'latte',
        'cappuccino',
      ];
      final fallback3 = <String>[];
      for (final id in candidateList) {
        if (id.isNotEmpty && !fallback3.contains(id)) {
          fallback3.add(id);
          if (fallback3.length == 3) break;
        }
      }
      final toSave = _selectedIds.isEmpty ? fallback3 : _selectedIds;

      await ref
          .read(onboardingControllerProvider.notifier)
          .saveFavorites(toSave);
      if (mounted) {
        Navigator.of(context).pop();
        AppToast.show(
          context,
          _selectedIds.isEmpty
              ? 'Restored your 3 onboarding shortcuts'
              : 'Quick Log updated!',
          icon: Icons.check_circle_rounded,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        AppToast.show(context, 'Could not save quick log.', isError: true);
      }
    }
  }

  void _showAddCustomDrinkDialog() {
    final nameController = TextEditingController();
    final caffeineController = TextEditingController(text: '95');
    final volumeController = TextEditingController(text: '250');
    String selectedArtwork = 'mug';
    String? nameError;

    final artworkOptions = [
      'mug',
      'espresso',
      'cappuccino',
      'latte',
      'icedlatte',
      'coldbrew',
      'blackcoffee',
      'energy',
      'tea',
      'matcha',
      'can',
      'glass',
      'other',
    ];

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          final palette = AppTheme.paletteOf(dialogCtx);
          return AlertDialog(
            backgroundColor: palette.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.largeCard),
              side: BorderSide(color: palette.stone800),
            ),
            title: Text(
              'Add Custom Drink',
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NAME',
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    onChanged: (_) {
                      if (nameError != null) {
                        setDialogState(() => nameError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'e.g. Double Cortado',
                      errorText: nameError,
                      hintStyle: TextStyle(color: palette.textSubtle),
                      filled: true,
                      fillColor: palette.surfaceRaised,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.control),
                        borderSide: BorderSide(color: palette.stone800),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.control),
                        borderSide: BorderSide(color: palette.stone800),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CAFFEINE (MG)',
                              style: TextStyle(
                                color: palette.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: caffeineController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '95',
                                filled: true,
                                fillColor: palette.surfaceRaised,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
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
                            Text(
                              'VOLUME (ML)',
                              style: TextStyle(
                                color: palette.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: volumeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '250',
                                filled: true,
                                fillColor: palette.surfaceRaised,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'ICON ARTWORK',
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final art in artworkOptions) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () =>
                                  setDialogState(() => selectedArtwork = art),
                              borderRadius:
                                  BorderRadius.circular(AppRadii.control),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: art == selectedArtwork
                                      ? palette.brand500.withValues(alpha: 0.2)
                                      : palette.surfaceRaised,
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  border: Border.all(
                                    color: art == selectedArtwork
                                        ? palette.brand500
                                        : palette.stone800,
                                    width: art == selectedArtwork ? 1.5 : 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: DrinkArtwork(id: art, size: 28),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: palette.textMuted),
                ),
              ),
              FilledButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    setDialogState(() => nameError = 'Name required');
                    return;
                  }
                  final caffeine =
                      int.tryParse(caffeineController.text.trim()) ?? 80;
                  final volume =
                      int.tryParse(volumeController.text.trim()) ?? 250;
                  final customId = FavoriteDrink.buildCustomId(
                    name: name,
                    caffeineMg: caffeine,
                    volumeMl: volume,
                    artworkId: selectedArtwork,
                  );
                  Navigator.of(dialogCtx).pop();
                  _addDrink(customId);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: palette.brand500,
                  foregroundColor: palette.textPrimary,
                ),
                child: const Text('Add Drink'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditDrinkDialog(String id) {
    final drink = FavoriteDrink.findById(id);
    if (drink == null) return;

    final nameController = TextEditingController(text: drink.name);
    final caffeineController = TextEditingController(
      text: '${drink.caffeineMg}',
    );
    final volumeController = TextEditingController(text: '${drink.volumeMl}');
    String selectedArtwork = drink.artworkId;

    final artworkOptions = [
      'mug',
      'espresso',
      'cappuccino',
      'latte',
      'icedlatte',
      'coldbrew',
      'blackcoffee',
      'energy',
      'tea',
      'matcha',
      'can',
      'glass',
      'other',
    ];

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          final palette = AppTheme.paletteOf(dialogCtx);
          return AlertDialog(
            backgroundColor: palette.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.largeCard),
              side: BorderSide(color: palette.stone800),
            ),
            title: Text(
              'Customize ${drink.name}',
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DRINK NAME',
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: palette.surfaceRaised,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.control),
                        borderSide: BorderSide(color: palette.stone800),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.control),
                        borderSide: BorderSide(color: palette.stone800),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CAFFEINE (MG)',
                              style: TextStyle(
                                color: palette.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: caffeineController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: palette.surfaceRaised,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
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
                            Text(
                              'VOLUME (ML)',
                              style: TextStyle(
                                color: palette.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: volumeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: palette.surfaceRaised,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  borderSide: BorderSide(
                                    color: palette.stone800,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'ICON ARTWORK',
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final art in artworkOptions) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () =>
                                  setDialogState(() => selectedArtwork = art),
                              borderRadius:
                                  BorderRadius.circular(AppRadii.control),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: art == selectedArtwork
                                      ? palette.brand500.withValues(alpha: 0.2)
                                      : palette.surfaceRaised,
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                  border: Border.all(
                                    color: art == selectedArtwork
                                        ? palette.brand500
                                        : palette.stone800,
                                    width: art == selectedArtwork ? 1.5 : 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: DrinkArtwork(id: art, size: 28),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: palette.textMuted),
                ),
              ),
              FilledButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  final caffeine =
                      int.tryParse(caffeineController.text.trim()) ??
                      drink.caffeineMg;
                  final volume =
                      int.tryParse(volumeController.text.trim()) ??
                      drink.volumeMl;
                  final updatedCustomId = FavoriteDrink.buildCustomId(
                    name: name,
                    caffeineMg: caffeine,
                    volumeMl: volume,
                    artworkId: selectedArtwork,
                  );
                  Navigator.of(dialogCtx).pop();
                  setState(() {
                    final idx = _selectedIds.indexOf(id);
                    if (idx != -1) {
                      _selectedIds[idx] = updatedCustomId;
                    }
                  });
                },
                style: FilledButton.styleFrom(
                  backgroundColor: palette.brand500,
                  foregroundColor: palette.textPrimary,
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final activeDrinks = _selectedIds
        .map((id) => FavoriteDrink.findById(id))
        .whereType<FavoriteDrink>()
        .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.largeCard),
        ),
        border: Border(top: BorderSide(color: palette.stone800)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.stone700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customize Quick Log',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Select up to 10 shortcuts for 1-tap logging',
                          style: TextStyle(
                            color: palette.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showAddCustomDrinkDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Custom'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.brand300,
                      side: BorderSide(color: palette.brand500),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: palette.stone800, height: 1),
            // Main scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.x4),
                children: [
                  // Active Quick Log section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PINNED SHORTCUTS (${activeDrinks.length}/10)',
                        style: TextStyle(
                          color: palette.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      if (activeDrinks.isNotEmpty)
                        Text(
                          'Tap to edit or tap ✕ to remove',
                          style: TextStyle(
                            color: palette.textSubtle,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  if (activeDrinks.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x4,
                        vertical: AppSpacing.x3,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surfaceRaised,
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        border: Border.all(color: palette.stone800),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No quick shortcuts pinned.',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap drinks below to pin, or tap below to restore your 3 onboarding favorites.',
                            style: TextStyle(
                              color: palette.textMuted,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              final candidateList = [
                                ...widget.initialFavoriteIds,
                                'espresso',
                                'americano',
                                'latte',
                                'cappuccino',
                              ];
                              final fallback3 = <String>[];
                              for (final id in candidateList) {
                                if (id.isNotEmpty && !fallback3.contains(id)) {
                                  fallback3.add(id);
                                  if (fallback3.length == 3) break;
                                }
                              }
                              setState(() {
                                _selectedIds = fallback3;
                              });
                            },
                            icon: const Icon(Icons.replay_rounded, size: 14),
                            label: const Text('Restore 3 Shortcuts'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: palette.brand300,
                              side: BorderSide(color: palette.brand500),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final drink in activeDrinks)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: palette.surfaceRaised,
                              borderRadius: BorderRadius.circular(
                                AppRadii.control,
                              ),
                              border: Border.all(
                                color: palette.brand500.withValues(alpha: 0.6),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DrinkArtwork(id: drink.artworkId, size: 26),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => _showEditDrinkDialog(drink.id),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        drink.name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${drink.caffeineMg}mg • ${drink.volumeMl}ml',
                                        style: TextStyle(
                                          color: palette.brand300,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => _showEditDrinkDialog(drink.id),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 15,
                                    color: palette.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () => _removeDrink(drink.id),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: palette.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.x5),
                  // Catalog section
                  Text(
                    'ADD FROM CATALOG',
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  ...FavoriteDrink.fullLogCatalog.map((drink) {
                    final isPinned = _selectedIds.any((id) {
                      final parsed = FavoriteDrink.findById(id);
                      return parsed?.name == drink.name || id == drink.id;
                    });

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CoffeeCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            DrinkArtwork(id: drink.id, size: 36),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    drink.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${drink.caffeineMg} mg caffeine • ${drink.volumeMl} ml',
                                    style: TextStyle(
                                      color: palette.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isPinned)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: palette.stateSuccess.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.control,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: palette.stateSuccess,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Pinned',
                                      style: TextStyle(
                                        color: palette.stateSuccess,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              IconButton(
                                onPressed: () => _addDrink(drink.id),
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                ),
                                color: palette.brand400,
                                tooltip: 'Pin to Quick Log',
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Bottom Save bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                color: palette.surfaceRaised,
                border: Border(top: BorderSide(color: palette.stone800)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.brand500,
                    foregroundColor: palette.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.control),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save Quick Log',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
