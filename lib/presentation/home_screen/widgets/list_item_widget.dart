import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:dotted_line/dotted_line.dart';
import '../models/list_item_model.dart';
import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class ListItemWidget extends StatelessWidget {
  ListItemWidget(
    this.listItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  ListItemModel listItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 19.h,
        vertical: 13.v,
      ),
      decoration: AppDecoration.fillBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 4.v),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 4.v,
                  bottom: 1.v,
                ),
                child: CustomIconButton(
                  height: 36.adaptSize,
                  width: 36.adaptSize,
                  padding: EdgeInsets.all(7.h),
                  child: PhosphorIcon(
                    listItemModelObj.icon!,
                    size: 20,
                    color: Colors.white,
                  ),
                  status: listItemModelObj.status,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 13.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 200,
                        child: Text(
                          listItemModelObj.title!,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        PhosphorIcon(
                          PhosphorIcons.mapPin(),
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.h),
                          child: Container(
                            width: 100,
                            child: Text(
                              listItemModelObj.description!,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.v),
          DottedLine(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: Color(0xffb2d1e7),
            dashGapLength: 4.0,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
          SizedBox(height: 10.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: Row(
              children: [
                PhosphorIcon(
                  listItemModelObj.iconStatus!,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    listItemModelObj.status!,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Spacer(),
                Text(
                  listItemModelObj.dateText!,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
