import 'package:flutter/material.dart';

class CollapsableItem extends StatelessWidget {
  const CollapsableItem({
    required this.child,
    this.hasTopBorder = false,
    super.key,
  });

  final Widget child;
  final bool hasTopBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.grey,
          ),
          top: hasTopBorder
              ? BorderSide(
                  width: 1.0,
                  color: Colors.grey,
                )
              : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: child,
    );
  }
}
