import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/gallery.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/widgets/custom_badge.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/map_crop/map_crop_native.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class DefaultFields extends StatefulWidget {
  dynamic riskField;
  dynamic riskFunction;
  dynamic fieldLontigude;
  dynamic fieldLatitude;
  dynamic fieldMapFunction;
  dynamic fieldImages;
  dynamic addImage;
  dynamic removeImage;
  dynamic pathImage;
  dynamic changeState;
  Crop? crop;

  DefaultFields({
    required this.crop,
    required this.riskField,
    required this.riskFunction,
    required this.fieldLatitude,
    required this.fieldLontigude,
    required this.fieldMapFunction,
    required this.changeState,
    this.fieldImages,
    this.addImage,
    this.removeImage,
    this.pathImage,
    super.key,
  });

  @override
  State<DefaultFields> createState() => _DefaultFieldsState();
}

class _DefaultFieldsState extends State<DefaultFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.changeState();
                widget.riskFunction(1);
              },
              child: AnimatedOpacity(
                opacity: widget.riskField == 1 ? 1 : 0.4,
                duration: const Duration(milliseconds: 100),
                child: CustomBadge.getDefaultBadge(1),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                widget.changeState();
                widget.riskFunction(2);
              },
              child: AnimatedOpacity(
                opacity: widget.riskField == 2 ? 1 : 0.4,
                duration: const Duration(milliseconds: 100),
                child: CustomBadge.getDefaultBadge(2),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                widget.changeState();
                widget.riskFunction(3);
              },
              child: AnimatedOpacity(
                opacity: widget.riskField == 3 ? 1 : 0.4,
                duration: const Duration(milliseconds: 100),
                child: CustomBadge.getDefaultBadge(3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (widget.crop != null)
          Row(
            children: [
              IconButton(
                tooltip: "Selecionar localização",
                onPressed: () {
                  Dialogs.showGeralDialog(
                    context,
                    title: "Inserir localização",
                    text:
                        "Aperte no mapa para inserir o marcador e após isso feche esse modal.",
                    widget: Container(
                      height: 400,
                      child: MapCropNative(
                        crops: [widget.crop],
                        showRegisterMenu: false,
                        showList: false,
                        tapAction: false,
                        monitoringFunction: (LatLng latLng) {
                          widget.changeState();
                          widget.fieldMapFunction(latLng);
                        },
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                icon: PhosphorIcon(
                  IconsList.getIcon('globe-hemisphere-west'),
                  size: 22,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 10),
              if (widget.fieldLontigude != 0 && widget.fieldLatitude != 0)
                Text(
                  "Lat: ${widget.fieldLatitude}\nLong: ${widget.fieldLontigude}",
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
        if (widget.fieldImages != null)
          Gallery.getGallery(
            widget.fieldImages,
            widget.pathImage,
            widget.addImage,
            widget.removeImage,
            context,
            widget.changeState,
          ),
      ],
    );
  }
}
