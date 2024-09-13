import 'package:fitoagricola/data/models/reports/monitoring_report.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_monitoring_table/components/monitoring_collapsable_table.dart';
import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/tables/collapsable_table/collapsable_table.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportsMonitoringTable extends StatefulWidget {
  const ReportsMonitoringTable(
      {required this.reports,
      required this.currentPage,
      required this.totalPages,
      required this.updatePageFunction,
      super.key});

  final List<MonitoringReport> reports;
  final int currentPage;
  final int totalPages;
  final Function(int) updatePageFunction;

  @override
  State<ReportsMonitoringTable> createState() => _ReportsMonitoringTableState();
}

class _ReportsMonitoringTableState extends State<ReportsMonitoringTable> {
  final cols = <String>[
    '#',
    'Propriedade',
    'Lavoura',
    'Cultura',
    'Cultivar',
    'Ano Agrícola',
  ];

  double tableWidth = 1240;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 0,
        ),
        child: _buildReportList(),
      ),
    );
  }

  Widget _buildReportList() {
    if (widget.reports.isEmpty) {
      return Center(
        child: Text('Nenhum registro encontrado'),
      );
    }

    return CollapsableTable(
      cols: cols,
      rowItems: widget.reports,
      columnCount: 6,
      paginate: true,
      tableWidth: tableWidth,
      rowHeight: 36,
      currentPage: widget.currentPage,
      totalPages: widget.totalPages,
      updatePage: widget.updatePageFunction,
      rowBuilder: (report) {
        return _buildReportRow(report);
      },
      collapsableChildBuilder: (report) {
        return MonitoringCollapsableTable(
          report: report,
          rowWidth: tableWidth,
        );
      },
    );
  }

  List<Widget> _buildReportRow(MonitoringReport report) {
    var index = widget.reports.indexOf(report);
    var textStyle = theme.textTheme.bodyMedium;
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          PhosphorIcon(
            IconsList.getIcon('caret-up'),
            color: appTheme.green400,
            size: 10,
          ),
          const SizedBox(width: 4),
          Text(
            '${index + 1}',
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ],
      ),
      Text(
        report.property?.name ?? '',
        style: textStyle,
      ),
      Text(
        "${report.crop?.name ?? ''} ${report.subharvestName ?? ''}",
        style: textStyle,
      ),
      Text(
        report.cultureTable ?? '',
        style: textStyle,
      ),
      Text(
        report.cultureCodeTable?.replaceAll("<br>", "\n") ?? '',
        style: textStyle,
      ),
      Text(
        report.harvest?.name ?? '',
        style: textStyle,
      ),
    ];
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
