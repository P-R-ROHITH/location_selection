import 'package:flutter/material.dart';

class PriceConfirmationBody extends StatelessWidget {
  final VoidCallback onContinue;
  final String estimatedPrice;
  final Color backgroundColor;

  const PriceConfirmationBody({
    super.key,
    required this.onContinue,
    required this.estimatedPrice,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onContinue,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 14.0, top: 10.0, right: 14.0, bottom: 10.0 + bottomPadding),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Estimated price', style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 4.0),
                  Text(estimatedPrice, style: const TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                  SizedBox(width: 6.0),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
