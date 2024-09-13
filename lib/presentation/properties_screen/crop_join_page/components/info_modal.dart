import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:flutter/material.dart';

class InfoModal extends StatefulWidget {
  final CropJoin? cropJoin;

  const InfoModal(
    this.cropJoin, {
    super.key,
  });

  @override
  State<InfoModal> createState() => _InfoModalState();
}

class _InfoModalState extends State<InfoModal> {
  bool isLoading = true;
  Admin currentAdmin = PrefUtils().getAdmin();

  @override
  void initState() {
    super.initState();

    if (widget.cropJoin != null) {
      isLoading = false;
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getItemColumn('Cultura', widget.cropJoin!.cultureTable),
              getItemColumn('Emergência', widget.cropJoin!.emergencyTable),
              getItemColumn('Plantio', widget.cropJoin!.plantTable),
              getItemColumn('Previsão de colheita', '--'),
              getItemColumn(
                'Produtividade',
                widget.cropJoin!.productivity != '--'
                    ? Formatters.formatToBrl(
                        double.parse(widget.cropJoin!.productivity ?? '0'))
                    : widget.cropJoin!.productivity,
              ),
              getItemColumn(
                'Área de lavoura',
                widget.cropJoin!.crop != null
                    ? "${Formatters.formatToBrl(double.parse(widget.cropJoin!.crop!.area ?? '0'))} ${PrefUtils().getAreaUnit()}"
                    : '--',
              ),
              getItemColumn(
                'Última aplicação',
                widget.cropJoin!.applicationTable,
              ),
              getItemColumn(
                'Produção',
                widget.cropJoin!.totalProduction != '--'
                    ? Formatters.formatToBrl(
                        double.parse(widget.cropJoin!.totalProduction ?? '0'))
                    : widget.cropJoin!.totalProduction,
              ),
            ],
          );
  }

  Widget getItemColumn(String title, String? text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17.v,
            ),
          ),
          Text(
            text != null && text != '' ? text : '--',
            style: theme.textTheme.bodyLarge!.copyWith(
              color: appTheme.gray400,
              fontSize: 17.v,
            ),
          )
        ],
      ),
    );
  }
}
