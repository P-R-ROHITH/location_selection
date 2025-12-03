import 'package:flutter/material.dart';

class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key, required this.address, this.coords});

  final String address;
  final String? coords;

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  final _houseCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _directionsCtrl = TextEditingController();
  String _saveAs = 'Other';

  @override
  void dispose() {
    _houseCtrl.dispose();
    _areaCtrl.dispose();
    _directionsCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    // Validate mandatory house/flat/block field
    if (_houseCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter house / flat / block no.')));
      return;
    }

    final summary = {
      'address': widget.address,
      'coords': widget.coords,
      'house': _houseCtrl.text.trim(),
      'area': _areaCtrl.text.trim(),
      'directions': _directionsCtrl.text.trim(),
      'saveAs': _saveAs,
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved: ${_saveAs}')));
    Navigator.of(context).pop(summary);
  }

  Widget _chip(String label, IconData? icon) {
    final selected = _saveAs == label;
    return ChoiceChip(
      label: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 16, color: selected ? Colors.white : Colors.black54), const SizedBox(width: 6)],
        Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black87)),
      ]),
      selected: selected,
      onSelected: (_) => setState(() => _saveAs = label),
      selectedColor: const Color(0xFF4A39F6),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.black12)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: Colors.black87)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.location_on, color: Color(0xFF4A39F6)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(widget.address, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
                ]),
                const SizedBox(height: 8),
                if (widget.coords != null) Text(widget.coords!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
              ]),
            ),

            const SizedBox(height: 18),
            Text('HOUSE / FLAT / BLOCK NO.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45)),
            const SizedBox(height: 6),
            TextField(controller: _houseCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. Flat 2B')),

            const SizedBox(height: 18),
            Text('APARTMENT / ROAD / AREA (RECOMMENDED)', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45)),
            const SizedBox(height: 6),
            TextField(controller: _areaCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. MG Road')),

            const SizedBox(height: 18),
            Text('DIRECTIONS TO REACH (OPTIONAL)', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _directionsCtrl,
                maxLines: 5,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g. Ring the bell on the red gate'),
              ),
            ),

            const SizedBox(height: 18),
            Text('save as', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _chip('Home', Icons.home),
              _chip('Work', Icons.work),
              _chip('Friends and Family', Icons.people),
              _chip('Other', Icons.location_on),
            ]),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _houseCtrl,
                builder: (context, value, child) {
                  final filled = value.text.trim().isNotEmpty;
                  final ButtonStyle btnStyle = ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.disabled) ? Colors.grey.shade300 : const Color(0xFF4A39F6)),
                    foregroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.disabled) ? Colors.black38 : Colors.white),
                  );
                  return ElevatedButton(
                    onPressed: filled ? _onSave : null,
                    style: btnStyle,
                    child: Text(filled ? 'Save and proceed' : 'ENTER HOUSE / FLAT / BLOCK NO.', style: theme.textTheme.titleMedium?.copyWith(color: filled ? Colors.white : Colors.black54, fontWeight: FontWeight.w800)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}
