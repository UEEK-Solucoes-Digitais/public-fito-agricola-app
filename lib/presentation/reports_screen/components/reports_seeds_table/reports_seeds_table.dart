import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/reports/data_seed_report.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class ReportsSeedsTable extends StatelessWidget {
  const ReportsSeedsTable(
      {required this.reports,
      required this.currentPage,
      required this.totalPages,
      required this.updatePageFunction,
      super.key});
  final List<DataSeedReport> reports;
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
        TableElements.getDataColumn('Plantio'),
        TableElements.getDataColumn('Ano Agrícola'),
        TableElements.getDataColumn('Cultura'),
        TableElements.getDataColumn('Cultivar'),
        TableElements.getDataColumn('Lavoura'),
        TableElements.getDataColumn('Sementes/${PrefUtils().getAreaUnit()}'),
        TableElements.getDataColumn('População/${PrefUtils().getAreaUnit()}'),
        TableElements.getDataColumn('% de emergência'),
      ],
      rows: [
        for (var report in reports)
          DataRow(
            cells: [
              TableElements.getDataCell(reports.indexOf(report) + 1),
              TableElements.getDataCell(
                  report.propertyCrop?.property?.name ?? '--'),
              TableElements.getDataCell(report.date != null
                  ? Formatters.formatDateString(
                      report.date.toString(),
                    )
                  : '--'),
              TableElements.getDataCell(
                report.propertyCrop?.harvest?.name ?? '--',
              ),
              TableElements.getDataCell(report.product?.name ?? '--'),
              TableElements.getDataCell(report.productVariant ?? '--'),
              TableElements.getDataCell(
                  "${report.propertyCrop?.crop?.name ?? '--'} ${report.propertyCrop?.subharvestName ?? ''}"),
              TableElements.getDataCell(report.dataPopulation!.isNotEmpty
                  ? Formatters.formatRemoveDecimalBrl(
                      report.dataPopulation![0].quantityPerHa)
                  : '--'),
              TableElements.getDataCell(report.dataPopulation!.isNotEmpty
                  ? Formatters.formatRemoveDecimalBrl(
                      report.dataPopulation![0].plantsPerHectare)
                  : '--'),
              TableElements.getDataCell(report.dataPopulation!.isNotEmpty
                  ? report.dataPopulation![0].emergencyPercentage.round()
                  : '--'),
            ],
          ),
      ],
    );
  }
}
