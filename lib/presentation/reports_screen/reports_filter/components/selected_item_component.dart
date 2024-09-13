import 'package:fitoagricola/core/utils/size_utils.dart';
import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SelectedItemComponent extends StatelessWidget {
  const SelectedItemComponent({
    required this.value,
    required this.onItemRemoved,
    super.key,
  });
  final dynamic value;
  final Function(dynamic) onItemRemoved;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemRemoved(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.v, horizontal: 8.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value ?? '',
              style: theme.textTheme.bodySmall!.copyWith(
                color: appTheme.whiteA70001,
              ),
            ),
            const SizedBox(width: 8),
            PhosphorIcon(
              IconsList.getIcon('x'),
              size: 14.v,
              color: appTheme.whiteA70001,
            )
          ],
        ),
      ),
    );
  }
}
