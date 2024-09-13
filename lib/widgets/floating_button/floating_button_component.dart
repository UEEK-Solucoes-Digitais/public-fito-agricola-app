import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/floating_button/components/register_activity_modal.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FloatingButtonComponent extends StatefulWidget {
  final int? propertyId;
  final int? harvestId;

  const FloatingButtonComponent({
    this.harvestId,
    this.propertyId,
    super.key,
  });

  @override
  State<FloatingButtonComponent> createState() =>
      _FloatingButtonComponentState();
}

class _FloatingButtonComponentState extends State<FloatingButtonComponent> {
  bool isOpen = false;

  final List options = [
    {
      "icon": 'plant',
      "text": "Plantio",
      "onTap": "seed",
    },
    {
      "icon": 'waves',
      "text": "Fertilizantes",
      "onTap": "fertilizer",
    },
    {
      "icon": 'flask',
      "text": "Aplicação",
      "onTap": "defensive",
    },
    {
      "icon": 'tractor',
      "text": "Colheita",
      "onTap": "harvest",
    },
    {
      "icon": 'cloud-rain',
      "text": "Chuva",
      "onTap": "rain",
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 10,
      child: Column(
        children: [
          AnimatedOpacity(
            opacity: isOpen ? 1 : 0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var option in options)
                  GestureDetector(
                    onTap: () {
                      Dialogs.showGeralDialog(
                        context,
                        title: "Registrar atividade - ${option['text']}",
                        text:
                            "Preencha os campos abaixo para registrar a atividade",
                        widget: RegisterActivityModal(
                          propertyId: widget.propertyId,
                          harvestId: widget.harvestId,
                          code: option["onTap"],
                          contextScreen: context,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 7),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.v),
                            child: PhosphorIcon(
                              option["icon"] == 'tractor'
                                  ? Icons.agriculture_outlined
                                  : IconsList.getIcon(option["icon"]),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            option["text"],
                            style: CustomTextStyles.bodyMediumWhite,
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.all(20.v),
              child: PhosphorIcon(
                IconsList.getIcon('plus'),
                color: Colors.white,
                size: 20.v,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
