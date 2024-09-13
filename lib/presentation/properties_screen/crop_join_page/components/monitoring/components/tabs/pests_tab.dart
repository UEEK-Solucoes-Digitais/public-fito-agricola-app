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
class PestsTab extends StatefulWidget {
  List<Map<String, dynamic>> pestsFields;
  List pestsImages;
  Crop? crop;
  List<InterferenceFactor> pestsOptions = [];
  Function() addPest;
  Function() updateState;

  PestsTab({
    required this.pestsFields,
    required this.crop,
    required this.pestsImages,
    required this.pestsOptions,
    required this.addPest,
    required this.updateState,
    super.key,
  });

  @override
  State<PestsTab> createState() => _PestsTabState();
}

class _PestsTabState extends State<PestsTab> {
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
        itemCount: widget.pestsFields.length,
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
                      items: widget.pestsOptions.map((e) {
                        return DropdownSearchModel(
                          id: e.id,
                          name:
                              "${e.name}${e.scientificName != '' ? "(${e.scientificName})" : ""}",
                        );
                      }).toList(),
                      label: 'Praga',
                      hintText: 'Selecione',
                      selectedId: widget.pestsFields[index]
                          ['interference_factors_item_id'],
                      style: 'inline',
                      onChanged: (value) {
                        widget.updateState();
                        setState(() {
                          widget.pestsFields[index]
                              ['interference_factors_item_id'] = value.id;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      widget.pestsFields[index]['incidency'],
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            widget.pestsFields[index]['quantity_per_meter'],
                            "Qtd/m",
                            "Digite aqui",
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CentavosInputFormatter(casasDecimais: 2),
                            ],
                            onTextChanged: (value) {
                              widget.updateState();
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomTextFormField(
                            widget.pestsFields[index]
                                ['quantity_per_square_meter'],
                            "Qtd/m²",
                            "Digite aqui",
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CentavosInputFormatter(casasDecimais: 2),
                            ],
                            onTextChanged: (value) {
                              widget.updateState();
                            },
                          ),
                        ),
                      ],
                    ),
                    DefaultFields(
                      crop: widget.crop,
                      riskField: widget.pestsFields[index]["risk"],
                      riskFunction: (value) {
                        setState(() {
                          widget.pestsFields[index]["risk"] = value;
                        });
                      },
                      fieldLatitude: widget.pestsFields[index]["longitude"],
                      fieldLontigude: widget.pestsFields[index]["latitude"],
                      fieldMapFunction: (LatLng latLng) {
                        setState(() {
                          widget.pestsFields[index]["longitude"] =
                              latLng.longitude;
                          widget.pestsFields[index]["latitude"] =
                              latLng.latitude;
                        });
                      },
                      changeState: widget.updateState,
                    ),
                    if (index == widget.pestsFields.length - 1)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Gallery.getGallery(
                            widget.pestsImages,
                            'property_crop_pests',
                            (image) {
                              setState(() {
                                widget.pestsImages.add(image);
                              });
                            },
                            (image) {
                              setState(() {
                                widget.pestsImages.remove(image);
                              });
                            },
                            context,
                            widget.updateState,
                          ),
                        ],
                      )
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.pestsFields[index]['id'] != 0) {
                        DefaultRequest.deleteMonitoring(
                          context,
                          widget.pestsFields[index]['id'],
                          'pest',
                        ).then((value) {
                          setState(() {
                            widget.pestsFields.removeAt(index);
                          });
                        });
                      } else {
                        setState(() {
                          widget.pestsFields.removeAt(index);
                        });
                      }
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
        text: "+ Praga",
        onPressed: () {
          widget.addPest();
        },
        width: 100,
        height: 30,
      ),
    ]);
  }
}
