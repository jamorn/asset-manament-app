import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'package:provider/provider.dart';
import '../models/temp_photo_model.dart';
import '../providers/temp_photo_provider.dart';
import 'temp_photo_card.dart';
import 'temp_photo_edit_form.dart';
import 'temp_photo_accept_modal.dart';

/// Composite Panel สำหรับจัดการ Temp Photos
///
/// พอร์ตจาก TempPhotoPanel ใน app/components/temp/TempPhotoPanel.tsx
/// รวม: รายการ Temp Photo + ปุ่มเพิ่ม + accept/edit/delete
class TempPhotoPanel extends StatelessWidget {
  const TempPhotoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tempProv = context.watch<TempPhotoProvider>();

    // Reference assets ที่ผ่าน RBAC filter
    // (ใช้ visibleTempPhotos เพื่อไม่ต้อง filter temp ซ้ำ)
    final visiblePhotos = tempProv.visibleTempPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Header ----
        Row(
          children: [
            const Text('📸 Temp Photos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${visiblePhotos.length}',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800]),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _showAddForm(context),
              icon: const Icon(Icons.add_a_photo, size: 16),
              label: const Text('เพิ่ม'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ---- Loading ----
        if (tempProv.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )

        // ---- Empty state ----
        else if (visiblePhotos.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: context.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.surfaceContainerHigh),
            ),
            child: Column(
              children: [
                Icon(Icons.photo_library_outlined,
                    size: 48, color: context.textSecondary),
                const SizedBox(height: 8),
                Text('ยังไม่มี Temp Photo',
                    style: TextStyle(color: context.textSecondary)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddForm(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('เพิ่ม Temp Photo แรก'),
                ),
              ],
            ),
          )

        // ---- List ----
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visiblePhotos.length,
            itemBuilder: (context, index) {
              final tp = visiblePhotos[index];
              return TempPhotoCard(
                tempPhoto: tp,
                onImageClick: () => _showImageModal(context, tp.photoUrl),
                onAccept: tp.status == TempPhotoStatus.pending
                    ? () => _showAcceptModal(context, tp)
                    : null,
                onEdit: () => _showEditForm(context, tp),
                onDelete: (id) => _confirmDelete(context, tempProv, id),
              );
            },
          ),
      ],
    );
  }

  // ==================================================================
  // Actions
  // ==================================================================

  void _showAddForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: TempPhotoEditForm(
              existing: null,
              onSaved: () {
                // refresh เมื่อ save สำเร็จ
                context.read<TempPhotoProvider>().refresh();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showEditForm(BuildContext context, TempPhoto tp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: TempPhotoEditForm(
              existing: tp,
              onSaved: () {
                context.read<TempPhotoProvider>().refresh();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showAcceptModal(BuildContext context, TempPhoto tp) {
    showTempPhotoAcceptModal(
      context: context,
      tempPhoto: tp,
      onAcceptSubmit: (newAssetNo) async {
        final prov = context.read<TempPhotoProvider>();
        return prov.acceptTempPhotoAsAsset(
            tempId: tp.tempId, newAssetNo: newAssetNo);
      },
    );
  }

  void _showImageModal(BuildContext context, String url) {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
          backgroundColor: Colors.black87,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.network(url, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 2 * 3.14159, // หมุน 360°
                      child: child,
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, TempPhotoProvider prov, String tempId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบ Temp Photo นี้ใช่หรือไม่?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('ยกเลิก')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('ลบ', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      final ok = await prov.deleteTempPhoto(tempId);
      if (ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ ลบ Temp Photo แล้ว')),
        );
      }
    }
  }
}
