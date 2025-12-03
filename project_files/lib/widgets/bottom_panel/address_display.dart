import 'package:flutter/material.dart';

class AddressDisplay extends StatelessWidget {
  const AddressDisplay({this.address, this.coords, this.label, this.selected = false, required this.theme, this.onTap, super.key});

  final String? address;
  final String? coords;
  final String? label;
  final bool selected;
  final ThemeData theme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (address == null && coords == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
          child: const Icon(Icons.home, color: Color(0xFF4A39F6)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(label ?? 'Saved', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              if (selected)
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEBFFF0), borderRadius: BorderRadius.circular(12)), child: Text('SELECTED', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF0E8A3F), fontWeight: FontWeight.w700)))
            ]),
            const SizedBox(height: 6),
            if (address != null)
              Text(address!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
            if (coords != null) ...[
              const SizedBox(height: 6),
              Text(coords!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54, fontSize: 12)),
            ],
          ]),
        ),
        const SizedBox(width: 4),
      ]),
      ),
    );
  }
}
