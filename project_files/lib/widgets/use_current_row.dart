import 'package:flutter/material.dart';

class UseCurrentRow extends StatelessWidget {
  const UseCurrentRow({required this.theme, required this.onUseCurrent, super.key});

  final ThemeData theme;
  final VoidCallback onUseCurrent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onUseCurrent,
          child: CircleAvatar(radius: 18, backgroundColor: const Color(0xFFEDEBFF), child: const Icon(Icons.my_location, color: Color(0xFF4A39F6))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Use current location', style: theme.textTheme.titleMedium?.copyWith(color: const Color(0xFF283593), fontWeight: FontWeight.w700)),
        ),
        CircleAvatar(radius: 18, backgroundColor: const Color(0xFFEDEBFF), child: Icon(Icons.receipt_long, color: Colors.indigo.shade400)),
      ],
    );
  }
}
