import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class MonitoringExportModal extends StatelessWidget {
  Function(int) exportFile;
  String currentTabCode;
  Function()? exportImage;

  MonitoringExportModal({
    required this.exportFile,
    required this.currentTabCode,
    this.exportImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentTabCode == 'cultures')
          CustomOutlinedButton(
            text: "Exportar PNG",
            leftIcon: PhosphorIcon(
              IconsList.getIcon('arrow-square-out'),
              size: 20,
            ),
            onPressed: () => exportImage!(),
          )
        else
          Column(
            children: [
              CustomOutlinedButton(
                text: "Exportar PDF",
                leftIcon: PhosphorIcon(
                  IconsList.getIcon('arrow-square-out'),
                  size: 20,
                ),
                onPressed: () => exportFile(2),
              ),
              const SizedBox(height: 10),
              CustomOutlinedButton(
                text: "Exportar XLSX",
                leftIcon: PhosphorIcon(
                  IconsList.getIcon('arrow-square-out'),
                  size: 20,
                ),
                onPressed: () => exportFile(1),
              ),
            ],
          )
      ],
    );
  }
}
