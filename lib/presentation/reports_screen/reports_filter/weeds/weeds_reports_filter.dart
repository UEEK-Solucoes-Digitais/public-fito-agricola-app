import 'package:fitoagricola/core/utils/url_param_utils.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/weeds/reports_weeds_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/date_dap_fields.dart';
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

class WeedsReportsFilter extends StatefulWidget {
  WeedsReportsFilter({
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
  State<WeedsReportsFilter> createState() => _WeedsReportsFilterState();
}

class _WeedsReportsFilterState extends State<WeedsReportsFilter> {
  List<DropdownSearchModel> selectedWeeds = [];
  List<DropdownSearchModel> selectedRiskLevels = [];

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  TextEditingController initialDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController initialDateDapController = TextEditingController();
  TextEditingController endDateDapController = TextEditingController();

  DateTime? initialDate;
  DateTime? endDate;
  DateTime? initialDateDap;
  DateTime? endDateDap;

  List<DropdownSearchModel> riskLevelFilterList = [
    DropdownSearchModel(id: 1, name: 'Sem risco'),
    DropdownSearchModel(id: 2, name: 'Atenção'),
    DropdownSearchModel(id: 3, name: 'Urgência'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsWeedsFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsWeedsFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearchComponent(
          label: 'Daninhas',
          hintText: 'Selecione',
          style: 'inline',
          selectedId: null,
          onChanged: (DropdownSearchModel newWeed) {
            setState(() {
              selectedWeeds.add(newWeed);
            });
          },
          items: widget.filters.weeds
                  ?.map<DropdownSearchModel>(
                    (weed) =>
                        DropdownSearchModel(id: weed.id, name: weed.name ?? ''),
                  )
                  .toList() ??
              [],
        ),
        const SizedBox(height: 8),
        selectedWeeds.length > 0
            ? SelectedItemList(
                itemList: selectedWeeds
                    .map<Widget>(
                      (selectedWeed) => SelectedItemComponent(
                        value: selectedWeed.name,
                        onItemRemoved: (weedName) {
                          setState(() {
                            selectedWeeds.removeWhere(
                              (weed) => weed.name == weedName,
                            );
                          });
                        },
                      ),
                    )
                    .toList(),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
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
          items: riskLevelFilterList,
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
        // const SizedBox(height: 16),
        // CustomDateFormField(
        //   controller: initialDateDapController,
        //   labelText: 'Data inicial (DAP)',
        //   hintText: 'dd/mm/aaaa',
        //   onDateChanged: (newInitialDateDapValue) {
        //     setState(() {
        //       initialDateDap = newInitialDateDapValue;
        //       if (newInitialDateDapValue == null) {
        //         initialDateDapController.text = '';
        //         return;
        //       }
        //       initialDateDapController.text =
        //           dateFormat.format(newInitialDateDapValue);
        //     });
        //   },
        // ),
        // const SizedBox(height: 16),
        // CustomDateFormField(
        //   controller: endDateDapController,
        //   labelText: 'Data final (DAP)',
        //   hintText: 'dd/mm/aaaa',
        //   onDateChanged: (newEndDateDapValue) {
        //     setState(() {
        //       endDateDap = newEndDateDapValue;
        //       if (newEndDateDapValue == null) {
        //         endDateDapController.text = '';
        //         return;
        //       }
        //       endDateDapController.text = dateFormat.format(newEndDateDapValue);
        //     });
        //   },
        // ),
        DateDapFields(
          initialDateDapController: initialDateDapController,
          endDateDapController: endDateDapController,
          onChangedInitialDateDap: (newInitialDateDapValue) {
            setState(() {
              initialDateDap = newInitialDateDapValue;
              if (newInitialDateDapValue == null) {
                initialDateDapController.text = '';
                return;
              }
              initialDateDapController.text =
                  dateFormat.format(newInitialDateDapValue);
            });
          },
          onChangedEndDateDap: (newEndDateDapValue) {
            setState(() {
              endDateDap = newEndDateDapValue;
              if (newEndDateDapValue == null) {
                endDateDapController.text = '';
                return;
              }
              endDateDapController.text = dateFormat.format(newEndDateDapValue);
            });
          },
        ),
        SelectHarvestedComponent(
          value: widget.isSelectHarvestedActive,
          onChanged: widget.onChangeSelectHarvested,
        ),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var weedsFilters = ReportsWeedsFilterParams(
              weedsId: _weedsToParams(),
              riskLevel: _riskLevelToParams(),
              initialDate: initialDate,
              endDate: endDate,
              initialDateDap: initialDateDap,
              endDateDap: endDateDap,
            );

            var activeFilter = widget.convertParams(weedsFilters);

            widget.onFiltersChanged(activeFilter);
          },
        ),
      ],
    );
  }

  String _weedsToParams() {
    var weeds = selectedWeeds.map<int?>((e) => e.id).toList();
    return weeds.join(',');
  }

  String _riskLevelToParams() {
    var riskLevels = selectedRiskLevels
        .map<int?>(
          (risk) => risk.id,
        )
        .toList();
    return riskLevels.join(',');
  }

  void _initializeFields(ReportsWeedsFilterParams activeFilter) {
    initialDateController.text = activeFilter.initialDate != null
        ? dateFormat.format(activeFilter.initialDate!)
        : '';
    endDateController.text = activeFilter.endDate != null
        ? dateFormat.format(activeFilter.endDate!)
        : '';
    initialDateDapController.text = activeFilter.initialDateDap != null
        ? dateFormat.format(activeFilter.initialDateDap!)
        : '';
    endDateDapController.text = activeFilter.endDateDap != null
        ? dateFormat.format(activeFilter.endDateDap!)
        : '';

    setState(() {
      initialDate = activeFilter.initialDate;
      endDate = activeFilter.endDate;
      initialDateDap = activeFilter.initialDateDap;
      endDateDap = activeFilter.endDateDap;

      selectedWeeds = activeFilter.weedsId.toObjectList<DropdownSearchModel>(
        comparableList: widget.filters.weeds
                ?.map<DropdownSearchModel>(
                  (weed) => DropdownSearchModel(
                    id: weed.id,
                    name: weed.name ?? '',
                  ),
                )
                .toList() ??
            [],
        testFunction: (weed, weedParam) => weed.id.toString() == weedParam,
      );

      selectedRiskLevels =
          activeFilter.riskLevel.toObjectList<DropdownSearchModel>(
        comparableList: riskLevelFilterList,
        testFunction: (riskLevel, riskParam) =>
            riskLevel.id.toString() == riskParam,
      );
    });
  }
}
