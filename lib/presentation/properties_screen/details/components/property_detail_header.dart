import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:flutter/material.dart';

class PropertyDetailHeader extends StatelessWidget {
  final Property? property;
  final Harvest? harvest;
  bool isLastHarvest;

  PropertyDetailHeader(
      {this.property, this.harvest, this.isLastHarvest = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      padding: EdgeInsets.only(bottom: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray300,
          ),
        ),
      ),
      child: Text(
        "${property!.name} ${harvest != null ? '\n${isLastHarvest ? "Ano Agrícola atual ${harvest!.name}" : harvest!.name}' : ''}",
        style: CustomTextStyles.propertyTitle,
      ),
    );
  }
}
