import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:flutter/material.dart';

class PropertyInfo extends StatefulWidget {
  final int propertyId;

  const PropertyInfo(
    this.propertyId, {
    super.key,
  });

  @override
  State<PropertyInfo> createState() => _PropertyInfoState();
}

class _PropertyInfoState extends State<PropertyInfo> {
  bool isLoading = true;
  Admin currentAdmin = PrefUtils().getAdmin();
  Property? property;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      getProperty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getItemColumn(
                "Nome da propriedade",
                property!.name,
              ),
              getItemColumn(
                "CEP",
                property!.cep,
              ),
              getItemColumn(
                "Município, Estado",
                "${property!.city}, ${property!.uf}",
              ),
              getItemColumn(
                "Inscrição Estadual",
                property!.stateSubscription,
              ),
              getItemColumn(
                "Logradouro, nº",
                property!.street != ''
                    ? "${property!.street}, ${property!.number}"
                    : null,
              ),
              getItemColumn(
                "Bairro",
                property!.neighborhood,
              ),
              getItemColumn(
                "Complemento",
                property!.complement,
              ),
              getItemColumn(
                "CNPJ",
                property!.cnpj,
              ),
              getItemColumn(
                  "Latitude, Longitude",
                  property!.coordinates != null
                      ? property!.coordinates['coordinates'][1].toString() +
                          ", " +
                          property!.coordinates['coordinates'][0].toString()
                      : '--'),
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
              fontSize: 17,
            ),
          ),
          Text(
            text != null && text != '' ? text : '--',
            style: theme.textTheme.bodyLarge!.copyWith(
              color: appTheme.gray400,
              fontSize: 17,
            ),
          )
        ],
      ),
    );
  }

  getProperty() async {
    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.readProperties}/${widget.propertyId}?read_simple=true",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        property = Property.fromJson(data['property']);
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
      Navigator.pop(context);
    });
  }
}
