import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/default_fields.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// ignore: must_be_immutable
class ObservationTab extends StatefulWidget {
  List<Map<String, dynamic>> observationFields;
  Crop? crop;
  Function() updateState;

  ObservationTab({
    required this.observationFields,
    required this.crop,
    required this.updateState,
    super.key,
  });

  @override
  State<ObservationTab> createState() => _ObservationTabState();
}

class _ObservationTabState extends State<ObservationTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          widget.observationFields[2]['controller'],
          "Observações",
          "Digite aqui",
          maxLines: 3,
          onTextChanged: (value) {
            widget.updateState();
          },
        ),
        DefaultFields(
          crop: widget.crop,
          riskField: widget.observationFields[1]["value"],
          riskFunction: (value) {
            setState(() {
              widget.observationFields[1]["value"] = value;
            });
          },
          fieldLatitude: widget.observationFields[3]["value"],
          fieldLontigude: widget.observationFields[4]["value"],
          fieldMapFunction: (LatLng latLng) {
            setState(() {
              widget.observationFields[3]["value"] = latLng.longitude;
              widget.observationFields[4]["value"] = latLng.latitude;
            });
          },
          fieldImages: widget.observationFields[5]["images"],
          addImage: (image) {
            setState(() {
              widget.observationFields[5]["images"].add(image);
            });
          },
          removeImage: (image) {
            setState(() {
              widget.observationFields[5]["images"].remove(image);
            });
          },
          pathImage: "property_crop_observations",
          changeState: widget.updateState,
        ),
      ],
    );
  }
}
