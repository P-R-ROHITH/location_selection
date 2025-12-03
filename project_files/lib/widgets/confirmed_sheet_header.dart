import 'package:flutter/material.dart';

class ConfirmedSheetHeader extends StatelessWidget {
  const ConfirmedSheetHeader({required this.address, this.coords, required this.onEdit, super.key});

  final String address;
  final String? coords;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Container(width: 56, height: 6, decoration: BoxDecoration(color: const Color(0xFF4A39F6), borderRadius: BorderRadius.circular(6)))),
        const SizedBox(height: 18),
        Text(address, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 20)),
        if (coords != null) Text(coords!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
        TextButton.icon(onPressed: onEdit, icon: const Icon(Icons.edit, size: 18, color: Color(0xFF4A39F6)), label: Text('Edit location', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF4A39F6)))),
      ],
    );
  }
}
