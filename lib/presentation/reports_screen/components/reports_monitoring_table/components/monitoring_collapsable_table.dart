import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';
import 'package:fitoagricola/data/models/reports/monitoring_report.dart';
import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:fitoagricola/widgets/custom_badge.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonitoringCollapsableTable extends StatefulWidget {
  const MonitoringCollapsableTable({
    required this.report,
    required this.rowWidth,
    super.key,
  });
  final MonitoringReport report;
  final double rowWidth;

  @override
  State<MonitoringCollapsableTable> createState() =>
      _MonitoringCollapsableTableState();
}

class _MonitoringCollapsableTableState
    extends State<MonitoringCollapsableTable> {
  final doubleFormatter = NumberFormat.decimalPattern();
  final dateFormatter = DateFormat('dd/MM/yyyy');
  final List<DataColumn> collapsableTableCols = [];
  final List<DataRow> rows = [];

  @override
  void initState() {
    super.initState();
    collapsableTableCols.addAll([
      TableElements.getDataColumn('Data'),
      TableElements.getDataColumn('Estádio', icon: 'plant'),
      TableElements.getDataColumn('Doença', icon: 'first-aid-kit'),
      TableElements.getDataColumn('Praga', icon: 'bug-beetle'),
      TableElements.getDataColumn('Daninha', icon: 'leaf'),
      TableElements.getDataColumn('Obs.', icon: 'info'),
    ]);
    rows.addAll(
      widget.report.managementData!
          .map<DataRow>(
            (dataInput) => DataRow(
              cells: [
                TableElements.getDataCell(
                  dataInput.name.replaceAll('-', '/'),
                ),
                TableElements.getDataCell(
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: dataInput.stages!
                        .map<Widget>(
                          (stage) => CustomBadge.getDefaultBadge(
                            stage.risk ?? 1,
                            text: Formatters.getStageText(stage),
                            images: stage.images == null
                                ? []
                                : stage.images!
                                    .map<GeralImage>(
                                      (e) => e.toGeralImage(),
                                    )
                                    .toList(),
                            textToShow: (stage.vegetativeAgeText != null &&
                                        stage.vegetativeAgeText != '') ||
                                    (stage.reprodutiveAgeText != null &&
                                        stage.reprodutiveAgeText != '')
                                ? "${Formatters.getStageText(stage)}${stage.vegetativeAgeText != null && stage.vegetativeAgeText != '' ? " - ${stage.vegetativeAgeText}" : ''}${stage.reprodutiveAgeText != null && stage.reprodutiveAgeText != '' ? " - ${stage.reprodutiveAgeText}" : ''}"
                                : null,
                            context: context,
                            path: 'property_crop_stages',
                          ),
                        )
                        .toList(),
                  ),
                  isText: 0,
                ),
                TableElements.getDataCell(
                  Container(
                    width: 250,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (var disease in dataInput.diseases!)
                          CustomBadge.getDefaultBadge(
                            disease.risk ?? 1,
                            text:
                                "${disease.disease!.name}${disease.incidency > 0 ? " - ${Formatters.formatToBrl(disease.incidency)}%" : ''}",
                            path: 'property_crop_diseases',
                            context: context,
                          ),
                      ],
                    ),
                  ),
                  isText: 0,
                ),
                TableElements.getDataCell(
                  Container(
                    width: 250,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (var pest in dataInput.pests!)
                          CustomBadge.getDefaultBadge(
                            pest.risk ?? 1,
                            text:
                                "${pest.pest!.name}${pest.incidency > 0 ? " - ${Formatters.formatToBrl(pest.incidency)}%" : ''} ${pest.quantityPerMeter > 0 ? "\n${Formatters.formatToBrl(pest.quantityPerMeter)}/m" : ''}${pest.quantityPerSquareMeter > 0 ? "\n${Formatters.formatToBrl(pest.quantityPerSquareMeter)}/m2" : ''}",
                            path: 'property_crop_pests',
                            context: context,
                          ),
                        // These sizedboxes create an empty space for stopping the table to overflow the space.
                        SizedBox(
                          width: 100,
                          height: 30,
                        ),
                        SizedBox(
                          width: 100,
                          height: 30,
                        ),
                        SizedBox(
                          width: 100,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  isText: 0,
                ),
                TableElements.getDataCell(
                  Container(
                    width: 250,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (var weed in dataInput.weeds!)
                          CustomBadge.getDefaultBadge(
                            weed.risk ?? 1,
                            text: "${weed.weed!.name}",
                            path: 'property_crop_weeds',
                            context: context,
                          ),
                      ],
                    ),
                  ),
                  isText: 0,
                ),
                TableElements.getDataCell(
                  dataInput.observations == null ||
                          dataInput.observations!.isEmpty
                      ? Container()
                      : Container(
                          width: 115,
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              for (var observation in dataInput.observations!)
                                CustomBadge.getDefaultBadge(
                                  observation.risk!,
                                  text: null,
                                  images: observation.images == null
                                      ? []
                                      : observation.images!
                                          .map<GeralImage>(
                                            (e) => e.toGeralImage(),
                                          )
                                          .toList(),
                                  textToShow: observation.observations,
                                  context: context,
                                  path: 'property_crop_observations',
                                ),
                            ],
                          ),
                        ),
                  isText: 0,
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.rowWidth + 20,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: appTheme.green400,
            width: 1,
          ),
        ),
      ),
      child: TableComponent(
        borderWidth: 1,
        scrollPhysics: NeverScrollableScrollPhysics(),
        needsStretch: true,
        isVertical: false,
        isScrollable: false,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Color(0xFFE7E7E7),
        ),
        columns: collapsableTableCols,
        rows: rows,
      ),
    );
  }

  String getProductType(int? type) {
    switch (type) {
      case 1:
        return 'Adjuvante';
      case 2:
        return 'Biológico';
      case 3:
        return 'Fertilizante foliar';
      case 4:
        return 'Fungicida';
      case 5:
        return 'Herbicida';
      case 6:
        return 'Inseticida';
      default:
        return 'Adjuvante';
    }
  }
}
