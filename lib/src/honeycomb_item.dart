import 'package:flutter/material.dart';

/// Honeycomb grid ichidagi har bir aylana element.
///
/// [imageUrl] — network rasm manzili.
/// [size]     — element diametri (px).
/// [onTap]    — bosilganda chaqiriladigan callback.
///
/// ```dart
/// HoneyCombItem(
///   imageUrl: 'https://example.com/photo.jpg',
///   size: 160,
///   onTap: () => print('tapped'),
/// )
/// ```
class HoneyCombItem extends StatelessWidget {
  /// Rasm URL manzili.
  final String imageUrl;

  /// Element diametri.
  final double size;

  /// Bosilganda chaqiriladi (ixtiyoriy).
  final VoidCallback? onTap;

  /// Chegara rangi. Default: [Colors.white12].
  final Color borderColor;

  /// Chegara qalinligi. Default: `1.5`.
  final double borderWidth;

  const HoneyCombItem({
    super.key,
    required this.imageUrl,
    required this.size,
    this.onTap,
    this.borderColor = Colors.white12,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 8, spreadRadius: 2),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: Colors.grey[850],
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Colors.white30,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[900],
              child: const Icon(Icons.person, color: Colors.white24, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}