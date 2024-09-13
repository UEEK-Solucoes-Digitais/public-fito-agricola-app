import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/core/utils/risk_level.dart';
import 'package:fitoagricola/data/models/reports/weed_report.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class ReportsWeedTable extends StatelessWidget {
  const ReportsWeedTable(
      {required this.reports,
      required this.currentPage,
      required this.totalPages,
      required this.updatePageFunction,
      super.key});
  final List<WeedReport> reports;
  final int currentPage;
  final int totalPages;
  final Function(int) updatePageFunction;

  @override
  Widget build(BuildContext context) {
    return TableComponent(
      paginate: true,
      currentPage: currentPage,
      totalPages: totalPages,
      updatePage: updatePageFunction,
      columns: [
        TableElements.getDataColumn('#'),
        TableElements.getDataColumn('Propriedade'),
        TableElements.getDataColumn('Ano Agrícola'),
        TableElements.getDataColumn('Plantio'),
        TableElements.getDataColumn('Cultura'),
        TableElements.getDataColumn('Cultivar'),
        TableElements.getDataColumn('Lavoura'),
        TableElements.getDataColumn('Data'),
        TableElements.getDataColumn('Daninha'),
        TableElements.getDataColumn('Nível de Risco'),
        TableElements.getDataColumn('Observações'),
        TableElements.getDataColumn('Estádio'),
        TableElements.getDataColumn('Responsável'),
      ],
      rows: [
        for (var report in reports)
          DataRow(
            cells: [
              TableElements.getDataCell(reports.indexOf(report) + 1),
              TableElements.getDataCell(report.propertyCrop?.property?.name),
              TableElements.getDataCell(
                report.propertyCrop?.harvest?.name ?? '--',
              ),
              TableElements.getDataCell(
                report.propertyCrop?.dataSeed != null &&
                        report.propertyCrop!.dataSeed!.isNotEmpty
                    ? Formatters.formatDateString(
                        report.propertyCrop?.dataSeed?[0].date ?? "")
                    : '--',
              ),
              TableElements.getDataCell(
                  report.propertyCrop?.cultureTable?.replaceAll('<br>', '')),
              TableElements.getDataCell(report.propertyCrop?.cultureCodeTable
                  ?.replaceAll("<br>", "\n")),
              TableElements.getDataCell(
                  "${report.propertyCrop?.crop?.name} ${report.propertyCrop?.subharvestName ?? ''}"),
              TableElements.getDataCell(report.openDate != null
                  ? Formatters.formatDateString(report.openDate.toString())
                  : '--'),
              TableElements.getDataCell(
                report.weed?.name ?? '--',
              ),
              TableElements.getDataCell(
                RiskLevel.convertToWidget(report.risk),
                isText: 0,
              ),
              TableElements.getDataCell(
                report.weed?.observation != null &&
                        report.weed!.observation!.isNotEmpty
                    ? report.weed?.observation
                    : '--',
              ),
              TableElements.getDataCell(
                report.propertyCrop?.stageTable,
              ),
              TableElements.getDataCell(report.admin?.name),
            ],
          ),
      ],
    );
  }
}
