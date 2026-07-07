import 'package:flutter/material.dart';

/// แสดง Modal รูปขนาดใหญ่
///
/// รองรับ:
/// - iPad / iPhone ทุกขนาด (แนวตั้ง/แนวนอน)
/// - InteractiveViewer ซูมได้
/// - ปุ่ม X สีแดง + หมุน 360°
/// - กดพื้นที่ว่างเพื่อปิด
void showImageModal(BuildContext context, String url) {
  if (url.isEmpty) return;

  final isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;
  final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

  showDialog(
    context: context,
    builder: (_) => GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Stack(
            children: [
              // รูปหลัก — ซูมได้, ปรับขนาดตามอุปกรณ์
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    // จำกัดขนาดสูงสุดตามอุปกรณ์
                    width: isTablet
                        ? (isLandscape ? 600 : 500)
                        : (isLandscape ? 400 : double.infinity),
                    height: isTablet
                        ? (isLandscape ? double.infinity : 400)
                        : (isLandscape ? double.infinity : 300),
                    errorBuilder: (_, __, ___) => const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image,
                            size: 48, color: Colors.white54),
                        SizedBox(height: 8),
                        Text('ไม่สามารถโหลดรูปได้',
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                ),
              ),

              // ปุ่ม X มุมขวาบน — หมุน 360°
              Positioned(
                top: 8,
                right: 8,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 2 * 3.14159,
                      child: child,
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
