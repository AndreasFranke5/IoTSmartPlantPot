import 'package:flutter/material.dart';

class LoadingOverlay {
  LoadingOverlay();

  OverlayEntry? _overlay;

  void show(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            color: const Color(0xc0000000),
            height: double.infinity,
            width: double.infinity,
            child: const Center(
              child: Text(
                'Processing...',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(_overlay!);
    }
  }

  void hide() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }
}
