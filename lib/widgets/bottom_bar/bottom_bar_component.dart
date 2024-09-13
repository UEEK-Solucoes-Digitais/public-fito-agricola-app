import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomBarComponent extends StatefulWidget {
  String selectedTab;
  Function(String)? setTab;

  BottomBarComponent({this.selectedTab = 'map', this.setTab, super.key});

  @override
  State<BottomBarComponent> createState() => _BottomBarComponentState();
}

class _BottomBarComponentState extends State<BottomBarComponent> {
  bool grantedPermissions = true;

  final buttonList = [
    {
      'icon': 'map-pin',
      'text': 'Mapa',
      'value': 'map',
    },
    {
      'icon': 'chart-donut',
      'text': 'Informações',
      'value': 'informations',
    },
    {
      'icon': 'clipboard-text',
      'text': 'Manejo',
      'value': 'management-data',
    },
    {
      'icon': 'file-magnifying-glass',
      'text': 'Monitoramento',
      'value': 'monitoring',
    },
  ];

  @override
  void initState() {
    super.initState();

    // GeneralSettings().checkLocationPermissions().then((value) => {
    //       setState(() {
    //         // print("garantido: $value");
    //         grantedPermissions = value;
    //       })
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 65,
      notchMargin: 0,
      padding: EdgeInsets.all(0),
      elevation: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var button in buttonList)
            GestureDetector(
              onTap: () => widget.setTab != null
                  ? widget.setTab!(button['value'] as String)
                  : {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PhosphorIcon(
                      IconsList.getIcon(button['icon'] as String),
                      size: 26,
                      color: widget.selectedTab == button['value']
                          ? theme.colorScheme.secondary
                          : appTheme.gray300,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      button['text'] as String,
                      style: TextStyle(
                        color: widget.selectedTab == button['value']
                            ? Color(0xFF152536)
                            : appTheme.gray400,
                        fontSize: 12.v,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
