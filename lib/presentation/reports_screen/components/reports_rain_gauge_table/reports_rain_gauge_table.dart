import 'package:fitoagricola/data/models/reports/rain_gauge_report.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class ReportsRainGaugeTable extends StatelessWidget {
  const ReportsRainGaugeTable(
      {required this.reports,
      required this.currentPage,
      required this.totalPages,
      required this.updatePageFunction,
      super.key});
  final List<RainGaugeReport> reports;
  final int currentPage;
  final int totalPages;
  final Function(int) updatePageFunction;

  @override
  Widget build(BuildContext context) {
    return TableComponent(
      updatePage: updatePageFunction,
      currentPage: currentPage,
      totalPages: totalPages,
      paginate: true,
      columns: [
        TableElements.getDataColumn('#'),
        TableElements.getDataColumn('Propriedade'),
        TableElements.getDataColumn('Cultura'),
        TableElements.getDataColumn('Cultivar'),
        TableElements.getDataColumn('Ano Agrícola'),
        TableElements.getDataColumn('Lavoura'),
        TableElements.getDataColumn('Total'),
        TableElements.getDataColumn('Média do volume'),
        TableElements.getDataColumn('Intervalo sem chuva'),
        TableElements.getDataColumn('Dias com chuva'),
        TableElements.getDataColumn('Dias sem chuva'),
      ],
      rows: [
        for (var report in reports)
          DataRow(
            cells: [
              TableElements.getDataCell(reports.indexOf(report) + 1),
              TableElements.getDataCell(report.property?.name),
              TableElements.getDataCell(
                report.cultureTable?.replaceAll("<br>", "\n"),
              ),
              TableElements.getDataCell(
                report.cultureCodeTable?.replaceAll("<br>", "\n"),
              ),
              TableElements.getDataCell(
                report.harvest?.name,
              ),
              TableElements.getDataCell(
                "${report.crop?.name ?? '--'} ${report.subharvestName ?? ''}",
              ),
              TableElements.getDataCell(
                (report.rainGaugeInfos?.totalVolume ?? '--') + 'mm',
              ),
              TableElements.getDataCell(
                (report.rainGaugeInfos?.avgVolume ?? '--') + 'mm',
              ),
              TableElements.getDataCell(
                (report.rainGaugeInfos?.rainInterval.toString() ?? '--') +
                    ' ' +
                    (report.rainGaugeInfos?.rainInterval == 1 ? 'dia' : 'dias'),
              ),
              TableElements.getDataCell(
                (report.rainGaugeInfos?.daysWithRain.toString() ?? '--') +
                    ' ' +
                    (report.rainGaugeInfos?.daysWithRain == 1 ? 'dia' : 'dias'),
              ),
              TableElements.getDataCell(
                (report.rainGaugeInfos?.daysWithoutRain.toString() ?? '--') +
                    ' ' +
                    (report.rainGaugeInfos?.daysWithoutRain == 1
                        ? 'dia'
                        : 'dias'),
              ),
            ],
          ),
      ],
    );
  }
}
