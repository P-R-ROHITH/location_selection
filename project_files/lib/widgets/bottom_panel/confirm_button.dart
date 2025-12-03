import 'package:flutter/material.dart';
import '../gradient_button.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({required this.text, required this.onPressed, super.key});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GradientButton(text: text, onPressed: onPressed);
}
