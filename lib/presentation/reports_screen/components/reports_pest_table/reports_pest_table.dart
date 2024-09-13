import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/core/utils/risk_level.dart';
import 'package:fitoagricola/data/models/reports/pest_report.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class ReportsPestTable extends StatelessWidget {
  const ReportsPestTable(
      {required this.reports,
      required this.currentPage,
      required this.totalPages,
      required this.updatePageFunction,
      super.key});
  final List<PestReport> reports;
  final int currentPage;
  final int totalPages;
  final Function(int) updatePageFunction;

  @override
  Widget build(BuildContext context) {
    return TableComponent(
      paginate: true,
      totalPages: totalPages,
      currentPage: currentPage,
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
        TableElements.getDataColumn('Praga'),
        TableElements.getDataColumn('Nível de Risco'),
        TableElements.getDataColumn('Incidência'),
        TableElements.getDataColumn('Metro'),
        TableElements.getDataColumn('m2'),
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
                report.pest?.name ?? '--',
              ),
              TableElements.getDataCell(
                RiskLevel.convertToWidget(report.risk),
                isText: 0,
              ),
              TableElements.getDataCell(
                report.incidency != null
                    ? '${Formatters.formatToBrl(report.incidency)}%'
                    : '--',
              ),
              TableElements.getDataCell(
                report.quantityPerMeter != null
                    ? '${Formatters.formatToBrl(report.quantityPerMeter)}'
                    : '--',
              ),
              TableElements.getDataCell(
                report.quantityPerSquareMeter != null
                    ? '${Formatters.formatToBrl(report.quantityPerSquareMeter)}'
                    : '--',
              ),
              TableElements.getDataCell(
                report.pest?.observation ?? '--',
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
