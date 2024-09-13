import 'package:fitoagricola/data/models/reports/input/input_report.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_inputs_table/components/inputs_collapsable_table.dart';
import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/tables/collapsable_table/collapsable_table.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportsInputsTable extends StatefulWidget {
  const ReportsInputsTable({
    required this.reports,
    required this.currentPage,
    required this.totalPages,
    required this.updatePageFunction,
    required this.visualizationType,
    super.key,
  });

  final List<InputReport> reports;
  final int visualizationType;
  final int currentPage;
  final int totalPages;
  final Function(int) updatePageFunction;

  @override
  State<ReportsInputsTable> createState() => _ReportsInputsTableState();
}

class _ReportsInputsTableState extends State<ReportsInputsTable> {
  final List<String> firstTableCols = [];
  final double tableWidth = 900;

  @override
  void initState() {
    super.initState();

    if (widget.reports.isNotEmpty) {
      /// If you change this, then change the columnCount in [buildReportList]
      firstTableCols.addAll([
        '#',
        'Propriedade',
        'Lavoura',
        if (widget.visualizationType != 3) 'Cultura',
        'Ano Agrícola',
      ]);
    }
  }

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
      cols: firstTableCols,
      rowItems: widget.reports,
      columnCount: 5,
      paginate: true,
      currentPage: widget.currentPage,
      totalPages: widget.totalPages,
      updatePage: widget.updatePageFunction,
      tableWidth: tableWidth,
      rowHeight: widget.visualizationType != 3 ? 30 : 110,
      rowBuilder: (report) {
        return _buildReportRow(report);
      },
      collapsableChildBuilder: (report) {
        return InputsCollapsableTable(
          report: report,
          visualizationType: widget.visualizationType,
          rowWidth: tableWidth,
        );
      },
    );
  }

  List<Widget> _buildReportRow(InputReport report) {
    final index = widget.reports.indexOf(report);
    var textStyle = theme.textTheme.bodyMedium;
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PhosphorIcon(
            IconsList.getIcon('caret-up'),
            color: appTheme.green400,
            size: 10,
          ),
          const SizedBox(width: 4),
          Text(
            '${index + 1}',
            style: textStyle,
          ),
        ],
      ),
      Text(
        widget.visualizationType == 3
            ? report.name ?? ''
            : report.property?.name ?? '',
        style: textStyle,
      ),
      if (widget.visualizationType != 3)
        Text(
          "${report.crop?.name ?? ''} ${report.subharvestName ?? ''}",
          style: textStyle,
        ),
      Text(
        report.cultureTable ?? '',
        style: textStyle,
      ),
      Text(
        widget.visualizationType == 3
            ? report.harvest?.name ?? report.harvestName ?? ''
            : report.harvest?.name ?? '',
        style: textStyle,
      ),
    ];
  }
}
