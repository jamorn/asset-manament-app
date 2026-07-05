// lib/widgets/load_more_list.dart
import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import 'asset_table_list.dart';

class LoadMoreList extends StatefulWidget {
  final List<AssetModel> assets;
  final String? selectedAssetNo;
  final ValueChanged<AssetModel> onSelect;
  final ValueChanged<String> onImageClick;
  final Set<String> auditedSet;
  final int pageSize;

  const LoadMoreList({
    Key? key,
    required this.assets,
    required this.selectedAssetNo,
    required this.onSelect,
    required this.onImageClick,
    required this.auditedSet,
    required this.pageSize,
  }) : super(key: key);

  @override
  State<LoadMoreList> createState() => _LoadMoreListState();
}

class _LoadMoreListState extends State<LoadMoreList> {
  late int _visibleCount;

  @override
  void initState() {
    super.initState();
    _visibleCount = widget.pageSize;
  }

  @override
  void didUpdateWidget(covariant LoadMoreList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assets != widget.assets) {
      setState(() {
        _visibleCount = widget.pageSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int endRange = _visibleCount < widget.assets.length
        ? _visibleCount
        : widget.assets.length;
    final List<AssetModel> visibleAssets = widget.assets.sublist(0, endRange);
    final bool hasMore = _visibleCount < widget.assets.length;
    final int remaining = widget.assets.length - _visibleCount;

    return Column(
      mainAxisSize: MainAxisSize.min, // 🟢 สำคัญ!
      children: [
        // ❌ เอา Expanded + SingleChildScrollView ออก
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              child: AssetTableList(
                assets: visibleAssets,
                selectedAssetNo: widget.selectedAssetNo,
                onSelect: widget.onSelect,
                onImageClick: widget.onImageClick,
                auditedSet: widget.auditedSet,
              ),
            ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    _visibleCount += widget.pageSize;
                  });
                },
                child: Text(
                  'LOAD MORE ($remaining REMAINING)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13,
                ),
              ),
            ),
          ),
          ),
      ],
    );
  }
}