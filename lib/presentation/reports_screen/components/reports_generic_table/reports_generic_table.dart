import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/reports/generic_report.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class ReportsGenericTable extends StatelessWidget {
  const ReportsGenericTable({
    required this.reports,
    required this.currentPage,
    required this.totalPages,
    required this.updatePageFunction,
    super.key,
  });

  final List<GenericReport> reports;
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
        TableElements.getDataColumn('Cultura'),
        TableElements.getDataColumn('Cultivar'),
        TableElements.getDataColumn('Área'),
        TableElements.getDataColumn('Lavoura'),
        TableElements.getDataColumn('DAP*'),
        TableElements.getDataColumn('DAE*'),
        TableElements.getDataColumn('DAA*'),
        TableElements.getDataColumn('Estádio'),
      ],
      rows: [
        for (var report in reports)
          DataRow(
            cells: [
              TableElements.getDataCell(reports.indexOf(report) + 1),
              TableElements.getDataCell(report.property?.name ?? '--'),
              TableElements.getDataCell(report.harvest?.name ?? '--'),
              TableElements.getDataCell(
                  report.cultureTable?.replaceAll("<br>", "\n")),
              TableElements.getDataCell(
                  report.cultureCodeTable?.replaceAll("<br>", "\n")),
              TableElements.getDataCell(report.crop?.area != null
                  ? '${report.crop!.area} ${PrefUtils().getAreaUnit()}'
                  : '--'),
              TableElements.getDataCell(report.crop?.name ?? '--'),
              TableElements.getDataCell(
                _buildValueContainer(report.plantTable),
                isText: report.cultureCodeTable == '--' ? 1 : 0,
              ),
              TableElements.getDataCell(
                _buildValueContainer(report.emergencyTable),
                isText: report.emergencyTable == '--' ? 1 : 0,
              ),
              TableElements.getDataCell(
                _buildValueContainer(report.applicationTable),
                isText: report.applicationTable == '--' ? 1 : 0,
              ),
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
