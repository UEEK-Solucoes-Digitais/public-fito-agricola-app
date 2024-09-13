import 'dart:async';
import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/presentation/properties_screen/details/components/changeLinkedCrops.dart';
import 'package:fitoagricola/presentation/properties_screen/details/components/property_detail_header.dart';
import 'package:fitoagricola/presentation/properties_screen/details/components/property_detail_table.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_text_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';

class PropertyDetails extends StatefulWidget {
  final int propertyId;
  final int? harvestId;

  const PropertyDetails(this.propertyId, {this.harvestId, super.key});

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  bool isLoading = true;
  Property? property;
  Harvest? harvest;
  bool isLastHarvest = true;

  TextEditingController debouncedSearch = TextEditingController();
  Timer? searchDebounce;
  String lastSearchText = '';

  bool needsToUpdate = PrefUtils().needsToUpdate();

  @override
  void initState() {
    super.initState();

    debouncedSearch.addListener(_onSearchChanged);

    Future.delayed(Duration.zero, () {
      getPropertyDetails();
    });
  }

  @override
  void dispose() {
    debouncedSearch.removeListener(_onSearchChanged);
    debouncedSearch.dispose();
    searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: needsToUpdate ? null : _buildAppBar(context),
        body: needsToUpdate
            ? UpdateWidget()
            : SizedBox(
                width: double.maxFinite,
                child: isLoading
                    ? DefaultCircularIndicator.getIndicator()
                    : Column(
                        children: [
                          Expanded(
                            child: ListView(shrinkWrap: true, children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  top: 30,
                                  right: 20,
                                  bottom: 40,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.propertyList);
                                      },
                                      leftIcon: 'arrow-left',
                                      text: "Propriedades",
                                    ),
                                    Container(
                                      decoration: AppDecoration.boxDecoration,
                                      margin: EdgeInsets.only(top: 20),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PropertyDetailHeader(
                                            property: property,
                                            harvest: harvest,
                                            isLastHarvest: isLastHarvest,
                                          ),
                                          if (property!.crops!.isNotEmpty)
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20,
                                                    top: 10,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            CustomTextFormField(
                                                          debouncedSearch,
                                                          '',
                                                          'Pesquisar lavoura',
                                                          icon:
                                                              'magnifying-glass',
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 15,
                                                        ),
                                                        child:
                                                            CustomActionButton(
                                                          width: 35,
                                                          height: 35,
                                                          icon: 'pencil',
                                                          onTap: () =>
                                                              _openLinkedCropsModal(),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                PropertyDetailTable(
                                                  property,
                                                  getPropertyDetails,
                                                ),
                                              ],
                                            )
                                          else
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 20,
                                                left: 20,
                                                bottom: 30,
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Dê inicio ao seu ano agrícola",
                                                    style: theme.textTheme
                                                        .displayMedium,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  CustomFilledButton(
                                                    height: 40,
                                                    text:
                                                        "Iniciar ano agrícola",
                                                    onPressed:
                                                        _openLinkedCropsModal,
                                                  ),
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
    return BaseAppBar(
      propertyName: isLoading ? 'Encontre uma lavoura' : property!.name,
      selectedPropertyId: widget.propertyId,
    );
  }

  void _onSearchChanged() {
    if (debouncedSearch.text == lastSearchText) {
      return; // Não faz nada se o texto não mudou
    }

    if (searchDebounce?.isActive ?? false) searchDebounce?.cancel();

    searchDebounce = Timer(const Duration(milliseconds: 500), () {
      lastSearchText = debouncedSearch.text;

      SnackbarComponent.showSnackBar(
        context,
        'loading',
        'Filtrando lavouras',
        duration: Duration(seconds: 1),
      );
      getPropertyDetails();
    });
  }

  getPropertyDetails() {
    setState(() {
      isLoading = true;
    });

    String url =
        "${ApiRoutes.readProperties}/${widget.propertyId}?read_simple=true&filter=${debouncedSearch.text}";

    if (widget.harvestId != null) {
      url += "&harvest_id=${widget.harvestId}";
    }

    DefaultRequest.simpleGetRequest(
      url,
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      if (data['property'] != null) {
        property = Property.fromJson(data['property']);
      }

      if (data['harvest'] != null) {
        harvest = Harvest.fromJson(data['harvest']);
        isLastHarvest = data['isLastHarvert'];
      }

      isLoading = false;
      setState(() {});
    });
  }

  _openLinkedCropsModal() {
    Dialogs.showGeralDialog(
      context,
      title: property!.crops!.isEmpty
          ? "Iniciar ano agrícola"
          : "Editar ano agrícola",
      widget: ChangeLinkedCrops(
        property: property!,
        harvest: harvest!,
        redirectFunction: getPropertyDetails,
      ),
    );
  }
}
