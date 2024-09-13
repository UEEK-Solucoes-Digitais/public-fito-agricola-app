import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/gallery.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/intereference_factor/interference_factor.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/default_fields.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class DiseasesTab extends StatefulWidget {
  List<Map<String, dynamic>> diseasesFields;
  List diseasesImages;
  Crop? crop;
  List<InterferenceFactor> diseasesOptions = [];
  Function() addDisease;
  Function() updateState;

  DiseasesTab({
    required this.diseasesFields,
    required this.crop,
    required this.diseasesImages,
    required this.diseasesOptions,
    required this.addDisease,
    required this.updateState,
    super.key,
  });

  @override
  State<DiseasesTab> createState() => _DiseasesTabState();
}

class _DiseasesTabState extends State<DiseasesTab> {
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
        itemCount: widget.diseasesFields.length,
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
                      items: widget.diseasesOptions.map((e) {
                        return DropdownSearchModel(
                          id: e.id,
                          name:
                              "${e.name}${e.scientificName != '' ? "(${e.scientificName})" : ""}",
                        );
                      }).toList(),
                      label: 'Doença',
                      hintText: 'Selecione',
                      selectedId: widget.diseasesFields[index]
                          ['interference_factors_item_id'],
                      style: 'inline',
                      onChanged: (value) {
                        widget.updateState();
                        setState(() {
                          widget.diseasesFields[index]
                              ['interference_factors_item_id'] = value.id;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      widget.diseasesFields[index]['incidency'],
                      "Incidência (%)",
                      "Digite aqui",
                      inputType: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(casasDecimais: 2),
                      ],
                      onTextChanged: (value) {
                        widget.updateState();
                      },
                    ),
                    DefaultFields(
                      crop: widget.crop,
                      riskField: widget.diseasesFields[index]["risk"],
                      riskFunction: (value) {
                        setState(() {
                          widget.diseasesFields[index]["risk"] = value;
                        });
                      },
                      fieldLatitude: widget.diseasesFields[index]["longitude"],
                      fieldLontigude: widget.diseasesFields[index]["latitude"],
                      fieldMapFunction: (LatLng latLng) {
                        setState(() {
                          widget.diseasesFields[index]["longitude"] =
                              latLng.longitude;
                          widget.diseasesFields[index]["latitude"] =
                              latLng.latitude;
                        });
                      },
                      changeState: widget.updateState,
                    ),
                    if (index == widget.diseasesFields.length - 1)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Gallery.getGallery(
                            widget.diseasesImages,
                            'property_crop_diseases',
                            (image) {
                              setState(() {
                                widget.diseasesImages.add(image);
                              });
                            },
                            (image) {
                              setState(() {
                                widget.diseasesImages.remove(image);
                              });
                            },
                            context,
                            widget.updateState,
                          ),
                        ],
                      )
                  ],
                ),
                // if (widget.diseasesFields.length > 1)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.diseasesFields[index]['id'] != 0) {
                          DefaultRequest.deleteMonitoring(
                            context,
                            widget.diseasesFields[index]['id'],
                            'disease',
                          ).then((value) {
                            widget.updateState();
                            widget.diseasesFields.removeAt(index);
                          });
                        } else {
                          widget.updateState();
                          widget.diseasesFields.removeAt(index);
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
        text: "+ Doença",
        onPressed: () {
          widget.addDisease();
        },
        width: 100,
        height: 30,
      ),
    ]);
  }
}
