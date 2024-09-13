import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class RainGaugeAddModal extends StatefulWidget {
  int cropJoinId;
  Function() reloadItens;

  RainGaugeAddModal(
      {required this.cropJoinId, required this.reloadItens, super.key});

  @override
  State<RainGaugeAddModal> createState() => _RainGaugeAddModalState();
}

class _RainGaugeAddModalState extends State<RainGaugeAddModal> {
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  List<Map<String, dynamic>> rainGauges = [
    {"volume": 0, "date": ""},
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      initFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var rainGauge in rainGauges)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              rainGauge['date'],
                              "Data",
                              'Digite aqui',
                              inputType: TextInputType.numberWithOptions(),
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                DataInputFormatter(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              rainGauge['volume'],
                              "Volume",
                              'Digite aqui',
                              inputType: TextInputType.number,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CentavosInputFormatter(casasDecimais: 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -10,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: appTheme.red600,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: PhosphorIcon(
                              IconsList.getIcon('trash'),
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              rainGauges.remove(rainGauge);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      rainGauges.add({
                        "volume": TextEditingController(),
                        "date": TextEditingController(
                          text: Formatters.formatDateString(
                              DateTime.now().toString().split(" ")[0]),
                        )
                      });
                    });
                  },
                  child: Text(
                    "+ Adicionar registro",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomFilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitForm();
                    }
                  },
                  text: "Enviar",
                  isDisabled: isSubmitting,
                ),
                const SizedBox(height: 10),
                CustomOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Cancelar",
                  isDisabled: isSubmitting,
                )
              ],
            ),
          );
  }

  initFields() async {
    for (var rainGauge in rainGauges) {
      rainGauge['volume'] = TextEditingController();
      rainGauge['date'] = TextEditingController(
        text: Formatters.formatDateString(
            DateTime.now().toString().split(" ")[0]),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  submitForm() {
    setState(() {
      isSubmitting = true;
    });
    Admin admin = PrefUtils().getAdmin();

    Map<String, dynamic> body = {
      "admin_id": admin.id,
      "property_crop_join_id": widget.cropJoinId,
      "volumes": [],
      "dates": [],
    };

    for (var rainGauge in rainGauges) {
      body['volumes'].add(rainGauge['volume'].text);
      body['dates'].add(Formatters.formatDateStringEn(rainGauge['date'].text));
    }

    DefaultRequest.simplePostRequest(
      ApiRoutes.formRainGauge,
      body,
      context,
    ).then((value) {
      Navigator.pop(context);
      widget.reloadItens();
    }).catchError((error) {
      print(error);
    });
  }
}
