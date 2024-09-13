import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';

class FilterCrop {
  static bool isDialogOpen(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent == false;
  }

  static void filterCrop(BuildContext context, dynamic cropJoinId) {
    NavigatorService.pushNamed(
      AppRoutes.cropJoinPage,
      arguments: {
        'cropJoinId': cropJoinId,
        // 'harvestId': property.harvestId,
      },
    );
  }

  static void filterCropByCropId(BuildContext context, dynamic cropId) {
    if (isDialogOpen(context)) {
      Navigator.pop(context);
    }

    SnackbarComponent.showSnackBar(
      context,
      'loading',
      'Buscando lavoura',
    );

    Admin admin = PrefUtils().getAdmin();

    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.readCropJoin}${cropId}&admin_id=${admin.id}",
      context,
    ).then((value) {
      final data = jsonDecode(value.body);

      if (data['property_crop_join'] != null) {
        SnackbarComponent.showSnackBar(
          context,
          'success',
          'Lavoura encontrada',
        );

        final cropJoinId = data['property_crop_join']['id'];

        filterCrop(context, cropJoinId);
      } else {
        SnackbarComponent.showSnackBar(
          context,
          'error',
          'Lavoura não encontrada',
        );
      }
    });
  }
}
