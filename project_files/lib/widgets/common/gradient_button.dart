import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({required this.text, required this.onPressed, super.key});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF3A2CEB), Color(0xFF6C49FF)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ),
    );
  }
}
