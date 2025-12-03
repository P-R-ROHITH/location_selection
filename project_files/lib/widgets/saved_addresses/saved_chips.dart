import 'package:flutter/material.dart';
import 'saved_address_chip.dart';

class SavedChips extends StatelessWidget {
  const SavedChips({required this.saved, required this.selectedSaved, required this.onSavedSelected, super.key});

  final List<String> saved;
  final String? selectedSaved;
  final void Function(String) onSavedSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: saved.map((s) {
        final selected = s == selectedSaved;
        return SavedAddressChip(label: s, selected: selected, onSelected: () => onSavedSelected(s));
      }).toList(),
    );
  }
}
