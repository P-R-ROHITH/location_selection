import 'package:flutter/material.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        // Inverted left-to-right gradient: darker purple on the right
        // Make the right color slightly transparent for a fade effect
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF4A39F6), Color.fromRGBO(108, 73, 255, 0.86)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF9EA7FF), width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 6),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Search for a location', border: InputBorder.none, hintStyle: TextStyle(color: Colors.white70), isDense: true, contentPadding: EdgeInsets.zero),
            ),
          ),
          IconButton(icon: const Icon(Icons.mic, color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }
}
