// lib/widgets/asset_search_bar.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';

class AssetSearchBar extends StatefulWidget {
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
  State<AssetSearchBar> createState() => _AssetSearchBarState();
}

class _AssetSearchBarState extends State<AssetSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(() {
      if (_controller.text != widget.value) {
        widget.onChanged(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant AssetSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: _controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          prefixIcon: Icon(Icons.search, color: context.textSecondary),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
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
