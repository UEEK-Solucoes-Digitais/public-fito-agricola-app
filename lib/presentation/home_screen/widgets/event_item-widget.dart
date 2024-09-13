import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/event_item_model.dart';
import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';

// ignore: must_be_immutable
class EventItemWidget extends StatelessWidget {
  EventItemWidget(
    this.eventItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  EventItemModel eventItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 1.h),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "lbl_pr_ximo_evento".tr,
              style: CustomTextStyles.labelLargeSemiBold,
            ),
          ),
        ),
        SizedBox(height: 15.v),
        CustomImageView(
          imagePath: eventItemModelObj.image,
          height: 150.v,
          width: 315.h,
          fit: BoxFit.fill,
          radius: BorderRadius.circular(
            10.h,
          ),
          margin: EdgeInsets.only(left: 1.h),
        ),
        SizedBox(height: 12.v),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventItemModelObj.name!,
                    style: CustomTextStyles.titleSmallOnPrimary,
                  ),
                  SizedBox(height: 6.v),
                  SizedBox(
                    width: 197.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.mapPin(),
                              size: 15,
                              color: theme.colorScheme.primary,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                eventItemModelObj.location!,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.calendarBlank(),
                              size: 15,
                              color: theme.colorScheme.primary,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                eventItemModelObj.date!,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 12.v,
                  bottom: 5.v,
                ),
                child: PhosphorIcon(
                  PhosphorIcons.arrowRight(),
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
