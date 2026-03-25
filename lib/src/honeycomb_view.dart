import 'package:flutter/material.dart';
import 'honeycomb_controller.dart';
import 'honeycomb_item.dart';

// ────────────────────────────────────────────────────────────────
// HoneyCombView
// ────────────────────────────────────────────────────────────────

/// Honeycomb (asalari uyasi) tartibida joylashgan scroll-grid widget.
///
/// Scroll qilinayotganda ekran markazidan uzoq elementlar kichikroq
/// va shaffofroq ko'rinadi — bu "depth" effektini yaratadi.
///
/// ## Oddiy foydalanish
///
/// ```dart
/// HoneyCombView(
///   images: [
///     'https://example.com/a.jpg',
///     'https://example.com/b.jpg',
///   ],
/// )
/// ```
///
/// ## Sozlamalar bilan
///
/// ```dart
/// HoneyCombView(
///   images: myUrls,
///   itemSize: 180,
///   spacing: 10,
///   rows: 12,
///   columns: 18,
///   maxDistance: 300,
///   onItemTap: (index) => print('Tapped: $index'),
/// )
/// ```
class HoneyCombView extends StatefulWidget {
  /// Ko'rsatiladigan rasm yo'llari ro'yxati.
  ///
  /// [assetsImage] false (default) bo'lsa — network URL:
  ///   `'https://example.com/photo.jpg'`
  ///
  /// [assetsImage] true bo'lsa — asset yo'li:
  ///   `'assets/images/photo.jpg'`
  final List<String> images;

  /// true  → rasmlar asset dan o'qiladi (AssetImage).
  /// false → rasmlar network dan o'qiladi (NetworkImage).
  /// Default: false.
  final bool assetsImage;

  /// Har bir element diametri. Default: `160`.
  final double itemSize;

  /// Elementlar orasidagi bo'shliq. Default: `12`.
  final double spacing;

  /// Gridning qator soni. Default: `15`.
  final int rows;

  /// Gridning ustun soni. Default: `20`.
  final int columns;

  /// Ushbu masofadan tashqaridagi elementlar minimal scale/opacity ga tushadi.
  /// Default: `280`.
  final double maxDistance;

  /// Markazdagi elementning scale qiymati. Default: `1.0`.
  final double maxScale;

  /// Chetdagi elementning minimal scale qiymati. Default: `0.55`.
  final double minScale;

  /// Markazdagi elementning opacity qiymati. Default: `1.0`.
  final double maxOpacity;

  /// Chetdagi elementning minimal opacity qiymati. Default: `0.35`.
  final double minOpacity;

  /// Element bosilganda chaqiriladi; index rasm ro'yxatidagi tartib raqami.
  final ValueChanged<int>? onItemTap;

  /// Ixtiyoriy controller — `scrollToCenter()` kabi amallar uchun.
  final HoneyCombController? controller;

  /// Fon rangi. Default: [Colors.black].
  final Color backgroundColor;

  const HoneyCombView({
    super.key,
    required this.images,
    this.assetsImage   = false,
    this.itemSize      = 160,
    this.spacing       = 12,
    this.rows          = 15,
    this.columns       = 20,
    this.maxDistance   = 280,
    this.maxScale      = 1.0,
    this.minScale      = 0.55,
    this.maxOpacity    = 1.0,
    this.minOpacity    = 0.35,
    this.onItemTap,
    this.controller,
    this.backgroundColor = Colors.black,
  })  : assert(images.length > 0, 'images bo\'sh bo\'lmasligi kerak'),
        assert(itemSize > 0,      'itemSize musbat bo\'lishi kerak'),
        assert(spacing >= 0,      'spacing manfiy bo\'lmasligi kerak'),
        assert(rows > 0,          'rows musbat bo\'lishi kerak'),
        assert(columns > 0,       'columns musbat bo\'lishi kerak'),
        assert(maxDistance > 0,   'maxDistance musbat bo\'lishi kerak'),
        assert(minScale >= 0 && minScale <= 1, 'minScale 0..1 oralig\'ida bo\'lishi kerak'),
        assert(minOpacity >= 0 && minOpacity <= 1, 'minOpacity 0..1 oralig\'ida bo\'lishi kerak');

  @override
  State<HoneyCombView> createState() => _HoneyCombViewState();
}

class _HoneyCombViewState extends State<HoneyCombView> {
  late final ScrollController _vCtrl;
  late final ScrollController _hCtrl;
  Offset _scrollOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _vCtrl = ScrollController()..addListener(_onScroll);
    _hCtrl = ScrollController()..addListener(_onScroll);

    widget.controller?.attach(_vCtrl, _hCtrl);

    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToCenter());
  }

  void _jumpToCenter() {
    final totalW = widget.columns * (widget.itemSize + widget.spacing);
    final totalH = widget.rows    * (widget.itemSize * 0.866 + widget.spacing);
    final size   = MediaQuery.of(context).size;

    final targetH = ((totalW - size.width)  / 2).clamp(0.0, double.infinity);
    final targetV = ((totalH - size.height) / 2).clamp(0.0, double.infinity);

    if (_hCtrl.hasClients) _hCtrl.jumpTo(targetH);
    if (_vCtrl.hasClients) _vCtrl.jumpTo(targetV);
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _scrollOffset = Offset(
        _hCtrl.hasClients ? _hCtrl.offset : 0,
        _vCtrl.hasClients ? _vCtrl.offset : 0,
      );
    });
  }

  @override
  void didUpdateWidget(HoneyCombView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?.attach(_vCtrl, _hCtrl);
    }
  }

  @override
  void dispose() {
    _vCtrl.dispose();
    _hCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize   = MediaQuery.of(context).size;
    final screenCenter = Offset(screenSize.width / 2, screenSize.height / 2);

    return ColoredBox(
      color: widget.backgroundColor,
      child: SingleChildScrollView(
        controller: _vCtrl,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          controller: _hCtrl,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: _HoneyCombGrid(
            images:        widget.images,
            assetsImage:   widget.assetsImage,
            itemSize:      widget.itemSize,
            spacing:       widget.spacing,
            rows:          widget.rows,
            columns:       widget.columns,
            maxDistance:   widget.maxDistance,
            maxScale:      widget.maxScale,
            minScale:      widget.minScale,
            maxOpacity:    widget.maxOpacity,
            minOpacity:    widget.minOpacity,
            scrollOffset:  _scrollOffset,
            screenCenter:  screenCenter,
            onItemTap:     widget.onItemTap,
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Ichki grid widget (foydalanuvchiga ko'rinmaydi)
// ────────────────────────────────────────────────────────────────
class _HoneyCombGrid extends StatelessWidget {
  final List<String>       images;
  final bool               assetsImage;
  final double             itemSize;
  final double             spacing;
  final int                rows;
  final int                columns;
  final double             maxDistance;
  final double             maxScale;
  final double             minScale;
  final double             maxOpacity;
  final double             minOpacity;
  final Offset             scrollOffset;
  final Offset             screenCenter;
  final ValueChanged<int>? onItemTap;

  const _HoneyCombGrid({
    required this.images,
    required this.assetsImage,
    required this.itemSize,
    required this.spacing,
    required this.rows,
    required this.columns,
    required this.maxDistance,
    required this.maxScale,
    required this.minScale,
    required this.maxOpacity,
    required this.minOpacity,
    required this.scrollOffset,
    required this.screenCenter,
    this.onItemTap,
  });

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// assetsImage flagiga qarab to'g'ri ImageProvider qaytaradi
  ImageProvider _resolveImage(String path) {
    return assetsImage ? AssetImage(path) : NetworkImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final double rowHeight = itemSize * 0.866 + spacing;
    final double colWidth  = itemSize + spacing;
    final double totalW    = columns * colWidth + itemSize / 2;
    final double totalH    = rows    * rowHeight + itemSize / 2;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: Stack(
        children: List.generate(rows * columns, (index) {
          final row = index ~/ columns;
          final col = index %  columns;

          final double offsetX =
              (row % 2 == 0) ? 0.0 : (itemSize + spacing) / 2;

          final double x = col * colWidth  + offsetX   + spacing / 2;
          final double y = row * rowHeight + spacing / 2;

          final double worldX = x - scrollOffset.dx + itemSize / 2;
          final double worldY = y - scrollOffset.dy + itemSize / 2;

          final double dist =
              (Offset(worldX, worldY) - screenCenter).distance;
          final double t =
              (dist / maxDistance).clamp(0.0, 1.0);

          final double scale   = _lerp(maxScale,   minScale,   t);
          final double opacity = _lerp(maxOpacity, minOpacity, t);

          final int imgIndex = (row * columns + col) % images.length;

          return Positioned(
            left: x,
            top:  y,
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: HoneyCombItem(
                  image:    _resolveImage(images[imgIndex]),
                  size:     itemSize,
                  onTap:    onItemTap != null
                      ? () => onItemTap!(imgIndex)
                      : null,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}