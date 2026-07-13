// lib/widgets/asset_search_bar.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';

class AssetSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String placeholder;

    const AssetSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    this.placeholder = 'ค้นหาเลขทรัพย์สิน หรือ ชื่อรายการ...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          ),
        ),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: Icon(Icons.search, color: context.textSecondary),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                16.0), // มุมโค้งมนมนสไตล์ iPad mini (rounded-2xl)
            borderSide: BorderSide(color: context.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: context.surfaceContainerHigh),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
