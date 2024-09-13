import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/fullscreen_image.dart';
import 'package:fitoagricola/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomBadge {
  static Widget getDefaultBadge(
    int level, {
    String? text = '',
    List<GeralImage>? images,
    String? path,
    String? textToShow,
    BuildContext? context,
  }) {
    Color color = appTheme.green400;
    String textFinal = text != '' && text != null ? text : 'Sem risco';

    switch (level) {
      case 2:
        color = appTheme.amber500;
        textFinal = text != '' && text != null ? text : 'Atenção';
        break;
      case 3:
        color = appTheme.red600;
        textFinal = text != '' && text != null ? text : 'Urgência';
        break;
    }

    Widget container = Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        textFinal,
        // softWrap: true,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );

    return (images != null && images.isNotEmpty) || textToShow != null
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 17, right: 17, left: textFinal.length < 5 ? 17 : 0),
                  child: container,
                ),
                onTap: () {
                  _openModal(context, images, path, textToShow);
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: [
                    if (textToShow != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: CustomActionButton(
                          icon: 'clipboard-text',
                          backgroundColor: appTheme.amber500,
                          onTap: () {
                            _openModal(context, images, path, textToShow);
                          },
                          height: 30,
                          width: 30,
                          iconSize: 15,
                        ),
                      ),
                    if (images != null && images.isNotEmpty)
                      CustomActionButton(
                        icon: 'images',
                        onTap: () {
                          _openModal(context, images, path, textToShow);
                        },
                        height: 30,
                        width: 30,
                        iconSize: 15,
                      ),
                  ],
                ),
              )
            ],
          )
        : container;
  }

  static _openModal(BuildContext? context, List<GeralImage>? images,
      String? path, String? textToShow) {
    Dialogs.showGeralDialog(context!,
        title: "Visualizar informações",
        text: textToShow ?? '',
        widget: images != null && images.isNotEmpty
            ? Container(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                  imageUrl:
                                      "${dotenv.env['IMAGE_URL']}/${path}/${images[index].image}"),
                            ),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: ImageNetworkComponent.getImageNetwork(
                              "${dotenv.env['IMAGE_URL']}/${path}/${images[index].image}",
                              140,
                              140,
                              BoxFit.cover,
                            )),
                      ),
                    );
                  },
                ),
              )
            : Container());
  }
}
