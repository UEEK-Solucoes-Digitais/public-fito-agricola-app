import 'package:fitoagricola/core/utils/url_param_utils.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/monitoring/reports_monitoring_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonitoringReportsFilter extends StatefulWidget {
  MonitoringReportsFilter({
    required this.filters,
    required this.activeFilter,
    required this.onFiltersChanged,
    required this.convertParams,
    required this.isSelectHarvestedActive,
    required this.onChangeSelectHarvested,
    super.key,
  });

  final ReportFilters filters;
  final ReportsFilterParams? activeFilter;
  final Function(ReportsFilterParams?) onFiltersChanged;
  final ReportsFilterParams Function(ReportsFilterParams?) convertParams;
  final bool isSelectHarvestedActive;
  final Function(bool? newSelectHarvestedValue) onChangeSelectHarvested;

  @override
  State<MonitoringReportsFilter> createState() =>
      _MonitoringReportsFilterState();
}

class _MonitoringReportsFilterState extends State<MonitoringReportsFilter> {
  List<DropdownSearchModel> selectedRiskLevels = [];

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  TextEditingController initialDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? initialDate;
  DateTime? endDate;

  List<DropdownSearchModel> riskLevelFilterList = [
    DropdownSearchModel(id: 1, name: 'Sem risco'),
    DropdownSearchModel(id: 2, name: 'Atenção'),
    DropdownSearchModel(id: 3, name: 'Urgência'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsMonitoringFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsMonitoringFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDateFormField(
          controller: initialDateController,
          labelText: 'Data inicial',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newInitialDateValue) {
            setState(() {
              initialDate = newInitialDateValue;
              if (newInitialDateValue == null) {
                initialDateController.text = '';
                return;
              }
              initialDateController.text =
                  dateFormat.format(newInitialDateValue);
            });
          },
        ),
        const SizedBox(height: 16),
        CustomDateFormField(
          controller: endDateController,
          labelText: 'Data final',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newEndDateValue) {
            setState(() {
              endDate = newEndDateValue;
              if (newEndDateValue == null) {
                endDateController.text = '';
                return;
              }
              endDateController.text = dateFormat.format(newEndDateValue);
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownSearchComponent(
          label: 'Nível de risco',
          hintText: 'Selecione',
          style: 'inline',
          selectedId: null,
          onChanged: (DropdownSearchModel newRiskLevel) {
            setState(() {
              selectedRiskLevels.add(newRiskLevel);
            });
          },
          items: [
            DropdownSearchModel(id: 1, name: 'Sem risco'),
            DropdownSearchModel(id: 2, name: 'Atenção'),
            DropdownSearchModel(id: 3, name: 'Urgência'),
          ],
        ),
        const SizedBox(height: 8),
        selectedRiskLevels.length > 0
            ? SelectedItemList(
                itemList: selectedRiskLevels
                    .map<Widget>(
                      (selectedRisk) => SelectedItemComponent(
                        value: selectedRisk.name,
                        onItemRemoved: (riskName) {
                          setState(() {
                            selectedRiskLevels.removeWhere(
                              (riskLevel) => riskLevel.name == riskName,
                            );
                          });
                        },
                      ),
                    )
                    .toList(),
              )
            : const SizedBox.shrink(),
        SelectHarvestedComponent(
          value: widget.isSelectHarvestedActive,
          onChanged: widget.onChangeSelectHarvested,
        ),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var monitoringFilter = ReportsMonitoringFilterParams(
              riskLevel: _riskLevelToParams(),
              initialDate: initialDate,
              endDate: endDate,
            );

            var activeFilter = widget.convertParams(monitoringFilter);

            widget.onFiltersChanged(
              activeFilter,
            );
          },
        ),
      ],
    );
  }

  String _riskLevelToParams() {
    var riskLevels = selectedRiskLevels
        .map<int?>(
          (risk) => risk.id,
        )
        .toList();
    return riskLevels.join(',');
  }

  void _initializeFields(ReportsMonitoringFilterParams activeFilter) {
    initialDateController.text = activeFilter.initialDate != null
        ? dateFormat.format(activeFilter.initialDate!)
        : '';
    endDateController.text = activeFilter.endDate != null
        ? dateFormat.format(activeFilter.endDate!)
        : '';

    setState(() {
      initialDate = activeFilter.initialDate;
      endDate = activeFilter.endDate;

      selectedRiskLevels =
          activeFilter.riskLevel.toObjectList<DropdownSearchModel>(
        comparableList: riskLevelFilterList,
        testFunction: (riskLevel, riskParam) =>
            riskLevel.id.toString() == riskParam,
      );
    });
  }
}
