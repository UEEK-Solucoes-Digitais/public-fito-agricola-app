import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/harvest_info/harvest_info.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/info_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/management_data.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/monitoring.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/bottom_bar/bottom_bar_component.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/map_crop/map_crop_native.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CropJoinPage extends StatefulWidget {
  final int cropJoinId;
  final String? page;
  final String? pageSubType;

  const CropJoinPage(this.cropJoinId, this.page, this.pageSubType, {super.key});

  @override
  State<CropJoinPage> createState() => _CropJoinPageState();
}

class _CropJoinPageState extends State<CropJoinPage> {
  String currentTab = 'map';
  bool isLoading = true;
  Property? property;
  Crop? crop;
  Harvest? harvest;
  CropJoin? cropJoin;
  bool needsToUpdate = PrefUtils().needsToUpdate();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getCropJoin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: needsToUpdate ? null : _buildAppBar(context),
        body: isLoading
            ? DefaultCircularIndicator.getIndicator()
            : needsToUpdate
                ? UpdateWidget()
                : getTab(),
        drawer: needsToUpdate ? null : DrawerComponent(),
        bottomNavigationBar: needsToUpdate
            ? null
            : BottomBarComponent(selectedTab: currentTab, setTab: setTab),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return BaseAppBar(
      propertyName: isLoading ? 'Encontre uma lavoura' : property!.name,
      cropHarvestName: isLoading
          ? 'Carregando...'
          : "${cropJoin!.crop!.name} ${cropJoin!.subharvestName ?? ''} - ${cropJoin!.harvest!.name}",
      selectedPropertyId: isLoading ? null : property!.id,
      selectedHarvestId: isLoading ? null : harvest!.id,
      selectedCropJoinId: isLoading ? null : cropJoin!.id,
      showButtonCrop: 1,
      crops: isLoading ? null : property!.crops ?? null,
    );
  }

  Widget getTab() {
    if (currentTab == 'map') {
      return MapCropNative(
        crop: crop,
        cropJoin: cropJoin!,
        crops: property!.crops,
        propertyId: property != null ? property!.id : null,
        harvestId: harvest != null ? harvest!.id : null,
        showDAP: true,
      );
    }

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Expanded(
              child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 40,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${crop!.name} ${cropJoin!.subharvestName ?? ''}",
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                vertical: -4,
                                horizontal: -4,
                              ),
                              onPressed: () {
                                Dialogs.showGeralDialog(
                                  context,
                                  title: 'Informações gerais',
                                  widget: InfoModal(property!.crops!.firstWhere(
                                    (element) => element.cropId == crop!.id,
                                  )),
                                );
                              },
                              icon: PhosphorIcon(
                                IconsList.getIcon('info'),
                                color: Colors.black,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                      getPageTab(),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget getPageTab() {
    switch (currentTab) {
      case 'informations':
        return HarvestInfo(cropJoin!.id);
      case 'management-data':
        return ManagementData(
          cropJoin!.id,
          crop!,
          getCropJoin,
          pageSubType: widget.pageSubType,
        );
      case 'monitoring':
        return Monitoring(
          cropJoinId: cropJoin!.id,
          cropJoins: property != null && property!.crops != null
              ? property!.crops!
              : [],
        );
      default:
        return Container();
    }
  }

  setTab(String tab) {
    setState(() {
      currentTab = tab;
    });
  }

  getCropJoin() async {
    await DefaultRequest.simpleGetRequest(
      '${ApiRoutes.readPropertyHarvest}/${widget.cropJoinId}?with_draw_area=false',
      context,
      showSnackBar: 0,
    ).then((value) {
      Logger().i(value.body.runtimeType);
      final data = jsonDecode(value.body);

      if (data['join'] != null &&
          data['property'] != null &&
          data['crop'] != null &&
          data['harvest'] != null) {
        setState(() {
          cropJoin = CropJoin.fromJson(data['join']);
          property = Property.fromJson(data['property']);
          crop = Crop.fromJson(data['crop']);
          harvest = Harvest.fromJson(data['harvest']);

          if (widget.page != null) {
            setTab(widget.page!);
          }
        });
        isLoading = false;
      } else {
        Navigator.pop(context);
      }
    });
  }
}
