import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/grid_item_model.dart';
import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';

// ignore: must_be_immutable
class GridItemWidget extends StatelessWidget {
  GridItemWidget(
    this.gridItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  GridItemModel gridItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.h),
      decoration: AppDecoration.fillBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 13.v),
          PhosphorIcon(
            gridItemModelObj.categoryImg!,
            size: 46.0,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 18.v),
          Text(
            gridItemModelObj.category!,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
