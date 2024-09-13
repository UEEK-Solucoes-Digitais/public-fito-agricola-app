import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/rain_gauge/rain_gauge.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RaingGaugeListModal extends StatefulWidget {
  int cropJoinId;
  String initDate;
  String endDate;
  Function() reloadItens;

  RaingGaugeListModal(
      {required this.cropJoinId,
      required this.initDate,
      required this.endDate,
      required this.reloadItens,
      super.key});

  @override
  State<RaingGaugeListModal> createState() => _RaingGaugeListModalState();
}

class _RaingGaugeListModalState extends State<RaingGaugeListModal> {
  List<RainGauge> rainGauges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getItens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : TableComponent(
            columns: [
              TableElements.getDataColumn('Volume'),
              TableElements.getDataColumn('Data'),
              TableElements.getDataColumn('Ações'),
            ],
            rows: [
              for (var rainGauge in rainGauges)
                DataRow(
                  cells: [
                    TableElements.getDataCell(
                        "${Formatters.formatToBrl(rainGauge.volume)}mm"),
                    TableElements.getDataCell(
                        Formatters.formatDateString(rainGauge.date)),
                    TableElements.getDataCell(
                        Row(
                          children: [
                            TableElements.getIconButton(
                              "Remover registro",
                              "trash",
                              () {
                                removeItem(rainGauge.id);
                              },
                            ),
                          ],
                        ),
                        isText: 0),
                  ],
                )
            ],
          );
  }

  getItens() {
    final url =
        "${ApiRoutes.filterRainGauge}/${widget.cropJoinId}/custom/${widget.initDate}/${widget.endDate}";

    DefaultRequest.simpleGetRequest(url, context, showSnackBar: 0)
        .then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        rainGauges = RainGauge.listFromJson(data['rain_gauges_register']);
      });
    }).catchError((error) {
      print(error);
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  removeItem(int id) {
    Admin admin = PrefUtils().getAdmin();
    Dialogs.showDeleteDialog(
      context,
      title: "Remover registro",
      text: "Deseja realmente remover este registro pluviômetro?",
      textButton: "Remover",
      onClick: () {
        Navigator.pop(context);
        DefaultRequest.simplePostRequest(
                ApiRoutes.deleteRainGauge,
                {
                  "admin_id": admin.id,
                  "_method": "PUT",
                  "id": id,
                },
                context)
            .then(
          (value) {
            Navigator.pop(context);
            widget.reloadItens();
          },
        );
      },
    );
  }
}
