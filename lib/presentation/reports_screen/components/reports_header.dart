import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/monitoring_export_modal.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/reports_filter_modal.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/page_header/page_header.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportsHeader extends ConsumerStatefulWidget {
  const ReportsHeader({
    required this.currentTabCode,
    required this.onFilterChanged,
    this.activeFilter,
    required this.exportFile,
    super.key,
  });

  final String currentTabCode;
  final ReportsFilterParams? activeFilter;
  final void Function(ReportsFilterParams?) onFilterChanged;
  final void Function() exportFile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsHeaderState();
}

class _ReportsHeaderState extends ConsumerState<ReportsHeader> {
  ReportFilters? filtersResponse = null;

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: 'Relatórios',
      icon: 'chart-pie-slice',
      buttons: [
        if (widget.currentTabCode != 'cultures' ||
            (widget.currentTabCode == 'cultures'))
          _buildOpenActionsButton(),
        const SizedBox(width: 10),
        _buildOpenFilterButton(),
      ],
    );
  }

  Widget _buildOpenActionsButton() {
    return CustomActionButton(
      icon: 'arrow-square-out',
      onTap: () {
        Dialogs.showGeralDialog(
          context,
          title: "Exportar relatório",
          widget: MonitoringExportModal(
            exportFile: exportFile,
            currentTabCode: widget.currentTabCode,
            exportImage: widget.exportFile,
          ),
        );
      },
    );
  }

  exportFile(int type) {
    Admin admin = PrefUtils().getAdmin();

    final url =
        "/api/reports/list/${admin.id}/${widget.currentTabCode}?export=true&export_type=${type}&${widget.activeFilter != null ? widget.activeFilter!.toRequestQueryParams() : null}";

    print(url);
    DefaultRequest.exportFile(context, url);
  }

  Widget _buildOpenFilterButton() {
    return CustomOutlinedButton(
      width: 110.h,
      height: 35.v,
      buttonTextStyle: theme.textTheme.titleMedium!.copyWith(
        color: theme.primaryColor,
      ),
      buttonStyle: CustomButtonStyles.outlineGreenTL10,
      leftIcon: Row(
        children: [
          PhosphorIcon(
            IconsList.getIcon('faders'),
            color: theme.primaryColor,
          ),
          const SizedBox(width: 10),
        ],
      ),
      text: 'Filtros',
      onPressed: () {
        _fetchFilters().then(
          (_) {
            if (filtersResponse != null)
              return Dialogs.showGeralDialog(
                context,
                title: "Filtros",
                widget: ReportsFilterModal(
                  filters: filtersResponse!,
                  activeFilter: widget.activeFilter,
                  onFiltersChanged: widget.onFilterChanged,
                  currentTabCode: widget.currentTabCode,
                ),
              );
          },
        );
      },
    );
  }

  Future<void> _fetchFilters() {
    Admin admin = PrefUtils().getAdmin();

    Dialogs.showLoadingDialog(context);

    return DefaultRequest.simpleGetRequest(
      '/api/reports/get-filters-options/${admin.id}?with=${widget.currentTabCode}',
      context,
      showSnackBar: 0,
    ).then((value) {
      Map<String, dynamic> data = jsonDecode(value.body);

      Navigator.of(context).pop();

      if (data['status'] != null) {
        setState(() {
          filtersResponse = ReportFilters.fromJson(data);
        });
      } else {
        SnackbarComponent.showSnackBar(context, 'error',
            'Ocorreu um erro ao carregar os dados do filtro.');
      }
    }).catchError((error) {
      print(error);
      SnackbarComponent.showSnackBar(
          context, 'error', 'Ocorreu um erro ao carregar os dados do filtro.');
    });
  }
}
