import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapPin extends StatelessWidget {
  const MapPin({required this.point, super.key});

  final LatLng point;

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.location_on, color: Colors.indigo, size: 44);
  }
}
