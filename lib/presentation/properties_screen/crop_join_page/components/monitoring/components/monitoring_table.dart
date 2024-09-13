import 'dart:convert';
import 'dart:io';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/data/models/property_monitoring/property_monitoring.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/monitoring_change_attributes_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/monitoring_export_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/monitoring_modal.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/custom_badge.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/map_crop/map_crop_native.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MonitoringTable extends StatefulWidget {
  int cropJoinId;
  List<CropJoin> cropJoins;

  MonitoringTable({
    required this.cropJoinId,
    required this.cropJoins,
    super.key,
  });

  @override
  State<MonitoringTable> createState() => _MonitoringTableState();
}

class _MonitoringTableState extends State<MonitoringTable> {
  bool isLoading = true;
  List<Map<String, PropertyMonitoring>> propertyMonitorings = [];
  Crop? crop;

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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 30, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Todos (${propertyMonitorings.length})",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                        CustomActionButton(
                          icon: 'arrow-square-out',
                          onTap: () {
                            Dialogs.showGeralDialog(context,
                                title: "Exportar monitoramentos",
                                widget: MonitoringExportModal(
                                  exportFile: exportFile,
                                  currentTabCode: '',
                                ));
                          },
                        ),
                        const SizedBox(width: 10),
                        CustomFilledButton(
                          onPressed: () {
                            Dialogs.showGeralDialog(
                              context,
                              title: "Adicionar monitoramento",
                              widget: MonitoringModal(
                                cropsJoin: widget.cropJoins,
                                crop: crop!,
                                cropJoin: widget.cropJoinId,
                                reloadFunction: (bool item) => {
                                  getItens(showToast: item),
                                },
                                isEditing: false,
                              ),
                            );
                          },
                          text: "+ Monitoramento",
                          height: 35.v,
                          width: 140.h,
                          buttonTextStyle: CustomTextStyles.bodyMediumWhite,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              TableComponent(
                columns: [
                  TableElements.getDataColumn('Data'),
                  TableElements.getDataColumn('Estádio', icon: 'plant'),
                  TableElements.getDataColumn('Doença', icon: 'first-aid-kit'),
                  TableElements.getDataColumn('Praga', icon: 'bug-beetle'),
                  TableElements.getDataColumn('Daninha', icon: 'leaf'),
                  TableElements.getDataColumn('Obs.', icon: 'info'),
                  TableElements.getDataColumn('Ações'),
                ],
                rows: [
                  for (var item in propertyMonitorings)
                    DataRow(
                      cells: [
                        TableElements.getDataCell(
                          item.keys.first.replaceAll('-', '/'),
                        ),
                        TableElements.getDataCell(
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                if (item.values.first.stages != null)
                                  for (var stage in item.values.first.stages!)
                                    CustomBadge.getDefaultBadge(
                                      stage.risk ?? 1,
                                      text: Formatters.getStageText(stage),
                                      images: stage.images,
                                      textToShow: (stage.vegetativeAgeText !=
                                                      null &&
                                                  stage.vegetativeAgeText !=
                                                      '') ||
                                              (stage.reprodutiveAgeText !=
                                                      null &&
                                                  stage.reprodutiveAgeText !=
                                                      '')
                                          ? "${Formatters.getStageText(stage)}${stage.vegetativeAgeText != null && stage.vegetativeAgeText != '' ? " - ${stage.vegetativeAgeText}" : ''}${stage.reprodutiveAgeText != null && stage.reprodutiveAgeText != '' ? " - ${stage.reprodutiveAgeText}" : ''}"
                                          : null,
                                      context: context,
                                      path: 'property_crop_stages',
                                    ),
                              ],
                            ),
                            isText: 0),
                        TableElements.getDataCell(
                            Container(
                              width: 250,
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  if (item.values.first.diseases != null)
                                    for (var disease
                                        in item.values.first.diseases!)
                                      CustomBadge.getDefaultBadge(
                                        disease.risk ?? 1,
                                        text:
                                            "${disease.disease!.name}${disease.incidency! > 0 ? " - ${Formatters.formatToBrl(disease.incidency)}%" : ''}",
                                        images: disease.images,
                                        path: 'property_crop_diseases',
                                        context: context,
                                      ),
                                ],
                              ),
                            ),
                            isText: 0),
                        TableElements.getDataCell(
                            Container(
                              width: 250,
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  if (item.values.first.pests != null)
                                    for (var pest in item.values.first.pests!)
                                      CustomBadge.getDefaultBadge(
                                        pest.risk ?? 1,
                                        text:
                                            "${pest.pest!.name}${pest.incidency > 0 ? " - ${Formatters.formatToBrl(pest.incidency)}%" : ''} ${pest.quantityPerMeter! > 0 ? "\n${Formatters.formatToBrl(pest.quantityPerMeter)}/m" : ''}${pest.quantityPerSquareMeter! > 0 ? "\n${Formatters.formatToBrl(pest.quantityPerSquareMeter)}/m2" : ''}",
                                        images: pest.images,
                                        path: 'property_crop_pests',
                                        context: context,
                                      ),
                                ],
                              ),
                            ),
                            isText: 0),
                        TableElements.getDataCell(
                            Container(
                              width: 250,
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  if (item.values.first.weeds != null)
                                    for (var weed in item.values.first.weeds!)
                                      CustomBadge.getDefaultBadge(
                                        weed.risk ?? 1,
                                        text: "${weed.weed!.name}",
                                        images: weed.images,
                                        path: 'property_crop_weeds',
                                        context: context,
                                      ),
                                ],
                              ),
                            ),
                            isText: 0),
                        TableElements.getDataCell(
                            Container(
                              width: 115,
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  if (item.values.first.observations != null)
                                    for (var observation
                                        in item.values.first.observations!)
                                      CustomBadge.getDefaultBadge(
                                        observation.risk!,
                                        text: null,
                                        images: observation.images,
                                        textToShow: observation.observations,
                                        context: context,
                                        path: 'property_crop_observations',
                                      ),
                                ],
                              ),
                            ),
                            isText: 0),
                        TableElements.getDataCell(
                            Row(
                              children: [
                                TableElements.getIconButton(
                                  item.values.first.admin!.name,
                                  'user',
                                  () {},
                                ),
                                TableElements.getIconButton(
                                  "Editar monitoramento",
                                  'pencil-simple',
                                  () {
                                    Dialogs.showGeralDialog(
                                      context,
                                      title: "Editar monitoramento",
                                      widget: MonitoringModal(
                                        cropsJoin: widget.cropJoins,
                                        crop: crop!,
                                        monitoring: item.values.first,
                                        cropJoin: widget.cropJoinId,
                                        isEditing: true,
                                        reloadFunction: (bool item) => {
                                          getItens(showToast: item),
                                        },
                                        date: Formatters.formatDateStringEn(
                                            item.keys.first,
                                            divider: '-'),
                                      ),
                                    );
                                  },
                                ),
                                TableElements.getIconButton(
                                  "Visualizar no mapa",
                                  'map-trifold',
                                  () {
                                    Dialogs.showGeralDialog(
                                      context,
                                      title: "Visualizar no mapa",
                                      widget: Container(
                                        height: 400,
                                        child: MapCropNative(
                                          crops: [crop!],
                                          propertyMonitoring: item.values.first,
                                          showList: false,
                                          tapAction: false,
                                          showRegisterMenu: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                TableElements.getIconButton(
                                  "Editar data",
                                  'calendar',
                                  () {
                                    Dialogs.showGeralDialog(context,
                                        title: "Alterar data ",
                                        text:
                                            "A data selecionada irá alterar a visualização dos monitoramentos cadastrados na data ${item.keys.first.replaceAll('-', '/')}. Selecione os itens abaixo:",
                                        widget: MonitoringChangeAttributesModal(
                                          date: item.keys.first,
                                          submitFunction: submitChangeAtt,
                                          type: 1,
                                          cropJoinId: widget.cropJoinId,
                                        ));
                                  },
                                ),
                                TableElements.getIconButton(
                                  "Excluir monitoramentos",
                                  'trash',
                                  () {
                                    Dialogs.showGeralDialog(context,
                                        title: "Remover monitoramento",
                                        text:
                                            "Quais monitoramentos você deseja remover da data ${item.keys.first.replaceAll('-', '/')}?",
                                        widget: MonitoringChangeAttributesModal(
                                          date: item.keys.first,
                                          submitFunction: submitChangeAtt,
                                          type: 2,
                                          cropJoinId: widget.cropJoinId,
                                        ));
                                  },
                                ),
                              ],
                            ),
                            isText: 0),
                      ],
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    CustomBadge.getDefaultBadge(1),
                    CustomBadge.getDefaultBadge(2),
                    CustomBadge.getDefaultBadge(3),
                  ],
                ),
              )
            ],
          );
  }

  getItens({bool showToast = false}) {
    setState(() {
      isLoading = true;
      sleep(Duration(seconds: 1));
    });

    if (showToast) {
      SnackbarComponent.showSnackBar(
        context,
        'success',
        'Operação efetuada com sucesso',
      );
    }

    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listMonitoring}/${widget.cropJoinId}",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);
      if (data['management_data'] != null &&
          data['management_data'].isNotEmpty) {
        Map<String, dynamic> managementData = data['management_data'];

        propertyMonitorings.clear();

        managementData.forEach((date, itemList) {
          propertyMonitorings.add(
            {
              date: PropertyMonitoring.fromJson(itemList),
            },
          );
        });
      }

      crop = data['crop'] != null ? Crop.fromJson(data['crop']) : null;
      setState(() {});
    }).catchError((error) {
      print(error);
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  exportFile(int type) {
    Admin admin = PrefUtils().getAdmin();

    final url =
        "${ApiRoutes.listReports}/${admin.id}/monitoring?export=true&export_type=${type}&property_crop_join_id=${widget.cropJoinId}";

    DefaultRequest.exportFile(context, url);
  }

  submitChangeAtt(dynamic body, String url) {
    DefaultRequest.simplePostRequest(
      url,
      body,
      context,
    ).then((value) {
      getItens();
    }).catchError((error) {
      print(error);
    });
  }
}
