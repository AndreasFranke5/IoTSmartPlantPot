import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  Barcode? _barcode;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted && _barcode == null) {
      setState(() => _barcode = barcodes.barcodes.firstOrNull);
      if (barcodes.barcodes.firstOrNull != null) {
        Navigator.pop(context, barcodes.barcodes.firstOrNull!.displayValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: kToolbarHeight,
                child: AppBar(
                  leading: IconButton(
                    padding: const EdgeInsets.only(left: 8),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
