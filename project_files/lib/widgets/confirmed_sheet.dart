import 'package:flutter/material.dart';

import 'confirmed_sheet_header.dart';
import 'confirmed_sheet_body.dart';
import 'confirmed_sheet_actions.dart';

class ConfirmedLocationSheet extends StatelessWidget {
  const ConfirmedLocationSheet({required this.address, required this.coords, required this.onEdit, required this.onPrimary, this.price = 'INR 2699', super.key});

  final String address;
  final String? coords;
  final VoidCallback onEdit;
  final VoidCallback onPrimary;
  final String price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ConfirmedSheetHeader(address: address, coords: coords, onEdit: onEdit),
          ConfirmedSheetBody(theme: theme),
          ConfirmedSheetActions(onPrimary: onPrimary, price: price),
        ]),
      ),
    );
  }
}
