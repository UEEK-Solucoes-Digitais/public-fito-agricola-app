import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/content/content.dart';
import 'package:fitoagricola/data/models/notifications/notification.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({super.key});

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  List<Map<String, List<Map<String, List<NotificationItem>>>>> notifications =
      [];
  List<NotificationItem> notificationsContents = [];
  bool isLoading = true;
  int notificationTab = 1;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.89,
      child: Container(
        height: double.infinity,
        // padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: isLoading
            ? DefaultCircularIndicator.getIndicator()
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 30, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PhosphorIcon(
                              IconsList.getIcon('bell'),
                              size: 20,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Notificações",
                              style: theme.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          color: appTheme.gray400,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              _buildButton(1, "Lançamentos", 130.h),
                              const SizedBox(width: 5),
                              _buildButton(2, "Comentários", 130.h),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        notificationTab == 1
                            ? _buildDataNotifications()
                            : _buildCommentNotifications(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _buildDataNotifications() {
    if (notifications.isEmpty)
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: Text(
            "Nenhuma notificação encontrada",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );

    return Expanded(
      child: ListView.builder(
        itemCount: notifications.length,
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final notificationDate = notifications[index];

          return ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            title: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateText(notificationDate),
                  for (var notificationCropGroup in notificationDate.values)
                    for (var notificationCrop in notificationCropGroup)
                      _buildNotificationGroup(
                          notificationCrop, notificationCropGroup)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildCommentNotifications() {
    if (notificationsContents.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: Text(
            "Nenhuma notificação encontrada",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: notificationsContents.length,
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final notification = notificationsContents[index];

          return ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.publicationListPage,
                arguments: {
                  'publicationId': notification.objectId,
                  'contentType': notification.contentType,
                },
              );
            },
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            title: Container(
              padding: EdgeInsets.only(top: 5, bottom: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: appTheme.gray300,
                  ),
                ),
              ),
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 10),
                        width: 38,
                        height: 38,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: appTheme.gray400,
                        ),
                        child: notification.adminResponsable!.profilePicture !=
                                    null &&
                                notification.adminResponsable!.profilePicture !=
                                    ''
                            ? ImageNetworkComponent.getImageNetwork(
                                "${dotenv.env['IMAGE_URL']}/admins/${notification.adminResponsable!.profilePicture}",
                                double.infinity,
                                double.infinity,
                                BoxFit.cover,
                              )
                            : Text(
                                notification.adminResponsable!.name[0],
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      if (notification.isRead == 0)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              color: appTheme.amber400,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: notification.adminResponsable!.name
                                          .split(' ')[0],
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: SizedBox(width: 4),
                                    ),
                                    TextSpan(
                                      text: notification.contentInteraction == 1
                                          ? "respondeu um comentário"
                                          : (notification.contentInteraction ==
                                                  2
                                              ? "fez um comentário"
                                              : "curtiu seu comentário"),
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: appTheme.gray400,
                                        fontSize: 13,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: notification.contentText != '' ? 10 : 4,
                        ),
                        if (notification.content != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (notification.contentText != '')
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xFFEBEBEB),
                                        ),
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          notification.contentText,
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                            fontSize: 12,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                    Text(
                                      notification.createdAt,
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: appTheme.gray400,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ImageNetworkComponent.getImageNetwork(
                                  "${dotenv.env['IMAGE_URL']}/contents/${_getImage(
                                    notification.content!.courseCover,
                                    notification.content!,
                                  )}",
                                  double.infinity,
                                  double.infinity,
                                  BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildDateText(notificationDate) {
    return Text(
      notificationDate.keys.first,
      style: theme.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  _buildNotificationGroup(Map<String, List<NotificationItem>> notificationCrop,
      List<Map<String, List<NotificationItem>>> notificationCropGroup) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notificationCrop.keys.first,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var notification in notificationCrop.values.first)
                  GestureDetector(
                    onTap: () {
                      if (notification.type == "monitoring") {
                        Navigator.of(context).pushNamed(
                          AppRoutes.cropJoinPage,
                          arguments: {
                            'cropJoinId': notification.objectId,
                            'page': 'monitoring',
                          },
                        );
                      } else if (notification.type == "management-data") {
                        Navigator.of(context).pushNamed(
                          AppRoutes.cropJoinPage,
                          arguments: {
                            'cropJoinId': notification.objectId,
                            'page': 'management-data',
                            'pageSubType': notification.subtype,
                          },
                        );
                      } else if (notification.type == "informations") {
                        Navigator.of(context).pushNamed(
                          AppRoutes.cropJoinPage,
                          arguments: {
                            'cropJoinId': notification.objectId,
                            'page': 'informations',
                          },
                        );
                      } else if (notification.type == "contents") {
                        Navigator.of(context).pushNamed(
                          AppRoutes.publicationListPage,
                          arguments: {
                            'publicationId': notification.objectId,
                            'contentType': notification.contentType,
                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(235, 235, 235, 1),
                        border: !_isLast(notificationCrop, notification)
                            ? null
                            : Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(215, 215, 215, 1),
                                ),
                              ),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 9,
                              color: notification.level != 0
                                  ? _getColor(notification.level)
                                  : appTheme.gray300,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  right: 5,
                                  left: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getText(notification.title,
                                          notification.type),
                                      style:
                                          theme.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (notification.adminResponsable != null)
                                      Text(
                                        notification.adminResponsable!.name,
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: appTheme.gray400),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getText(String text, String notificationType) {
    if (notificationType == 'contents') {
      return text;
    } else {
      // pegar sempre o ultimo item do split por '-', exceto no notificationType 'informations' que deve pegar o ultimo e o penultimo
      final splitText = text.split('-');

      if (notificationType == 'informations') {
        if (splitText.length > 3) {
          return splitText[splitText.length - 2].trim() +
              ' - ' +
              splitText.last.trim();
        } else {
          return splitText[0].trim() + ' - ' + splitText[1].trim();
        }
      } else {
        if (splitText.length > 2) {
          return splitText.last.trim();
        } else {
          return splitText[0];
        }
      }
    }
  }

  _isLast(notificationGroup, notification) {
    return notificationGroup.values.first
            .indexWhere((item) => item.id == notification.id) !=
        notificationGroup.values.first.length - 1;
  }

  _getColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return const Color.fromARGB(255, 255, 17, 0);
      default:
        return Colors.green;
    }
  }

  _getNotifications() {
    Admin admin = PrefUtils().getAdmin();
    print("${ApiRoutes.listNotifications}/${admin.id}");

    DefaultRequest.simpleGetRequest(
            "${ApiRoutes.listNotifications}/${admin.id}", context,
            showSnackBar: 0)
        .then((value) {
      final data = jsonDecode(value.body);

      if (data['notifications'] != null && data['length'] > 0) {
        // notifications = NotificationItem.fromJsonList(data['notifications']);
        Map<String, dynamic> notificationsLoop = data['notifications'];

        notificationsLoop.forEach((key, value) {
          List<Map<String, List<NotificationItem>>> items = [];
          value.forEach((keyCrop, element) {
            items.add({keyCrop: NotificationItem.fromJsonList(element)});
          });

          notifications.add({key: items});

          // notifications.add({key: NotificationItem.fromJsonList(value)});
        });
      }
      if (data['notifications_contents'] != null) {
        notificationsContents =
            NotificationItem.fromJsonList(data['notifications_contents']);
      }
      isLoading = false;
      setState(() {});
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  _buildButton(int tab, String text, double width) {
    return tab == notificationTab
        ? CustomFilledButton(
            text: text,
            onPressed: () => _setNotificationTab(tab),
            width: width,
            height: 40.h,
          )
        : CustomOutlinedButton(
            text: text,
            onPressed: () => _setNotificationTab(tab),
            width: width,
            height: 40.h,
          );
  }

  _setNotificationTab(int tab) {
    notificationTab = tab;
    setState(() {});
  }

  _getImage(String? image, Content content) {
    if (image != null && image != '') {
      return image;
    } else {
      if (content.image != '') {
        return content.image;
      } else if (content.courseCover != '') {
        return content.courseCover;
      } else if (content.mostWatchedCover != '') {
        return content.mostWatchedCover;
      } else {
        return '';
      }
    }
  }
}
