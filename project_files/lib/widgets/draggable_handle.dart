import 'package:flutter/material.dart';

class DraggableHandle extends StatelessWidget {
  const DraggableHandle({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 36,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)]),
        alignment: Alignment.center,
        child: const Icon(Icons.drag_handle, color: Colors.black54),
      ),
    );
  }
}
