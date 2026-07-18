// lib/widgets/image_uploader.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'dart:io';

class ImageUploader extends StatelessWidget {
  final File? pickedImage;
  final String? existingImageUrl;
  final Map<String, dynamic>?
      fileMeta;
  final VoidCallback onTapUpload;
  final VoidCallback onClear;

  const ImageUploader({
    super.key,
    required this.pickedImage,
    this.existingImageUrl,
    this.fileMeta,
    required this.onTapUpload,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    bool hasExistingPhoto =
        existingImageUrl != null && existingImageUrl!.isNotEmpty;
    bool showPreview = pickedImage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'EVIDENCE PHOTO',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: context.primary),
            ),
            if (hasExistingPhoto) ...[  
              const SizedBox(width: 6),
              Text(
                '(หากต้องการเปลี่ยนรูปใหม่)',
                style: TextStyle(fontSize: 11, color: context.textSecondary),
              ),
            ]
          ],
        ),
        const SizedBox(height: 6),

        if (!showPreview && hasExistingPhoto) ...[  
          Stack(
            children: [
              GestureDetector(
                onTap: onTapUpload,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderLight, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      existingImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Text('⚠️ ไม่สามารถโหลดรูปภาพเดิมได้'));
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '📸 ภาพปัจจุบันในระบบ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ]
        else if (!showPreview) ...[  
          InkWell(
            onTap: onTapUpload,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.amber.shade50
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.amber.shade300,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('📷', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  Text(
                    'TOUCH TO SCAN / SNAP',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.amber.shade700.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ),
        ]
        else ...[  
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        pickedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: onClear,
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              if (fileMeta != null) ...[  
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 4),
                  child: Text(
                    '${fileMeta!['width']}×${fileMeta!['height']} · ${(fileMeta!['size'] / 1024).toStringAsFixed(1)} KB',
                    style:
                        TextStyle(fontSize: 10, color: context.textSecondary),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
