import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/reports/productivity_report.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_productivity_table/reports_graph.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class ReportsProductivityTable extends StatelessWidget {
  const ReportsProductivityTable(
      {required this.reports,
      required this.currentPage,
      required this.totalPages,
      required this.updatePageFunction,
      required this.productivityGraph,
      super.key});

  final List<ProductivityReport> reports;
  final int currentPage;
  final int totalPages;
  final Function(int) updatePageFunction;
  final dynamic productivityGraph;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReportGraph(productivityGraph: productivityGraph),
        TableComponent(
          paginate: true,
          currentPage: currentPage,
          totalPages: totalPages,
          updatePage: updatePageFunction,
          columns: [
            TableElements.getDataColumn('#'),
            TableElements.getDataColumn('Propriedade'),
            TableElements.getDataColumn('Ano Agrícola'),
            TableElements.getDataColumn('Cultura'),
            TableElements.getDataColumn('Lavoura'),
            TableElements.getDataColumn('Área'),
            TableElements.getDataColumn('Plantio'),
            TableElements.getDataColumn('Cultivar'),
            TableElements.getDataColumn('Sc'),
            TableElements.getDataColumn('Kg'),
            TableElements.getDataColumn('Sc'),
            TableElements.getDataColumn('Kg'),
          ],
          rows: [
            for (var report in reports)
              DataRow(
                cells: [
                  TableElements.getDataCell(reports.indexOf(report) + 1),
                  TableElements.getDataCell(
                      report.propertyCrop?.property?.name ?? '--'),
                  TableElements.getDataCell(
                    report.propertyCrop?.harvest?.name,
                  ),
                  TableElements.getDataCell(
                      report.cultureTable?.replaceAll(" ", "\n")),
                  TableElements.getDataCell(
                      "${report.propertyCrop?.crop?.name ?? '--'} ${report.propertyCrop?.subharvestName ?? ''}"),
                  TableElements.getDataCell(Formatters.formatToBrl(
                      report.dataSeed != null
                          ? report.dataSeed?.area
                          : report.propertyCrop?.crop?.area)),
                  TableElements.getDataCell(report.datePlant),
                  TableElements.getDataCell(
                    report.cultureCodeTable?.replaceAll("<br>", "\n"),
                  ),
                  TableElements.getDataCell(
                    report.productivity != null
                        ? Formatters.formatToBrl(report.productivity)
                        : '--',
                  ),
                  TableElements.getDataCell(
                    report.productivityPerHectare ?? '--',
                  ),
                  TableElements.getDataCell(
                    report.totalProductionPerHectare ?? '--',
                  ),
                  TableElements.getDataCell(
                    report.totalProduction != null
                        ? Formatters.formatToBrl(report.totalProduction)
                        : '--',
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
