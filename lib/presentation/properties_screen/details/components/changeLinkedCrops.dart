import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChangeLinkedCrops extends StatefulWidget {
  Property property;
  Harvest harvest;
  Function() redirectFunction;

  ChangeLinkedCrops({
    required this.harvest,
    required this.property,
    required this.redirectFunction,
    super.key,
  });

  @override
  State<ChangeLinkedCrops> createState() => _ChangeLinkedCropsState();
}

class _ChangeLinkedCropsState extends State<ChangeLinkedCrops> {
  List<Crop> availableCrops = [];
  List<Crop> linkedCrops = [];
  bool isLoading = true;
  bool isSubmitting = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "LAVOURAS ADICIONADAS (${linkedCrops.length})",
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var crop in linkedCrops) _buildCropCard(crop, 2),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "LAVOURAS DISPONÍVEIS (${availableCrops.length})",
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var crop in availableCrops) _buildCropCard(crop, 1),
                ],
              ),
              const SizedBox(height: 30),
              CustomFilledButton(
                isDisabled: isSubmitting,
                onPressed: () {
                  _submitForm();
                },
                text: "Salvar",
              ),
              const SizedBox(height: 10),
              CustomOutlinedButton(
                isDisabled: isSubmitting,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Cancelar",
              )
            ],
          );
  }

  _buildCropCard(Crop crop, int type) {
    return GestureDetector(
      onTap: () {
        if (type == 1) {
          //  removendo do available e colocando no linked
          _linkCrop(crop);
        } else {
          //  removendo do linked e colocando no available
          _unlinkCrop(crop);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: type == 1 ? appTheme.gray400 : theme.colorScheme.secondary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "${crop.name} ${crop.subharvestName ?? ''}",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: type == 1 ? appTheme.gray400 : theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  _linkCrop(Crop crop) {
    // apenas removendo das variáveis
    setState(() {
      availableCrops.removeWhere((element) => element.id == crop.id);
      linkedCrops.add(crop);
    });
  }

  _unlinkCrop(Crop crop) {
    // apenas removendo das variáveis
    setState(() {
      linkedCrops.removeWhere((element) => element.id == crop.id);
      availableCrops.add(crop);
    });
  }

  _getCrops() async {
    await DefaultRequest.simpleGetRequest(
      "${ApiRoutes.getLinkedCrops}/${widget.property.id}?harvest_id=${widget.harvest.id}",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      if (data['linked_crops'] != null) {
        linkedCrops = Crop.fromJsonList(data['linked_crops']);
        setState(() {
          linkedCrops = linkedCrops
              .where((element) => element.isSubharvest == 0)
              .toList();
        });
      }

      if (data['available_crops'] != null) {
        setState(() {
          availableCrops = Crop.fromJsonList(data['available_crops']);
        });
      }
      isLoading = false;

      setState(() {});
    });
  }

  _submitForm() {
    setState(() {
      isSubmitting = true;
    });

    List<int> linkedCropsIds = linkedCrops.map((e) => e.id).toList();

    Admin admin = PrefUtils().getAdmin();

    DefaultRequest.simplePostRequest(
      ApiRoutes.linkCrops,
      {
        "admin_id": admin.id,
        "property_id": widget.property.id,
        "harvest_id": widget.harvest.id,
        "crops": linkedCropsIds,
      },
      context,
    ).then((value) {
      if (value) {
        widget.redirectFunction();
      }
    }).catchError((error) {
      Logger().e(error);
    }).whenComplete(() {
      setState(() {
        isSubmitting = false;
      });
      Navigator.pop(context);
    });
  }
}
