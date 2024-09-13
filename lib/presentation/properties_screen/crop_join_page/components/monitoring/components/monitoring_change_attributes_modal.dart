import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class MonitoringChangeAttributesModal extends StatefulWidget {
  String date;
  Function(dynamic, String) submitFunction;
  int type;
  int cropJoinId;

  MonitoringChangeAttributesModal(
      {required this.date,
      required this.submitFunction,
      required this.type,
      required this.cropJoinId,
      super.key});

  @override
  State<MonitoringChangeAttributesModal> createState() =>
      _MonitoringChangeAttributesModalState();
}

class _MonitoringChangeAttributesModalState
    extends State<MonitoringChangeAttributesModal> {
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool checkedStage = false;
  bool checkedDiseases = false;
  bool checkedWeeds = false;
  bool checkedPests = false;
  bool checkedObservations = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.type == 1)
            Column(
              children: [
                CustomTextFormField(
                  dateController,
                  "Data nova de monitoramento",
                  "Insira a data",
                  inputType: TextInputType.numberWithOptions(),
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              getOption(checkedStage, "Estádio"),
              getOption(checkedDiseases, "Doenças"),
              getOption(checkedWeeds, 'Daninhas'),
              getOption(checkedPests, 'Pragas'),
              getOption(checkedObservations, 'Observações'),
            ],
          ),
          const SizedBox(height: 20),
          CustomFilledButton(
            text: "Enviar",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _submitForm();
              }
            },
          ),
          const SizedBox(height: 10),
          CustomOutlinedButton(
            text: "Cancelar",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _submitForm() {
    Admin admin = PrefUtils().getAdmin();

    String prefix = widget.type == 1 ? "change_" : "delete_";

    Map<String, dynamic> body = {
      "admin_id": admin.id,
      "_method": "PUT",
      "property_crop_join_id": widget.cropJoinId,
      "date": Formatters.formatDateStringEn(widget.date.replaceAll('-', '/')),
      "${prefix}stage": checkedStage,
      "${prefix}disease": checkedDiseases,
      "${prefix}weed": checkedWeeds,
      "${prefix}pest": checkedPests,
      "${prefix}observation": checkedObservations,
    };

    if (widget.type == 1) {
      body["new_date"] = Formatters.formatDateStringEn(dateController.text);
    }

    final url =
        widget.type == 1 ? ApiRoutes.changeDate : ApiRoutes.deleteMonitoring;

    widget.submitFunction(body, url);
  }

  Widget getOption(bool variable, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          switch (text) {
            case "Estádio":
              checkedStage = !checkedStage;
              break;
            case "Doenças":
              checkedDiseases = !checkedDiseases;
              break;
            case 'Daninhas':
              checkedWeeds = !checkedWeeds;
              break;
            case 'Pragas':
              checkedPests = !checkedPests;
              break;
            case 'Observações':
              checkedObservations = !checkedObservations;
              break;
          }
        });
      },
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    variable ? theme.colorScheme.secondary : appTheme.gray400,
              ),
            ),
            width: 24,
            height: 24,
            margin: EdgeInsets.only(right: 10),
            child: variable
                ? Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                    ),
                  )
                : const SizedBox(),
          ),
          Text(
            text,
            style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: variable ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
