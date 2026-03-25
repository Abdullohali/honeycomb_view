import 'package:flutter/material.dart';

/// HoneyCombView uchun scroll holatini boshqaruvchi controller.
///
/// ```dart
/// final controller = HoneyCombController();
///
/// // Markazga qaytish
/// controller.scrollToCenter();
/// ```
class HoneyCombController extends ChangeNotifier {
  ScrollController? _vCtrl;
  ScrollController? _hCtrl;

  /// Ichki foydalanish uchun — widget tomonidan o'rnatiladi.
  void attach(ScrollController v, ScrollController h) {
    _vCtrl = v;
    _hCtrl = h;
  }

  /// Gridni markaziy pozitsiyaga scroll qiladi.
  void scrollToCenter({Duration duration = const Duration(milliseconds: 400)}) {
    _vCtrl?.animateTo(
      _vCtrl!.position.maxScrollExtent / 2,
      duration: duration,
      curve: Curves.easeInOut,
    );
    _hCtrl?.animateTo(
      _hCtrl!.position.maxScrollExtent / 2,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _vCtrl = null;
    _hCtrl = null;
    super.dispose();
  }
}
