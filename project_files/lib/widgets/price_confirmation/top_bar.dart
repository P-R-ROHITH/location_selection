import 'package:flutter/material.dart';

class PriceConfirmationTopBar extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const PriceConfirmationTopBar({
    super.key,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w500),
      ),
    );
  }
}
