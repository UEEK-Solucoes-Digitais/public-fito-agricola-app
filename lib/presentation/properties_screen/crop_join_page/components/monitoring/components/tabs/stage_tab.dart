import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/default_fields.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// ignore: must_be_immutable
class StageTab extends StatefulWidget {
  List<Map<String, dynamic>> stageFields;
  Crop? crop;
  Function() updateState;

  StageTab(
      {required this.stageFields,
      required this.crop,
      required this.updateState,
      super.key});

  @override
  State<StageTab> createState() => _StageTabState();
}

class _StageTabState extends State<StageTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List vegetativeArray = [];
    for (var i = 0; i <= 25; i++) {
      vegetativeArray.add(i);
    }

    List reprodutiveArray = [1, 2, 3, 4, 5, 5.1, 5.2, 5.3, 5.4, 5.5, 6, 7, 8];
    for (var i = 0; i <= 8; i++) {
      reprodutiveArray.add(i);

      if (i == 5) {
        reprodutiveArray.add(5.1);
        reprodutiveArray.add(5.2);
        reprodutiveArray.add(5.3);
        reprodutiveArray.add(5.4);
        reprodutiveArray.add(5.5);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Idade vegetativa",
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: Color(0xFF152536),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 80,
                  child: DropdownSearchComponent(
                    showSearch: false,
                    items: vegetativeArray.map((e) {
                      return DropdownSearchModel(
                        id: e,
                        name: "${e <= 9 ? '0' : ''}${e.toString()}",
                      );
                    }).toList(),
                    label: '',
                    hintText: 'Selecione',
                    selectedId: widget.stageFields[2]['value'],
                    style: 'inline',
                    validatorFunction: false,
                    onChanged: (value) {
                      widget.updateState();
                      setState(() {
                        widget.stageFields[2]['value'] = value.id;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    widget.stageFields[3]['controller'],
                    "",
                    "Digite aqui",
                    onTextChanged: (value) {
                      widget.updateState();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Idade reprodutiva",
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: Color(0xFF152536),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 80,
                  child: DropdownSearchComponent(
                    showSearch: false,
                    items: reprodutiveArray.map((e) {
                      return DropdownSearchModel(
                        id: e,
                        name: "${e <= 9 ? '0' : ''}${e.toString()}",
                      );
                    }).toList(),
                    label: '',
                    hintText: 'Selecione',
                    selectedId: widget.stageFields[4]['value'],
                    style: 'inline',
                    validatorFunction: false,
                    onChanged: (value) {
                      widget.updateState();

                      setState(() {
                        widget.stageFields[4]['value'] = value.id;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    widget.stageFields[5]['controller'],
                    "",
                    "Digite aqui",
                    onTextChanged: (value) {
                      widget.updateState();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        DefaultFields(
          crop: widget.crop,
          riskField: widget.stageFields[1]["value"],
          riskFunction: (value) {
            setState(() {
              widget.stageFields[1]["value"] = value;
            });
          },
          fieldLatitude: widget.stageFields[6]["value"],
          fieldLontigude: widget.stageFields[7]["value"],
          fieldMapFunction: (LatLng latLng) {
            setState(() {
              widget.stageFields[6]["value"] = latLng.longitude;
              widget.stageFields[7]["value"] = latLng.latitude;
            });
          },
          fieldImages: widget.stageFields[8]["images"],
          addImage: (image) {
            setState(() {
              widget.stageFields[8]["images"].add(image);
            });
          },
          removeImage: (image) {
            setState(() {
              widget.stageFields[8]["images"].remove(image);
            });
          },
          pathImage: "property_crop_stages",
          changeState: widget.updateState,
        ),
      ],
    );
  }
}
