import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/app_bar/crop_filter.dart';
import 'package:fitoagricola/widgets/app_bar/crop_list.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? propertyName;
  final String? cropHarvestName;

  final int? selectedCropJoinId;
  final int? selectedHarvestId;
  final int? selectedPropertyId;

  final int? showButtonCrop;
  final dynamic crops;

  BaseAppBar({
    this.propertyName,
    this.cropHarvestName,
    this.selectedCropJoinId,
    this.selectedHarvestId,
    this.selectedPropertyId,
    this.showButtonCrop = 0,
    this.crops,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: theme.colorScheme.secondary,
        systemNavigationBarColor: theme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      backgroundColor: theme.colorScheme.secondary,
      toolbarHeight: 62,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Container(
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: theme.colorScheme.primary, width: 1),
          ),
        ),
        child: IconButton(
          icon: PhosphorIcon(PhosphorIcons.list()),
          color: appTheme.whiteA70001,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            elevation: 0,
            constraints: const BoxConstraints(
              maxWidth: double.infinity,
            ),
            isScrollControlled: true,
            barrierColor: Colors.white.withOpacity(0),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: CropFilter(
                  key: Key('crop_filter'),
                  selectedCropJoinId: this.selectedCropJoinId ?? null,
                  selectedHarvestId: this.selectedHarvestId ?? null,
                  selectedPropertyId: this.selectedPropertyId ?? null,
                ),
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.propertyName != null
                      ? Text(
                          this.propertyName!.toUpperCase(),
                          style: CustomTextStyles.bodySmallOnWhite,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Container(),
                  Text(
                    this.cropHarvestName ?? 'Encontre uma lavoura',
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.bodyMedium15,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: this.showButtonCrop == 1 ? 0 : 8,
                    left: 8,
                  ),
                  child: PhosphorIcon(
                    PhosphorIcons.caretDown(),
                    color: Colors.white,
                  ),
                ),
                if (this.showButtonCrop == 1)
                  IconButton(
                    icon: PhosphorIcon(IconsList.getIcon('drop-half')),
                    color: appTheme.whiteA70001,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        elevation: 0,
                        constraints: const BoxConstraints(
                          maxWidth: double.infinity,
                        ),
                        isScrollControlled: true,
                        barrierColor: Colors.white.withOpacity(0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: CropList(
                                this.crops ?? [],
                              ));
                        },
                      );
                    },
                  ),
                Container(
                  width: 28,
                  height: 25,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: PhosphorIcon(IconsList.getIcon('bell')),
                    color: appTheme.whiteA70001,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        elevation: 0,
                        constraints: const BoxConstraints(
                          maxWidth: double.infinity,
                        ),
                        isScrollControlled: true,
                        barrierColor: Colors.white.withOpacity(0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: NotificationsList());
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(62); // Altura padrão do AppBar
}
