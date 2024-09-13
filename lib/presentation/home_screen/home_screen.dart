import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/database_helper.dart';
import 'package:fitoagricola/core/utils/firebase_token.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/map_crop/map_crop_native.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  Admin admin = PrefUtils().getAdmin();
  bool isLoading = true;
  List<Crop> crops = [];

  bool needsToUpdate = false;

  @override
  void initState() {
    super.initState();

    // postframe
    Future.delayed(Duration.zero, () async {
      FirebaseToken.getDeviceFirebaseToken();

      needsToUpdate = PrefUtils().needsToUpdate();

      getCrops();
      await _checkPostFunction();
      await _checkVersion();
      await _checkSync();
      // await _checkRoutesDeprecated();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA70001,
        appBar: needsToUpdate ? null : _buildAppBar(context),
        body: isLoading
            ? DefaultCircularIndicator.getIndicator()
            : needsToUpdate
                ? UpdateWidget()
                : MapCropNative(
                    crops: crops,
                  ),
        drawer: needsToUpdate ? null : DrawerComponent(),
        // floatingActionButton: FloatingButtonComponent(),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return BaseAppBar();
  }

  _checkPostFunction() async {
    List operations = PrefUtils().getAllPostRequest();

    if (operations.isNotEmpty) {
      ConnectivityResult internetType =
          await NetworkOperations.checkConnectionType();
      if (internetType == ConnectivityResult.wifi) {
        Dialogs.showLoadingDialog(
          context,
          title: "Sincronizando requisições offline",
          text: "Aguarde para enviar as informações que você armazenou offline",
        );

        try {
          await NetworkOperations.checkPostQueue();
        } catch (e) {
          Logger().e(e);
        }

        Navigator.pop(context);
      }
    }
  }

  _checkSync() async {
    if (await PrefUtils().getLastSync() == '' &&
        (admin.propertiesCount == null ||
            (admin.propertiesCount != null && admin.propertiesCount! > 0))) {
      Dialogs.showGeralDialog(context,
          title: "App não sincronizado",
          text:
              "Você ainda não sincronizou seu aplicativo para funcionar offline! Clique no botão abaixo para ir para a tela de sincronização.",
          widget: Column(
            children: [
              CustomElevatedButton(
                text: "Entendi",
                height: 45.v,
                onPressed: () {
                  NavigatorService.pushNamed(AppRoutes.offlinePage);
                },
              ),
              const SizedBox(height: 5),
              CustomOutlinedButton(
                text: "Não sincronizar agora",
                height: 45.v,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
    } else {
      // checando se há dados sincronizados na forma antiga e passando para o SQLite
      final oldRoutes = PrefUtils().getAllDataOffline();
      if (oldRoutes != null) {
        final oldRoutesJson = jsonDecode(oldRoutes);

        // Map<String, dynamic> newData = {};

        if (oldRoutesJson['all_routes_data'] != null) {
          Dialogs.showGeralDialog(
            context,
            title: "Ajustes offline",
            text:
                "Foram realizados alguns ajustes para melhorar a experiência offline no aplicativo. Mas para isso acontecer, é necessário sincronizar suas propriedades novamente. Caso contrário, seu app não funcionará offline.",
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomElevatedButton(
                    text: "Sincronizar agora",
                    onPressed: () async {
                      await PrefUtils().removePostRequest("all_routes_data");
                      NavigatorService.pushNamed(AppRoutes.offlinePage);
                    }),
                const SizedBox(height: 5),
                CustomOutlinedButton(
                    text: "Sincronizar depois",
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          );
          // final allData = jsonDecode(oldRoutesJson['all_routes_data']);

          // for (var key in allData.keys) {
          //   newData[key] = allData[key];
          // }

          // await PrefUtils().setBulkSQLOfflineData(newData);
          // remover dados antigos
        }
      }
    }
  }

  _checkVersion() async {
    ConnectivityResult internetType =
        await NetworkOperations.checkConnectionType();
    if (internetType == ConnectivityResult.wifi) {
      final version = await DefaultRequest.simpleGetRequest(
        ApiRoutes.appVersion,
        context,
        showSnackBar: 0,
      );

      if (version.statusCode != 200) {
        return;
      }

      final data = jsonDecode(version.body);
      String versionApp = '';
      String nextVersionApp = '';

      if (Platform.isAndroid) {
        versionApp = data['app_version']['android_version'].toString();
        nextVersionApp = data['app_version']['next_android_version'].toString();
      } else {
        versionApp = data['app_version']['ios_version'].toString();
        nextVersionApp = data['app_version']['next_ios_version'].toString();
      }

      if ((int.parse(versionApp.toString()) != PrefUtils().getVersion()) &&
          (int.parse(nextVersionApp.toString()) != PrefUtils().getVersion())) {
        PrefUtils().setNeedsToUpdate(true);
        setState(() {
          needsToUpdate = true;
        });
      } else {
        PrefUtils().setNeedsToUpdate(false);
        setState(() {
          needsToUpdate = false;
        });
      }
    }
  }

  _checkRoutesDeprecated() async {
    final routes = await PrefUtils().getAllRoutes();

    // Logger().i("actual: ${routes}");
    List<String> routesToRemove = [];
    final currentHarvest = PrefUtils().getActualHarvest();

    for (var route in routes) {
      if (route.contains(ApiRoutes.getOfflineFirstPart) ||
          route.contains(ApiRoutes.getOfflineSecondPart)) {
        routesToRemove.add(route);
      } else {
        if (currentHarvest != null) {
          if (!route.contains("harvests_id=${currentHarvest.toString()}")) {
            routesToRemove.add(route);
          }
        }
      }
    }

    // Logger().i("remove: ${routesToRemove}");
    if (routesToRemove.isNotEmpty) {
      DatabaseHelper().removeBulkData(routesToRemove);
    }
  }

  getCrops() async {
    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.listSeeds}/${admin.id}',
      context,
      showSnackBar: 0,
    ).then(
      (value) {
        final data = jsonDecode(value.body);
        PrefUtils().setSeed(data['cultures']);
      },
    );

    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.getCrops}/${admin.id}',
      context,
      showSnackBar: 0,
    ).then(
      (value) {
        final data = jsonDecode(value.body);

        setState(() {
          if (data['crops'] != null) {
            crops = Crop.fromJsonList(data['crops']);
          }
          print('finalizado');
          isLoading = false;
        });
      },
    );
  }
}
