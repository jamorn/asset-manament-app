// temp_photo_card.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/temp_photo_model.dart';

class TempPhotoCard extends StatelessWidget {
  final TempPhoto tempPhoto;
  final VoidCallback onImageClick;
  final VoidCallback? onAccept;
  final VoidCallback onEdit;
  final Function(String) onDelete;

  const TempPhotoCard({
    Key? key,
    required this.tempPhoto,
    required this.onImageClick,
    this.onAccept,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image
            GestureDetector(
              onTap: onImageClick,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: tempPhoto.photoUrl.isNotEmpty
                    ? Image.network(
                        tempPhoto.photoUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 64, height: 64, color: context.borderLight),
              ),
            ),
            const SizedBox(width: 12),

            // Content Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tempPhoto.tempId,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                  Text(
                    'Ref: ${tempPhoto.referenceAssetNo}',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    tempPhoto.description,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Action Buttons (เทียบเท่าปุ่ม Action ท้ายการ์ด)
            Column(
              children: [
                if (tempPhoto.status == TempPhotoStatus.pending &&
                    onAccept != null)
                  IconButton(
                    icon: const Text('✅', style: TextStyle(fontSize: 14)),
                    onPressed: onAccept,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                IconButton(
                  icon: const Text('✏️', style: TextStyle(fontSize: 14)),
                  onPressed: onEdit,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
                IconButton(
                  icon: const Text('🗑️', style: TextStyle(fontSize: 14)),
                  onPressed: () => onDelete(tempPhoto.tempId),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
