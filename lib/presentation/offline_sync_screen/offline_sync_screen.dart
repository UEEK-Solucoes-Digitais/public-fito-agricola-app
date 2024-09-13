import 'dart:convert';
import 'dart:isolate';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/custom_dialog/custom_dialog.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/page_header/page_header.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OfflineSyncPage extends StatefulWidget {
  const OfflineSyncPage({super.key});

  @override
  State<OfflineSyncPage> createState() => _OfflineSyncPageState();
}

class _OfflineSyncPageState extends State<OfflineSyncPage> {
  String lastSync = '';
  double step = 0;
  bool isSyncing = false;
  bool isSyncingPost = false;
  bool isLoading = true;
  String textSync = '';
  Admin admin = PrefUtils().getAdmin();
  bool needsToUpdate = false;

  List<Property> properties = [];
  List selectedProperties = [];
  dynamic syncProperties;

  int currentProperty = 1;
  int currentHarvest = 1;
  int currentCrop = 1;

  bool hasInternet = true;
  List operations = [];

  @override
  void initState() {
    super.initState();

    lastSync = PrefUtils().getLastSync();

    Future.delayed(Duration.zero, () async {
      await PrefUtils().reload();
      hasInternet = await NetworkOperations.checkConnection();
      needsToUpdate = PrefUtils().needsToUpdate();

      getProperties();

      operations = PrefUtils().getAllPostRequest();

      Logger().e(operations);
      syncProperties = await PrefUtils().getSyncProperties();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: needsToUpdate ? null : BaseAppBar(),
        body: needsToUpdate
            ? UpdateWidget()
            : SizedBox(
                width: double.maxFinite,
                child: Column(
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
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PageHeader(
                                      title: 'Sincronizar offline',
                                      text:
                                          'Utilize o botão abaixo para sincronizar somente os itens essenciais para cadastros. Isso não irá salvar todas as leituras do sistema.',
                                      icon: 'arrows-clockwise',
                                    ),
                                    _buildSyncOffline(),
                                    _buildPostOffline(),
                                  ],
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
        drawer: needsToUpdate ? null : DrawerComponent(),
      ),
    );
  }

  _buildSyncOffline() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: isLoading
          ? DefaultCircularIndicator.getIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ultima sincronização",
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  lastSync.isEmpty ? 'Nunca sincronizado' : lastSync,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (properties.length > 3 && hasInternet)
                      _buildLotProperties()
                    else
                      Column(
                        children: [
                          getLoadingItens(),
                          hasInternet
                              ? CustomFilledButton(
                                  text: isSyncing ? "" : "Sincronizar leituras",
                                  height: 40.v,
                                  leftIcon: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: isSyncing
                                        ? DefaultCircularIndicator.getIndicator(
                                            size: 20,
                                            color: Colors.white,
                                          )
                                        : PhosphorIcon(
                                            IconsList.getIcon(
                                                'arrows-clockwise'),
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                  ),
                                  isDisabled: isSyncing || isSyncingPost,
                                  onPressed: isSyncing || isSyncingPost
                                      ? null
                                      : () {
                                          _buildIsolatedTask();
                                        },
                                )
                              : Container(),
                        ],
                      ),
                  ],
                )
              ],
            ),
    );
  }

  _buildLotProperties() {
    return Column(
      children: [
        getLoadingItens(),
        if (isSyncing || isSyncingPost)
          DefaultCircularIndicator.getIndicator()
        else
          CustomFilledButton(
              text: "Selecionar propriedades",
              height: 40.v,
              isDisabled: isSyncing || isSyncingPost,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return CustomDialog(
                          title: "Selecionar propriedades",
                          text: "",
                          buttons: [
                            Column(
                              children: [
                                for (var property in properties)
                                  CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    checkColor: Colors.white,
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(property.name),
                                        ),
                                        if (syncProperties != null &&
                                            syncProperties.contains(
                                                property.id.toString()))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: PhosphorIcon(
                                              IconsList.getIcon('check'),
                                              color: appTheme.green400,
                                            ),
                                          ),
                                      ],
                                    ),
                                    value: selectedProperties
                                        .contains(property.id),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedProperties.add(property.id);
                                        } else {
                                          selectedProperties
                                              .remove(property.id);
                                        }
                                      });
                                    },
                                  ),
                                CustomFilledButton(
                                  text: "Concluir",
                                  height: 40.v,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _buildIsolatedTask();
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              })
      ],
    );
  }

  _buildIsolatedTask() async {
    final result = await Isolate.run(() async {
      
      if (!await PrefUtils().isInitialized) {
        await PrefUtils().init();
      }

      final firstPart = await DefaultRequest.simpleGetRequest(
        ApiRoutes.getOfflineFirstPart,
        null,
        showSnackBar: 0,
      ).then((value) {
        final data = jsonDecode(value.body);

        return data['routes'];
      });

      Logger().i(firstPart);

      return true;
    });

    print(result);
  }

  _buildPostOffline() {
    return Container(
      // margin: EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Requisições à processar",
                style: theme.textTheme.bodyMedium,
              ),
              !isSyncingPost
                  ? hasInternet && operations.isNotEmpty
                      ? CustomActionButton(
                          icon: 'upload-simple',
                          onTap: () {},
                        )
                      : Container()
                  : DefaultCircularIndicator.getIndicator(size: 20),
            ],
          ),
          const SizedBox(height: 15),
          operations.isNotEmpty
              ? ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    for (var operation in operations)
                      if (!operation['url'].contains(ApiRoutes.errorLog) ||
                          (operation['url'].contains(ApiRoutes.errorLog) &&
                              operation['status'] == 3))
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appTheme.gray300,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                operation['name'] != null
                                    ? operation['name']
                                    : 'Requisição genérica',
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 5,
                                    width: 5,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        color: _getColor(operation['status']),
                                        borderRadius:
                                            BorderRadius.circular(999)),
                                  ),
                                  Text(
                                    _getText(operation['status']),
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: _getColor(operation['status']),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget getLoadingItens() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (textSync != '')
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              textSync,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        LinearProgressIndicator(
          value: step,
          backgroundColor: appTheme.gray300,
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  void getProperties() {
    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.listProperties}/${admin.id}',
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        properties = Property.fromJsonList(data['properties']);
        isLoading = false;
      });
    });
  }

  Color _getColor(status) {
    switch (status) {
      case 0:
        return appTheme.gray400;
      case 1:
        return appTheme.amber400;
      case 2:
        return appTheme.green400;
      case 3:
        return appTheme.red600;
      default:
        return appTheme.gray400;
    }
  }

  String _getText(status) {
    switch (status) {
      case 0:
        return "Aguardando conexão";
      case 1:
        return "Na fila/processando";
      case 2:
        return "Enviada";
      case 3:
        return "Erro";
      default:
        return "Aguardando conexão";
    }
  }
}
