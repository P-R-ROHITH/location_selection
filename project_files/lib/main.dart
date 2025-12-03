import 'package:flutter/material.dart';
import 'pages/location_picker_page.dart';

void main() {
  runApp(const LocationPickerApp());
}

class LocationPickerApp extends StatelessWidget {
  const LocationPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Picker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A39F6)),
        useMaterial3: true,
      ),
      home: const LocationPickerPage(),
    );
  }
}
