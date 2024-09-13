import 'package:flutter/material.dart';

class SelectedItemList extends StatefulWidget {
  const SelectedItemList({
    required this.itemList,
    super.key,
  });

  final List<Widget> itemList;

  @override
  State<SelectedItemList> createState() => _SelectedItemListState();
}

class _SelectedItemListState extends State<SelectedItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 6,
        runSpacing: 6,
        children: widget.itemList,
      ),
    );
  }
}
