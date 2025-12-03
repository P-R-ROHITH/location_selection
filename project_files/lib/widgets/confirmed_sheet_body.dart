import 'package:flutter/material.dart';

class ConfirmedSheetBody extends StatelessWidget {
  const ConfirmedSheetBody({required this.theme, super.key});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(height: 8),
      const SizedBox(height: 8),
      // Nearest doctor row (plain text, no box)
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Nearest doctor available', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF172B4D))),
        Text('4.3km', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF172B4D))),
      ]),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Booking fees', style: theme.textTheme.bodyMedium), const SizedBox(height: 4), Text('(incl all taxes & Fees)', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54))]),
        Text('₹1599', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 18),
    ]);
  }
}
