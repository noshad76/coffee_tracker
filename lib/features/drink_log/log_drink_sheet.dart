import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../shared/widgets/drink_artwork.dart';
import '../onboarding/models/favorite_drink.dart';
import '../tracking/models/tracking_models.dart';
import '../tracking/providers/tracking_providers.dart';

class LogDrinkSheet extends ConsumerStatefulWidget {
  const LogDrinkSheet({super.key, this.initialRecord});
  final DrinkRecord? initialRecord;

  @override
  ConsumerState<LogDrinkSheet> createState() => _LogDrinkSheetState();
}

class _LogDrinkSheetState extends ConsumerState<LogDrinkSheet> {
  final name = TextEditingController(text: 'Latte');
  final caffeine = TextEditingController(text: '120');
  final volume = TextEditingController(text: '300');
  final cafeName = TextEditingController();
  final price = TextEditingController();
  final note = TextEditingController();
  String temperature = 'Hot';
  String location = 'home';
  String cupStyle = 'Ceramic Mug';
  String selectedDrinkId = 'latte';
  TimeOfDay time = TimeOfDay.now();
  bool saving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final record = widget.initialRecord;
    if (record == null) return;
    name.text = record.name;
    caffeine.text = '${record.caffeineMg}';
    volume.text = '${record.volumeMl}';
    cafeName.text = record.cafeName ?? '';
    price.text = (record.priceCents / 100).toStringAsFixed(2);
    note.text = record.note ?? '';
    temperature = record.temperature;
    location = record.location;
    cupStyle = record.cupStyle;
    selectedDrinkId =
        FavoriteDrink.fullLogCatalog
            .where((drink) => drink.name == record.name)
            .map((drink) => drink.id)
            .firstOrNull ??
        'other';
    time = TimeOfDay.fromDateTime(record.localTime);
  }

  @override
  void dispose() {
    for (final controller in [name, caffeine, volume, cafeName, price, note]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .9,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheetTop),
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.initialRecord == null ? 'Log Drink' : 'Edit Drink',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Divider(color: palette.stone800),
              const SizedBox(height: 8),
              _label(context, 'DRINK'),
              const SizedBox(height: 8),
              SizedBox(
                height: 82,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final drink in FavoriteDrink.fullLogCatalog)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() {
                            selectedDrinkId = drink.id;
                            name.text = drink.id == 'other'
                                ? 'Custom drink'
                                : drink.name;
                            caffeine.text = '${drink.caffeineMg}';
                            volume.text = '${drink.volumeMl}';
                          }),
                          child: Container(
                            width: 76,
                            decoration: BoxDecoration(
                              color: selectedDrinkId == drink.id
                                  ? palette.surfaceRaised
                                  : palette.stone900,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selectedDrinkId == drink.id
                                    ? palette.brand500
                                    : palette.stone800,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DrinkArtwork(id: drink.id, size: 46),
                                Text(
                                  drink.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: 'Drink Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: caffeine,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Caffeine (mg)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: volume,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Volume (ml)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(context, 'TEMPERATURE'),
                        Row(
                          children: [
                            for (final choice in ['Hot', 'Iced'])
                              Expanded(
                                child: ChoiceChip(
                                  label: Text(
                                    choice,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  selected: temperature == choice,
                                  onSelected: (_) =>
                                      setState(() => temperature = choice),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _label(context, 'LOCATION & SPENDING'),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text(
                        'Home Brew',
                        style: TextStyle(fontSize: 11),
                      ),
                      selected: location == 'home',
                      onSelected: (_) => setState(() => location = 'home'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text(
                        'At Cafe',
                        style: TextStyle(fontSize: 11),
                      ),
                      selected: location == 'cafe',
                      onSelected: (_) => setState(() => location = 'cafe'),
                    ),
                  ),
                ],
              ),
              if (location == 'cafe')
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cafeName,
                        decoration: const InputDecoration(
                          labelText: 'Cafe Name',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: price,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: cupStyle,
                      decoration: const InputDecoration(labelText: 'Cup Style'),
                      items: [
                        for (final style in [
                          'Ceramic Mug',
                          'Paper Takeaway Cup',
                          'Glass Cup',
                          'Thermos Tumbler',
                        ])
                          DropdownMenuItem(
                            value: style,
                            child: Text(style, overflow: TextOverflow.ellipsis),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => cupStyle = value ?? cupStyle),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final selected = await showTimePicker(
                          context: context,
                          initialTime: time,
                        );
                        if (selected != null) setState(() => time = selected);
                      },
                      icon: const Icon(Icons.schedule),
                      label: Text(time.format(context)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: note,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'With oat milk & honey',
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    error!,
                    style: TextStyle(color: palette.stateDanger),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: saving ? null : _save,
                child: Text(
                  saving
                      ? 'Saving...'
                      : widget.initialRecord == null
                      ? 'Log Entry'
                      : 'Save Changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Text(
    text,
    style: TextStyle(
      color: AppTheme.paletteOf(context).textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
  );

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
    try {
      final draft = DrinkDraft(
        name: name.text.trim(),
        caffeineMg: mg,
        volumeMl: ml,
        consumedAtUtc: local.toUtc(),
        priceCents: (dollars * 100).round(),
        temperature: temperature,
        location: location,
        cupStyle: cupStyle,
        cafeName: cafeName.text.trim().isEmpty ? null : cafeName.text.trim(),
        note: note.text.trim().isEmpty ? null : note.text.trim(),
      );
      final controller = ref.read(trackingControllerProvider.notifier);
      if (widget.initialRecord == null) {
        await controller.addDrink(draft);
      } else {
        await controller.updateDrink(widget.initialRecord!.id, draft);
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = 'Could not save drink. Try again.';
        });
      }
    }
  }
}
