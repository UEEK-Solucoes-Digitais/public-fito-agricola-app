import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/gallery.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/intereference_factor/interference_factor.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/default_fields.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class WeedsTab extends StatefulWidget {
  List<Map<String, dynamic>> weedsFields;
  List weedsImages;
  Crop? crop;
  List<InterferenceFactor> weedsOptions = [];
  Function() addWeed;
  Function() updateState;

  WeedsTab({
    required this.weedsFields,
    required this.crop,
    required this.weedsImages,
    required this.weedsOptions,
    required this.addWeed,
    required this.updateState,
    super.key,
  });

  @override
  State<WeedsTab> createState() => _WeedsTabState();
}

class _WeedsTabState extends State<WeedsTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.weedsFields.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(bottom: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: appTheme.gray300,
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownSearchComponent(
                      // showSearch: false,
                      items: widget.weedsOptions.map((e) {
                        return DropdownSearchModel(
                          id: e.id,
                          name: e.name,
                        );
                      }).toList(),
                      label: 'Daninha',
                      hintText: 'Selecione',
                      selectedId: widget.weedsFields[index]
                          ['interference_factors_item_id'],
                      style: 'inline',
                      onChanged: (value) {
                        widget.updateState();
                        setState(() {
                          widget.weedsFields[index]
                              ['interference_factors_item_id'] = value.id;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DefaultFields(
                      crop: widget.crop,
                      riskField: widget.weedsFields[index]["risk"],
                      riskFunction: (value) {
                        setState(() {
                          widget.weedsFields[index]["risk"] = value;
                        });
                      },
                      fieldLatitude: widget.weedsFields[index]["longitude"],
                      fieldLontigude: widget.weedsFields[index]["latitude"],
                      fieldMapFunction: (LatLng latLng) {
                        setState(() {
                          widget.weedsFields[index]["longitude"] =
                              latLng.longitude;
                          widget.weedsFields[index]["latitude"] =
                              latLng.latitude;
                        });
                      },
                      changeState: widget.updateState,
                    ),
                    if (index == widget.weedsFields.length - 1)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Gallery.getGallery(
                            widget.weedsImages,
                            'property_crop_weeds',
                            (image) {
                              setState(() {
                                widget.weedsImages.add(image);
                              });
                            },
                            (image) {
                              setState(() {
                                widget.weedsImages.remove(image);
                              });
                            },
                            context,
                            widget.updateState,
                          ),
                        ],
                      )
                  ],
                ),
                // if (widget.weedsFields.length > 1)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.weedsFields[index]['id'] != 0) {
                          DefaultRequest.deleteMonitoring(
                            context,
                            widget.weedsFields[index]['id'],
                            'weed',
                          ).then((value) {
                            widget.weedsFields.removeAt(index);
                          });
                        } else {
                          widget.weedsFields.removeAt(index);
                        }
                      });
                    },
                    child: Container(
                      height: 25,
                      width: 25,
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
          );
        },
      ),
      CustomElevatedButton(
        text: "+ Daninha",
        onPressed: () {
          widget.addWeed();
        },
        width: 100,
        height: 30,
      ),
    ]);
  }
}
