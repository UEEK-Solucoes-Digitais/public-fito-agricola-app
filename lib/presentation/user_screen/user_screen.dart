import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/presentation/user_screen/components/user_form.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/page_header/page_header.dart';
import 'package:flutter/material.dart';

class UserScreenPage extends StatelessWidget {
  const UserScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: BaseAppBar(),
        drawer: DrawerComponent(),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
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
                            title: 'Meus dados',
                            text: 'Edite suas informações abaixo',
                            icon: 'user',
                          ),
                          UserForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
