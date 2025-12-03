import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../widgets/search_bar.dart';
import '../widgets/bottom_panel/bottom_panel.dart';
import 'address_details_page.dart';
import '../widgets/shared/draggable_handle.dart';
import '../widgets/map/map_pin.dart';
import '../widgets/price_confirmation_button_v2.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final MapController mapController = MapController();

  static final LatLng _indiaCenter = LatLng(20.5937, 78.9629);

  LatLng? _currentLatLng;
  String? _currentAddress;
  String? _currentCoords;
  String _estimatedPrice = 'INR 2699';
  bool _isPickingNew = false;
  LatLng? _pickingLatLng;
  String? _pickingAddress;
  Timer? _reverseDebounce;

  // Test data: mapping saved names to full addresses
  final Map<String, String> _savedAddresses = const {
    'Home': '221B Baker Street, London',
    'Work': '1600 Amphitheatre Parkway, Mountain View, CA',
    'Gym': '24/7 Fitness Center, 12 Market Road, Localtown'
  };
  String? _selectedSaved;
  final DraggableScrollableController _draggableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) return;

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final ll = LatLng(pos.latitude, pos.longitude);
      _setLocation(ll);
      try {
        mapController.move(ll, 15);
      } catch (_) {}
      _reverseGeocode(ll);
    } catch (_) {}
  }

  void _startAddNew() async {
    // Enter pick-new mode: collapse sheet and center map on current location if available
    setState(() => _isPickingNew = true);
    try {
      await _draggableController.animateTo(0.09, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } catch (_) {}
    // If we don't have a current location, try to fetch it
    if (_currentLatLng == null) {
      await _initLocation();
    } else {
      try {
        mapController.move(_currentLatLng!, 17);
      } catch (_) {}
    }
  }

  void _cancelAddNew() {
    setState(() => _isPickingNew = false);
  }

  Future<void> _confirmPickedLocation() async {
    // Determine the map center as the chosen location
    LatLng chosen;
    chosen = _pickingLatLng ?? _currentLatLng ?? _indiaCenter;
    _setLocation(chosen);
    await _reverseGeocode(chosen);
    setState(() => _isPickingNew = false);
    _onConfirm();
  }

  void _schedulePickingReverseGeocode(LatLng ll) {
    _reverseDebounce?.cancel();
    _reverseDebounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final addr = await _reverseGeocodeForPicking(ll);
        if (mounted) setState(() => _pickingAddress = addr);
      } catch (_) {}
    });
  }

  Future<String?> _reverseGeocodeForPicking(LatLng ll) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': ll.latitude.toString(),
        'lon': ll.longitude.toString(),
        'addressdetails': '1',
        'zoom': '18',
      });
      final res = await http.get(uri, headers: {'User-Agent': 'location_picker_app'});
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final display = (data['name'] ?? data['display_name']) as String?;
        final displayFull = (data['display_name'] as String?) ?? display;
        if (displayFull != null && displayFull.isNotEmpty) return displayFull;
      }
    } catch (_) {}

    try {
      final placemarks = await geocoding.placemarkFromCoordinates(ll.latitude, ll.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final maybeName = p.subLocality?.isNotEmpty == true ? p.subLocality : (p.locality?.isNotEmpty == true ? p.locality : p.name);
        final address = [
          if (maybeName?.isNotEmpty == true) maybeName,
          if (p.street?.isNotEmpty == true) p.street,
          if (p.locality?.isNotEmpty == true && maybeName != p.locality) p.locality,
        ].whereType<String>().join(', ');
        if (address.isNotEmpty) return address;
      }
    } catch (_) {}

    return null;
  }

  void _setLocation(LatLng ll) {
    setState(() {
      _currentLatLng = ll;
      _currentCoords = '${ll.latitude.toStringAsFixed(6)}, ${ll.longitude.toStringAsFixed(6)}';
    });
  }

  Future<void> _reverseGeocode(LatLng ll) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': ll.latitude.toString(),
        'lon': ll.longitude.toString(),
        'addressdetails': '1',
        'zoom': '18',
      });
      final res = await http.get(uri, headers: {'User-Agent': 'location_picker_app'});
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final display = (data['name'] ?? data['display_name']) as String?;
        final displayFull = (data['display_name'] as String?) ?? display;
        if (display != null && display.isNotEmpty) {
          setState(() {
            _currentAddress = displayFull;
          });
          if (_searchCtrl.text.isEmpty) _searchCtrl.text = display;
          return;
        }
      }
    } catch (_) {}

    try {
      final placemarks = await geocoding.placemarkFromCoordinates(ll.latitude, ll.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final maybeName = p.subLocality?.isNotEmpty == true ? p.subLocality : (p.locality?.isNotEmpty == true ? p.locality : p.name);
        final address = [
          if (maybeName?.isNotEmpty == true) maybeName,
          if (p.street?.isNotEmpty == true) p.street,
          if (p.locality?.isNotEmpty == true && maybeName != p.locality) p.locality,
        ].whereType<String>().join(', ');
        setState(() {
          _currentAddress = address;
        });
        if (_searchCtrl.text.isEmpty) _searchCtrl.text = address;
      }
    } catch (_) {}
  }

  void _onConfirm() {
    final address = _searchCtrl.text.trim().isEmpty ? (_currentAddress ?? 'Selected location') : _searchCtrl.text.trim();
    // Navigate to the full address details page
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddressDetailsPage(address: address, coords: _currentCoords)));
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 88.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _currentLatLng ?? _indiaCenter,
                initialZoom: 4.6,
                onTap: (tapPos, latlng) async {
                  _setLocation(latlng);
                  await _reverseGeocode(latlng);
                },
                onPositionChanged: (pos, hasGesture) {
                  if (_isPickingNew) {
                    final center = pos.center;
                    setState(() => _pickingLatLng = center);
                    _schedulePickingReverseGeocode(center);
                  }
                },
              ),
              children: [
                TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c'], userAgentPackageName: 'com.example.location_picker'),
                if (_currentLatLng != null) ...[
                  CircleLayer(circles: [CircleMarker(point: _currentLatLng!, color: Colors.blue.withOpacity(.18), borderStrokeWidth: 1, borderColor: Colors.blueAccent, useRadiusInMeter: true, radius: 60)]),
                  MarkerLayer(markers: [Marker(point: _currentLatLng!, width: 48, height: 48, child: MapPin(point: _currentLatLng!))]),
                ]
              ],
            ),
          ),
          // (search bar is positioned below the purple header further down)
          // Purple header overlay (app-bar style)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: headerHeight + MediaQuery.of(context).padding.top,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
              decoration: const BoxDecoration(color: Color(0xFF4A39F6)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 10),
                Row(children: [
                  IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('Where should we come?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('Choose your pickup location to continue', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ]),
                  ),
                ])
              ]),
            ),
          ),
          // Position search bar immediately below the purple app bar
          Positioned(left: 16, right: 16, top: headerHeight + MediaQuery.of(context).padding.top + 8, child: LocationSearchBar(controller: _searchCtrl)),
          
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                controller: _draggableController,
                initialChildSize: 0.35,
                minChildSize: 0.09,
                maxChildSize: 0.62,
                snap: true,
                snapSizes: const [0.09, 0.35, 0.62],
                builder: (context, scrollController) {
                  // snap sizes must match the sheet configuration
                  const snapSizes = [0.09, 0.35, 0.62];
                  return GestureDetector(
                    // capture vertical drags anywhere on the tray and convert them to sheet size changes
                    onVerticalDragUpdate: (details) {
                      final height = MediaQuery.of(context).size.height;
                      // dragging down increases dy (positive) => decrease sheet size
                      final deltaFraction = details.delta.dy / height;
                      final newSize = (_draggableController.size - deltaFraction).clamp(0.0, 1.0);
                      // animate quickly to the new size for responsive feel
                      try {
                        _draggableController.animateTo(newSize, duration: const Duration(milliseconds: 50), curve: Curves.linear);
                      } catch (_) {}
                    },
                    onVerticalDragEnd: (details) {
                      // snap to the nearest configured size
                      final cur = _draggableController.size;
                      double nearest = snapSizes.first;
                      double bestDiff = (cur - nearest).abs();
                      for (final s in snapSizes) {
                        final d = (cur - s).abs();
                        if (d < bestDiff) {
                          bestDiff = d;
                          nearest = s;
                        }
                      }
                      try {
                        _draggableController.animateTo(nearest, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                      } catch (_) {}
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DraggableHandle(onTap: () async {
                            final current = _draggableController.size;
                            if (current > 0.2) {
                              await _draggableController.animateTo(0.09, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            } else {
                              await _draggableController.animateTo(0.35, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          }),
                          Expanded(
                            child: LayoutBuilder(builder: (context, constraints) {
                              final bottomInset = MediaQuery.of(context).padding.bottom;
                              const buttonHeight = 56.0;
                              const buttonVerticalGap = 12.0;
                              final contentBottomPadding = buttonHeight + buttonVerticalGap + bottomInset + 8.0;
                              return Stack(children: [
                                SingleChildScrollView(
                                  controller: scrollController,
                                  padding: EdgeInsets.only(bottom: contentBottomPadding),
                                  child: BottomPanel(
                                    savedAddresses: _savedAddresses,
                                    // Always show the full/current address in the tray.
                                    address: _currentAddress,
                                    coords: _currentCoords,
                                    selectedSaved: _selectedSaved,
                                    showConfirm: false,
                                    onSavedSelected: (s) async {
                                      final addr = _savedAddresses[s] ?? s;
                                      setState(() {
                                        _selectedSaved = s;
                                        _currentAddress = addr;
                                        _currentCoords = null;
                                      });
                                      try {
                                        await _draggableController.animateTo(0.35, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                      } catch (_) {}
                                    },
                                    onUseCurrent: () async => await _initLocation(),
                                    onConfirm: _onConfirm,
                                    onAddNew: _startAddNew,
                                  ),
                                ),
                                if ((_currentAddress != null && _currentAddress!.isNotEmpty) || _selectedSaved != null)
                                  Positioned(
                                    left: 16,
                                    right: 16,
                                    bottom: buttonVerticalGap + bottomInset + 8,
                                    child: PriceConfirmationButtonV2(
                                      estimatedPrice: _estimatedPrice,
                                      onContinue: _onConfirm,
                                    ),
                                  ),
                              ]);
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Picking-mode overlays: show a fixed center-pin, current-location button and confirm/cancel when adding a new address
          if (_isPickingNew) ...[
            // Center pin overlay (visual only)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(child: MapPin(point: _pickingLatLng ?? _currentLatLng ?? _indiaCenter)),
              ),
            ),
            // Small floating current-location button
            Positioned(
              bottom: 180,
              right: 18,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: Colors.white, foregroundColor: Colors.black87, elevation: 4),
                onPressed: () async => await _initLocation(),
                icon: const Icon(Icons.my_location, color: Color(0xFFFB6A00)),
                label: const Text('Current location'),
              ),
            ),
            // Cancel button top-right
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: IconButton(
                onPressed: _cancelAddNew,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
            // Bottom card showing address preview and confirm CTA (matches screenshot)
            Positioned(
              left: 16,
              right: 16,
              bottom: 64,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))]),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Place the pin at exact delivery location', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.black54)),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on, color: Color(0xFF4A39F6)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_pickingAddress ?? (_currentAddress ?? 'Select location on map'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A39F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: _confirmPickedLocation,
                      child: const Text('Confirm & proceed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
