import 'package:fitoagricola/data/models/reports/application_report.dart';
import 'package:fitoagricola/data/models/reports/data_seed_report.dart';
import 'package:fitoagricola/data/models/reports/disease_report.dart';
import 'package:fitoagricola/data/models/reports/generic_report.dart';
import 'package:fitoagricola/data/models/reports/input/input_report.dart';
import 'package:fitoagricola/data/models/reports/monitoring_report.dart';
import 'package:fitoagricola/data/models/reports/pest_report.dart';
import 'package:fitoagricola/data/models/reports/productivity_report.dart';
import 'package:fitoagricola/data/models/reports/rain_gauge_report.dart';
import 'package:fitoagricola/data/models/reports/weed_report.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_application_table/reports_application_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_culture_table/reports_culture_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_disease_table/reports_disease_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_generic_table/reports_generic_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_inputs_table/reports_inputs_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_monitoring_table/reports_monitoring_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_pest_table/reports_pest_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_productivity_table/reports_productivity_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_rain_gauge_table/reports_rain_gauge_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_seeds_table/reports_seeds_table.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_weed_table/reports_weed_table.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown/dropdown_button_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ReportsBody extends StatelessWidget {
  const ReportsBody({
    required this.selectedValue,
    required this.itemsResponse,
    required this.onTabChanged,
    required this.isLoading,
    required this.tabs,
    required this.filtersParam,
    required this.currentPage,
    required this.totalPages,
    required this.updatePageFunction,
    required this.productivityGraph,
    required this.globalKey,
    required this.functionController,
    super.key,
  });

  final int selectedValue;
  final List<Map<String, Object>> tabs;
  final List<dynamic> itemsResponse;
  final Function(int?) onTabChanged;
  final bool isLoading;
  final String? filtersParam;
  final int currentPage;
  final int totalPages;
  final Function(int) updatePageFunction;
  final dynamic productivityGraph;
  final globalKey;
  final Function(InAppWebViewController) functionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButtonComponent(
            value: selectedValue,
            itens: tabs,
            onChanged: onTabChanged,
          ),
        ),
        isLoading
            ? DefaultCircularIndicator.getIndicator()
            : Container(
                margin: EdgeInsets.only(top: 20),
                child: getTab(),
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget getTab() {
    switch (selectedValue) {
      case 11:
        return ReportsCultureTable(
          filtersParam: filtersParam,
          globalKey: globalKey,
          functionController: functionController,
        );
      case 10:
        return ReportsProductivityTable(
          reports: ProductivityReport.fromJsonList(itemsResponse),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
          productivityGraph: productivityGraph,
        );
      case 9:
        return ReportsMonitoringTable(
          reports: MonitoringReport.fromJsonList(itemsResponse),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
      case 8:
        return ReportsRainGaugeTable(
          reports: RainGaugeReport.fromJsonList(itemsResponse),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
      case 7:
        return ReportsApplicationTable(
          reports: ApplicationReport.fromJsonList(
            itemsResponse,
          ),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
      case 6:
        return ReportsSeedsTable(
          reports: DataSeedReport.fromJsonList(itemsResponse),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
      case 5:
        return ReportsInputsTable(
          reports: InputReport.fromJsonList(itemsResponse),
          visualizationType: _getVisualizationType(),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );

      case 4:
        return ReportsDiseaseTable(
          reports: DiseaseReport.fromJsonList(itemsResponse),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
      case 3:
        return ReportsWeedTable(
          reports: WeedReport.fromJsonList(
            itemsResponse,
          ),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
      case 2:
        return ReportsPestTable(
          reports: PestReport.fromJsonList(
            itemsResponse,
          ),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
      case 1:
      default:
        return ReportsGenericTable(
          reports: GenericReport.fromJsonList(
            itemsResponse,
          ),
          currentPage: currentPage,
          totalPages: totalPages,
          updatePageFunction: updatePageFunction,
        );
    }
  }

  int _getVisualizationType() {
    var visualizationType = 1;
    if (filtersParam != null && filtersParam!.contains("visualization_type")) {
      RegExp regExp = RegExp(r"visualization_type=([^&]+)");
      var match = regExp.firstMatch(filtersParam ?? "");
      if (match != null) {
        visualizationType = int.parse(match.group(1)!);
      }
    }

    return visualizationType;
  }
}
