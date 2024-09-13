import 'package:fitoagricola/core/utils/url_param_utils.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/pests/reports_pests_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/date_dap_fields.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PestsReportsFilter extends StatefulWidget {
  PestsReportsFilter({
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
  State<PestsReportsFilter> createState() => _PestsReportsFilterState();
}

class _PestsReportsFilterState extends State<PestsReportsFilter> {
  List<DropdownSearchModel> selectedPests = [];
  List<DropdownSearchModel> selectedRiskLevels = [];
  TextEditingController minimumIncidencyController = TextEditingController();
  TextEditingController maximumIncidencyController = TextEditingController();
  TextEditingController minimumQuantityMeterController =
      TextEditingController();
  TextEditingController maximumQuantityMeterController =
      TextEditingController();
  TextEditingController minimumQuantityPerSquareMeterController =
      TextEditingController();
  TextEditingController maximumQuantityPerSquareMeterController =
      TextEditingController();
  TextEditingController initialDateDapController = TextEditingController();
  TextEditingController endDateDapController = TextEditingController();
  TextEditingController initialDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? initialDate;
  DateTime? endDate;
  DateTime? initialDateDap;
  DateTime? endDateDap;

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  List<DropdownSearchModel> riskLevelFilterList = [
    DropdownSearchModel(id: 1, name: 'Sem risco'),
    DropdownSearchModel(id: 2, name: 'Atenção'),
    DropdownSearchModel(id: 3, name: 'Urgência'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsPestsFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsPestsFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearchComponent(
          label: 'Praga',
          hintText: 'Selecione',
          style: 'inline',
          selectedId: null,
          onChanged: (DropdownSearchModel newSelectedPest) {
            setState(() {
              selectedPests.add(newSelectedPest);
            });
          },
          items: widget.filters.pests
                  ?.map<DropdownSearchModel>(
                    (pest) =>
                        DropdownSearchModel(id: pest.id, name: pest.name ?? ''),
                  )
                  .toList() ??
              [],
        ),
        const SizedBox(height: 8),
        selectedPests.length > 0
            ? SelectedItemList(
                itemList: selectedPests
                    .map<Widget>(
                      (selectedPest) => SelectedItemComponent(
                        value: selectedPest.name,
                        onItemRemoved: (pestName) {
                          setState(() {
                            selectedPests.removeWhere(
                              (pest) => pest.name == pestName,
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
        const SizedBox(height: 16),
        CustomTextFormField(
          minimumIncidencyController,
          'Incidência mínima (%)',
          '00,00',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          maximumIncidencyController,
          'Incidência máxima (%)',
          '00,00',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          minimumQuantityMeterController,
          'Metro linear (mínimo)',
          '00,00',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          maximumQuantityMeterController,
          'Metro linear (máximo)',
          '00,00',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          minimumQuantityPerSquareMeterController,
          'Quantidade/m² (mínimo)',
          '00,00',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          maximumQuantityPerSquareMeterController,
          'Quantidade/m² (máximo)',
          '00,00',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        // const SizedBox(height: 16),
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
        SelectHarvestedComponent(value: true),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var pestFilter = ReportsPestsFilterParams(
              pestsId: _pestsToParams(),
              riskLevel: _riskLevelToParams(),
              initialDate: initialDate,
              endDate: endDate,
              initialDateDap: initialDateDap,
              endDateDap: endDateDap,
              minIncidency: minimumIncidencyController.text,
              maxIncidency: maximumIncidencyController.text,
              minQuantityPerMeter: minimumQuantityMeterController.text,
              maxQuantityPerMeter: maximumQuantityMeterController.text,
              minQuantityPerSquareMeter:
                  minimumQuantityPerSquareMeterController.text,
              maxQuantityPerSquareMeter: maximumQuantityMeterController.text,
            );

            var activeFilter = widget.convertParams(pestFilter);

            widget.onFiltersChanged(
              activeFilter,
            );
          },
        ),
      ],
    );
  }

  String _pestsToParams() {
    var pests = selectedPests.map<int?>((e) => e.id).toList();
    return pests.join(',');
  }

  String _riskLevelToParams() {
    var riskLevels = selectedRiskLevels
        .map<int?>(
          (risk) => risk.id,
        )
        .toList();
    return riskLevels.join(',');
  }

  void _initializeFields(ReportsPestsFilterParams activeFilter) {
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

    minimumIncidencyController.text = activeFilter.minIncidency ?? '';
    maximumIncidencyController.text = activeFilter.maxIncidency ?? '';
    minimumQuantityMeterController.text =
        activeFilter.minQuantityPerMeter ?? '';
    maximumQuantityMeterController.text =
        activeFilter.maxQuantityPerMeter ?? '';
    minimumQuantityPerSquareMeterController.text =
        activeFilter.minQuantityPerSquareMeter ?? '';
    maximumQuantityPerSquareMeterController.text =
        activeFilter.maxQuantityPerSquareMeter ?? '';

    setState(() {
      initialDate = activeFilter.initialDate;
      endDate = activeFilter.endDate;
      initialDateDap = activeFilter.initialDateDap;
      endDateDap = activeFilter.endDateDap;

      selectedPests = activeFilter.pestsId.toObjectList<DropdownSearchModel>(
        comparableList: widget.filters.pests
                ?.map<DropdownSearchModel>(
                  (pest) => DropdownSearchModel(
                    id: pest.id,
                    name: pest.name ?? '',
                  ),
                )
                .toList() ??
            [],
        testFunction: (pest, pestParam) => pest.id.toString() == pestParam,
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
