import 'dart:io';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/file_picker.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/fullscreen_image.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Gallery {
  static Widget getGallery(
      dynamic fieldImages,
      String pathImage,
      dynamic addFunction,
      dynamic removeFunction,
      BuildContext context,
      dynamic changeState) {
    Admin admin = PrefUtils().getAdmin();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return GestureDetector(
                onTap: () {
                  controller.open();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60.h,
                  width: 60.v,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  child: PhosphorIcon(
                    IconsList.getIcon('plus'),
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                ),
              );
            },
            menuChildren: List<MenuItemButton>.generate(
              2,
              (int index) => MenuItemButton(
                onPressed: () => {
                  if (index == 0)
                    {
                      FilePickerComponent.getFileFromGallery().then((images) {
                        if (images != null && images.isNotEmpty) {
                          for (var image in images) {
                            changeState();
                            addFunction(image);
                          }
                        } else {
                          return;
                        }
                      })
                    }
                  else
                    {
                      FilePickerComponent.getFileFromCamera().then((images) {
                        if (images != null) {
                          changeState();
                          addFunction(images);
                        } else {
                          return;
                        }
                      })
                    }
                },
                child: Text(index == 0 ? "Galeria" : "Câmera"),
              ),
            ),
          ),
          for (var image in fieldImages)
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: image is XFile
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                  imageUrl:
                                      "${dotenv.env['IMAGE_URL']}/${pathImage}/${image is GeralImage ? image.image : (image != null && image is Map<String, dynamic> && image.containsKey('image') ? image['image'] : '')}"),
                            ),
                          );
                        },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 60.h,
                    width: 60.v,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: image is XFile
                        ? Image.file(
                            File(image.path),
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : (image is GeralImage
                            ? ImageNetworkComponent.getImageNetwork(
                                "${dotenv.env['IMAGE_URL']}/${pathImage}/${image.image}",
                                60,
                                60,
                                BoxFit.cover,
                              )
                            : (image != null &&
                                    image is Map<String, dynamic> &&
                                    image.containsKey('image')
                                ? ImageNetworkComponent.getImageNetwork(
                                    "${dotenv.env['IMAGE_URL']}/${pathImage}/${image['image']}",
                                    60,
                                    60,
                                    BoxFit.cover,
                                  )
                                : Container())),
                  ),
                ),
                Positioned(
                  top: -10,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (image is XFile) {
                        changeState();
                        removeFunction(image);
                      } else {
                        Dialogs.showDeleteDialog(context,
                            title: "Excluir imagem",
                            text: "Deseja realmente excluir essa imagem?",
                            textButton: "Excluir", onClick: () {
                          DefaultRequest.simplePostRequest(
                                  ApiRoutes.deleteImage,
                                  {
                                    "admin_id": admin.id,
                                    "id": image['id'],
                                    "_method": "PUT",
                                  },
                                  context)
                              .then((value) {
                            if (value) {
                              changeState();
                              removeFunction(image);
                            }
                          });
                        });
                      }
                    },
                    child: Container(
                      height: 25.v,
                      width: 25.h,
                      decoration: BoxDecoration(
                        color: appTheme.red600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: PhosphorIcon(
                          IconsList.getIcon('trash'),
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
