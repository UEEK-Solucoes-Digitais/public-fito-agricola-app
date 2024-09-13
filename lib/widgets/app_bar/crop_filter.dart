import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/filter_crop.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';

class CropFilter extends StatefulWidget {
  final int? selectedPropertyId;
  final int? selectedHarvestId;
  final int? selectedCropJoinId;

  const CropFilter(
      {Key? key,
      this.selectedPropertyId = 0,
      this.selectedHarvestId = 0,
      this.selectedCropJoinId = 0})
      : super(key: key);

  @override
  State<CropFilter> createState() => _CropFilterState();
}

class _CropFilterState extends State<CropFilter> {
  bool isLoading = true;
  bool isLoadingCrops = false;
  Admin admin = PrefUtils().getAdmin();

  Map<String, dynamic> filterOptions = {
    'propertyId': 0,
    'harvestId': 0,
    'cropJoinId': 0,
  };

  List<Property> properties = [
    Property(id: 0, name: "Selecione a propriedade"),
  ];

  List<Harvest> harvests = [
    Harvest(id: 0, name: "Selecione o ano agrícola"),
  ];

  List<CropJoin> cropJoin = [
    CropJoin(
      id: 0,
      propertyId: 0,
      harvestId: 0,
      cropId: 0,
      crop: Crop(id: 0, name: "Selecione a lavoura"),
    ),
  ];

  @override
  void initState() {
    super.initState();

    new Future.delayed(Duration.zero, () {
      getItens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.89,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: isLoading
                  ? Center(child: DefaultCircularIndicator.getIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownSearchComponent(
                          items: properties
                              .map((e) =>
                                  DropdownSearchModel(id: e.id, name: e.name))
                              .toList(),
                          label: '',
                          hintText: 'Selecione a propriedade',
                          selectedId: filterOptions['propertyId'],
                          icon: 'user-rectangle',
                          validatorFunction: false,
                          onChanged: (value) =>
                              changeFilterOptions('propertyId', value.id),
                        ),
                        SizedBox(height: 20),
                        DropdownSearchComponent(
                          items: harvests
                              .map((e) =>
                                  DropdownSearchModel(id: e.id, name: e.name))
                              .toList(),
                          label: '',
                          hintText: 'Selecione o ano agrícola',
                          selectedId: filterOptions['harvestId'],
                          icon: 'calendar-blank',
                          validatorFunction: false,
                          onChanged: (value) =>
                              changeFilterOptions('harvestId', value.id),
                        ),
                        SizedBox(height: 20),
                        isLoadingCrops
                            ? Center(
                                child: DefaultCircularIndicator.getIndicator())
                            : DropdownSearchComponent(
                                items: cropJoin
                                    .map((e) => DropdownSearchModel(
                                        id: e.id,
                                        name: e.subharvestName != null
                                            ? "${e.crop!.name} ${e.subharvestName!}"
                                            : (e.crop != null
                                                ? e.crop!.name
                                                : '')))
                                    .toList(),
                                label: '',
                                validatorFunction: false,
                                hintText: 'Selecione a lavoura',
                                selectedId: filterOptions['cropJoinId'],
                                icon: 'drop-half',
                                onChanged: (value) =>
                                    changeFilterOptions('cropJoinId', value.id),
                              ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  void getItens() {
    DefaultRequest.simpleGetRequest(
            '${ApiRoutes.getItens}/${admin.id}?filter=simple&with_join=true',
            context,
            showSnackBar: 0)
        .then((value) {
      isLoading = false;

      filterOptions = {
        'propertyId': widget.selectedPropertyId ?? 0,
        'harvestId': widget.selectedHarvestId ?? 0,
        'cropJoinId': widget.selectedCropJoinId ?? 0,
      };

      final data = jsonDecode(value.body);

      // print(data);

      if (data['properties'] != null) {
        data['properties'].forEach((e) {
          properties.add(Property.fromJson(e));
        });

        int? actualUserHarvest = PrefUtils().getActualHarvest();

        if (actualUserHarvest != null) {
          filterOptions['harvestId'] = actualUserHarvest;
        }
        data['harvests'].forEach((e) {
          harvests.add(Harvest.fromJson(e));

          if (actualUserHarvest == null &&
              e['id'] == data['last_harvest_id'] &&
              (widget.selectedHarvestId == 0 ||
                  widget.selectedHarvestId == null)) {
            filterOptions['harvestId'] = e['id'];
          }
        });

        if (properties.length == 2) {
          filterOptions['propertyId'] = properties[1].id;
        }
      }

      setState(() {});

      if (filterOptions['propertyId'] != 0 && filterOptions['harvestId'] != 0) {
        getCrops();
      }
    }).catchError((error) {
      print(error);
      isLoading = false;
      setState(() {});

      Navigator.pop(context);

      SnackbarComponent.showSnackBar(
        context,
        'error',
        'Ocorreu um erro ao buscar as informações, tente novamente.',
      );
    });
  }

  void changeFilterOptions(key, value) {
    setState(() {
      filterOptions[key] = value;
    });

    if (filterOptions['propertyId'] != 0 &&
        filterOptions['harvestId'] != 0 &&
        filterOptions['cropJoinId'] != 0 &&
        key != 'harvestId' &&
        cropJoin.length > 1 &&
        cropJoin[1].propertyId == filterOptions['propertyId']) {
      FilterCrop.filterCrop(context, filterOptions['cropJoinId']);
    } else {
      getCrops();
    }
  }

  void getCrops() {
    setState(() {
      isLoadingCrops = true;
    });
    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.getCropsByPropertyAndHarvest}?property_id=${filterOptions['propertyId']}&harvest_id=${filterOptions['harvestId']}',
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      cropJoin.removeWhere((element) => element.id != 0);

      if (data['joins'] != null) {
        data['joins'].forEach((e) {
          cropJoin.add(CropJoin.fromJson(e));
        });
      } else {
        Navigator.pop(context);
      }
      isLoadingCrops = false;

      setState(() {});
    }).catchError((error) {
      print(error);
      Navigator.pop(context);
      SnackbarComponent.showSnackBar(
        context,
        'error',
        'Ocorreu um erro ao buscar as informações, tente novamente.',
      );
    });
  }
}
