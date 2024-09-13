import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/presentation/properties_screen/list/components/property_table.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/page_header/page_header.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';

class PropertyList extends StatelessWidget {
  const PropertyList({super.key});

  @override
  Widget build(BuildContext context) {
    bool needsToUpdate = PrefUtils().needsToUpdate();
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: needsToUpdate ? null : _buildAppBar(context),
        body: needsToUpdate
            ? UpdateWidget()
            : SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(shrinkWrap: true, children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 30,
                            right: 20,
                            bottom: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PageHeader(
                                title: 'Propriedades',
                                text:
                                    'Todas as propriedades cadastradas no sistema estão listadas abaixo. Para ver os detalhes da propriedade, clique em qualquer lugar da linha (exceto nos botões de ação)',
                                icon: 'cube',
                              )
                            ],
                          ),
                        ),
                        PropertyTable()
                      ]),
                    ),
                  ],
                ),
              ),
        drawer: needsToUpdate ? null : DrawerComponent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return BaseAppBar();
  }
}
