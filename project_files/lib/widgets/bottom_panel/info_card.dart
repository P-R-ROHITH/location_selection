import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({required this.theme, super.key});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF6F5FF), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6E3FF))),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
          child: const Icon(Icons.local_taxi, color: Color(0xFF4A39F6), size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text('Qurocare cars are available in your area from 9:00AM to 9:00PM', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.indigo.shade600))),
      ]),
    );
  }
}
