import 'package:fitoagricola/core/utils/url_param_utils.dart';
import 'package:fitoagricola/data/models/disease/disease.dart';
import 'package:fitoagricola/data/models/reports/filter/diseases/reports_diseases_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/date_dap_fields.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DiseasesReportsFilter extends StatefulWidget {
  DiseasesReportsFilter({
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
  final ReportsFilterParams Function(ReportsFilterParams) convertParams;
  final bool isSelectHarvestedActive;
  final Function(bool? newSelectHarvestedValue) onChangeSelectHarvested;

  @override
  State<DiseasesReportsFilter> createState() => _DiseasesReportsFilterState();
}

class _DiseasesReportsFilterState extends State<DiseasesReportsFilter> {
  List<Disease> selectedDiseases = [];
  List<DropdownSearchModel> selectedRiskLevels = [];

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  TextEditingController initialDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController initialDateDapController = TextEditingController();
  TextEditingController endDateDapController = TextEditingController();
  TextEditingController minimumIncidencyController = TextEditingController();
  TextEditingController maximumIncidencyController = TextEditingController();
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
        widget.activeFilter is ReportsDiseasesFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsDiseasesFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearchComponent(
          label: 'Doenças',
          hintText: 'Selecione',
          style: 'inline',
          selectedId: null,
          onChanged: _selectDisease,
          items: widget.filters.diseases
                  ?.map<DropdownSearchModel>(
                    (disease) => DropdownSearchModel(
                        id: disease.id, name: disease.name ?? ''),
                  )
                  .toList() ??
              [],
        ),
        const SizedBox(height: 8),
        selectedDiseases.length > 0
            ? SelectedItemList(
                itemList: selectedDiseases
                    .map<Widget>(
                      (selectedDisease) => SelectedItemComponent(
                        value: selectedDisease.name,
                        onItemRemoved: (diseaseName) {
                          setState(() {
                            selectedDiseases.removeWhere(
                              (disease) => disease.name == diseaseName,
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
            var diseaseFilter = ReportsDiseasesFilterParams(
              diseasesId: _diseasesToParams(),
              riskLevel: _riskLevelToParams(),
              initialDate: initialDate,
              endDate: endDate,
              initialDateDap: initialDateDap,
              endDateDap: endDateDap,
              minIncidency: minimumIncidencyController.text,
              maxIncidency: maximumIncidencyController.text,
            );

            var activeFilter = widget.convertParams(diseaseFilter);
            widget.onFiltersChanged(
              activeFilter,
            );
          },
        ),
      ],
    );
  }

  void _selectDisease(DropdownSearchModel? newSelectedDisease) {
    if (newSelectedDisease == null) return;
    var disease = widget.filters.diseases!.firstWhere(
      (item) => item.id == newSelectedDisease.id,
    );

    var diseaseIndex = selectedDiseases.indexOf(disease);
    if (diseaseIndex != -1) return;
    setState(() {
      selectedDiseases.add(disease);
    });
  }

  String _diseasesToParams() {
    var diseases = selectedDiseases.map<int?>((e) => e.id).toList();
    return diseases.join(',');
  }

  String _riskLevelToParams() {
    var riskLevels = selectedRiskLevels
        .map<int?>(
          (risk) => risk.id,
        )
        .toList();
    return riskLevels.join(',');
  }

  void _initializeFields(ReportsDiseasesFilterParams activeFilter) {
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

    setState(() {
      initialDate = activeFilter.initialDate;
      endDate = activeFilter.endDate;
      initialDateDap = activeFilter.initialDateDap;
      endDateDap = activeFilter.endDateDap;

      selectedDiseases = activeFilter.diseasesId.toObjectList<Disease>(
        comparableList: widget.filters.diseases,
        testFunction: (disease, diseaseParam) =>
            disease.id.toString() == diseaseParam,
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
