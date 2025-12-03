import 'package:flutter/material.dart';

class ConfirmedSheetActions extends StatelessWidget {
  const ConfirmedSheetActions({required this.onPrimary, this.price = 'INR 2699', Key? key}) : super(key: key);

  final VoidCallback onPrimary;
  final String price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 64,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6C49FF), Color(0xFF3A2CEB)]),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.18), blurRadius: 10, offset: const Offset(0, 6))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onPrimary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    // Left: large price only (no 'Estimated price' label)
                    Text(price, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                    // Right: Continue + arrow
                    Row(children: [
                      Text('Continue', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ])
                  ]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
