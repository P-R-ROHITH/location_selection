import 'package:flutter/material.dart';

import 'price_confirmation/top_bar.dart';
import 'price_confirmation/body.dart';

const Color _kPrimaryColor = Color(0xFF3B28A8);

class PriceConfirmationButtonV2 extends StatelessWidget {
  final VoidCallback onContinue;
  final String estimatedPrice;

  const PriceConfirmationButtonV2({
    super.key,
    required this.onContinue,
    this.estimatedPrice = 'INR 2399',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PriceConfirmationTopBar(text: 'Next > confirm your location', backgroundColor: _kPrimaryColor.withOpacity(0.9)),
        const SizedBox(height: 6.0),
        PriceConfirmationBody(onContinue: onContinue, estimatedPrice: estimatedPrice, backgroundColor: _kPrimaryColor),
      ],
    );
  }
}
