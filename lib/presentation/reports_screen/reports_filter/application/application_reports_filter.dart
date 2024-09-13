import 'package:fitoagricola/data/models/reports/filter/application/reports_application_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ApplicationReportsFilter extends StatefulWidget {
  ApplicationReportsFilter({
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
  State<ApplicationReportsFilter> createState() =>
      _ApplicationReportsFilterState();
}

class _ApplicationReportsFilterState extends State<ApplicationReportsFilter> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  TextEditingController initialDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController depuaBeginController = TextEditingController();
  TextEditingController depuaEndController = TextEditingController();
  TextEditingController daaBeginController = TextEditingController();
  TextEditingController daaEndController = TextEditingController();
  DateTime? initialDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsApplicationFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsApplicationFilterParams,
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
        CustomTextFormField(
          depuaBeginController,
          'DEPUA Fungicida (início)',
          '00',
          inputType: TextInputType.number,
          validatorFunction: true,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          depuaEndController,
          'DEPUA Fungicida (fim)',
          '00',
          inputType: TextInputType.number,
          validatorFunction: true,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          daaBeginController,
          'DAA Fungicida (início)',
          '00',
          inputType: TextInputType.number,
          validatorFunction: true,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          daaEndController,
          'DAA Fungicida (fim)',
          '00',
          inputType: TextInputType.number,
          validatorFunction: true,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ),
        SelectHarvestedComponent(
          value: widget.isSelectHarvestedActive,
          onChanged: widget.onChangeSelectHarvested,
        ),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var applicationFilter = ReportsApplicationFilterParams(
              initialDate: initialDate,
              endDate: endDate,
              depuaBegin: depuaBeginController.text != ''
                  ? int.parse(depuaBeginController.text)
                  : null,
              depuaEnd: depuaEndController.text != ''
                  ? int.parse(depuaEndController.text)
                  : null,
              daaBegin: daaBeginController.text != ''
                  ? int.parse(daaBeginController.text)
                  : null,
              daaEnd: daaEndController.text != ''
                  ? int.parse(daaEndController.text)
                  : null,
            );

            var activeFilter = widget.convertParams(applicationFilter);

            widget.onFiltersChanged(
              activeFilter,
            );
          },
        ),
      ],
    );
  }

  void _initializeFields(ReportsApplicationFilterParams activeFilter) {
    initialDateController.text = activeFilter.initialDate != null
        ? dateFormat.format(activeFilter.initialDate!)
        : '';
    endDateController.text = activeFilter.endDate != null
        ? dateFormat.format(activeFilter.endDate!)
        : '';

    daaBeginController.text =
        activeFilter.daaBegin != null ? activeFilter.daaBegin.toString() : '';

    daaEndController.text =
        activeFilter.daaEnd != null ? activeFilter.daaEnd.toString() : '';

    depuaBeginController.text = activeFilter.depuaBegin != null
        ? activeFilter.depuaBegin.toString()
        : '';

    depuaEndController.text =
        activeFilter.depuaEnd != null ? activeFilter.depuaEnd.toString() : '';

    setState(() {
      initialDate = activeFilter.initialDate;
      endDate = activeFilter.endDate;
    });
  }
}
