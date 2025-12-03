import 'package:flutter/material.dart';

import 'address_display.dart';
import 'confirm_button.dart';
import 'info_card.dart';

class BottomPanel extends StatefulWidget {
  const BottomPanel({
    this.savedAddresses,
    this.selectedSaved,
    this.onSavedSelected,
    this.onUseCurrent,
    this.onConfirm,
    this.onAddNew,
    this.address,
    this.coords,
    this.showConfirm = true,
    super.key,
  });

  final Map<String, String>? savedAddresses;
  final String? selectedSaved;
  final ValueChanged<String?>? onSavedSelected;
  final VoidCallback? onUseCurrent;
  final VoidCallback? onConfirm;
  final VoidCallback? onAddNew;
  final String? address;
  final String? coords;
  final bool showConfirm;

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = widget.savedAddresses?.entries.toList() ?? <MapEntry<String, String>>[];
    final showAll = _expanded;
    final displayed = showAll ? entries : (entries.isNotEmpty ? [entries.first] : <MapEntry<String, String>>[]);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Header (title only). Removed 'Use current location' row; title made larger.
            Row(children: [
              Expanded(child: Text('Choose a address', style: theme.textTheme.titleLarge?.copyWith(color: Colors.black87, fontWeight: FontWeight.w800))),
            ]),
            const SizedBox(height: 8),
            // Add new address row (always visible below header)
            InkWell(
              onTap: widget.onAddNew ?? () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF4A39F6).withOpacity(0.12))),
                    child: Icon(Icons.add, color: const Color(0xFF4A39F6)),
                  ),
                  const SizedBox(width: 12),
                  Text('Add new Address', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF4A39F6))),
                ]),
              ),
            ),
            const SizedBox(height: 8),
            if (displayed.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  children: displayed.map((e) {
                    final key = e.key;
                    final value = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AddressDisplay(
                        theme: theme,
                        label: key,
                        address: value,
                        coords: null,
                        selected: widget.selectedSaved == key,
                        onTap: () => widget.onSavedSelected?.call(key),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Show the View all / View less toggle below the displayed addresses (centered).
            if (entries.isNotEmpty)
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? 'View less' : 'View all'),
                ),
              ),
            const SizedBox(height: 12),
            InfoCard(theme: theme),
            const SizedBox(height: 16),
            if (widget.showConfirm) ConfirmButton(text: 'Confirm Location', onPressed: widget.onConfirm ?? () {}),
          ],
        ),
      ),
    );
  }
}
