import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/presentation/publications_screen/list/components/category_and_list.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';

class PublicationList extends StatelessWidget {
  int? publicationId;
  int? contentType;
  bool needsToUpdate = PrefUtils().needsToUpdate();

  PublicationList({
    this.publicationId,
    this.contentType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.black600,
        appBar: needsToUpdate ? null : BaseAppBar(),
        drawer: needsToUpdate ? null : DrawerComponent(),
        body: needsToUpdate
            ? UpdateWidget()
            : SizedBox(
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
                                CategoryAndList(
                                  publicationId: publicationId,
                                  contentType: contentType,
                                ),
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
