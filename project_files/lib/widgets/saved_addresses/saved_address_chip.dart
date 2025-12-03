import 'package:flutter/material.dart';

class SavedAddressChip extends StatelessWidget {
  const SavedAddressChip({required this.label, required this.selected, required this.onSelected, super.key});

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFFEBE7FF),
      labelStyle: TextStyle(color: selected ? const Color(0xFF4A39F6) : Colors.black87, fontWeight: FontWeight.w600),
      shape: StadiumBorder(side: BorderSide(color: selected ? const Color(0xFF4A39F6) : const Color(0xFFE0E0E0))),
    );
  }
}
