import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/reports/application_report.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class ReportsApplicationTable extends StatelessWidget {
  const ReportsApplicationTable(
      {required this.reports,
      required this.currentPage,
      required this.totalPages,
      required this.updatePageFunction,
      super.key});

  final List<ApplicationReport> reports;
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
        TableElements.getDataColumn('N•'),
        TableElements.getDataColumn('DAP'),
        TableElements.getDataColumn('DAE'),
        TableElements.getDataColumn('Data'),
        TableElements.getDataColumn('DEPPA'),
        TableElements.getDataColumn('DEPUA'),
        TableElements.getDataColumn('DAA'),
        TableElements.getDataColumn('Estádio'),
      ],
      rows: [
        for (var report in reports)
          DataRow(
            cells: [
              TableElements.getDataCell(reports.indexOf(report) + 1),
              TableElements.getDataCell(report.property?.name),
              TableElements.getDataCell(report.datePlant),
              TableElements.getDataCell(report.harvest?.name),
              TableElements.getDataCell(
                  report.cultureTable?.replaceAll("<br>", "\n")),
              TableElements.getDataCell(
                  report.cultureCodeTable?.replaceAll("<br>", "")),
              TableElements.getDataCell(
                  "${report.crop?.name ?? '--'} ${report.subharvestName ?? ''}"),
              TableElements.getDataCell(report.applicationNumber ?? '--'),
              TableElements.getDataCell(
                  report.plantTable != '--'
                      ? _buildValueContainer(report.plantTable)
                      : report.plantTable,
                  isText: report.plantTable != '--' ? 0 : 1),
              TableElements.getDataCell(
                  report.emergencyTable != '--'
                      ? _buildValueContainer(report.emergencyTable)
                      : report.emergencyTable,
                  isText: report.emergencyTable != '--' ? 0 : 1),
              TableElements.getDataCell(report.applicationDateTable),
              TableElements.getDataCell(
                  report.daysBetweenPlantAndFirstApplication != '--'
                      ? _buildValueContainer(
                          report.daysBetweenPlantAndFirstApplication)
                      : report.daysBetweenPlantAndFirstApplication,
                  isText: report.daysBetweenPlantAndFirstApplication != '--'
                      ? 0
                      : 1),
              TableElements.getDataCell(
                  report.daysBetweenPlantAndLastApplication != '--'
                      ? _buildValueContainer(
                          report.daysBetweenPlantAndLastApplication)
                      : report.daysBetweenPlantAndLastApplication,
                  isText: report.daysBetweenPlantAndLastApplication != '--'
                      ? 0
                      : 1),
              TableElements.getDataCell(
                  report.applicationTable != '--'
                      ? _buildValueContainer(report.applicationTable)
                      : report.applicationTable,
                  isText: report.applicationTable != '--' ? 0 : 1),
              TableElements.getDataCell(report.stageTable),
            ],
          ),
      ],
    );
  }

  dynamic _buildValueContainer(String? targetText) {
    return targetText == '--'
        ? '--'
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.h,
              vertical: 8.v,
            ),
            decoration: BoxDecoration(
              color: appTheme.green400,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Text(
              targetText!,
              style: theme.textTheme.titleSmall,
            ),
          );
  }
}
