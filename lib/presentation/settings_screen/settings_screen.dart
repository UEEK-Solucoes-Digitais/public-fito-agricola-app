import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

enum MetricUnits { ha, alq }

class _SettingsScreenState extends State<SettingsScreen> {
  MetricUnits? metricUnit = MetricUnits.ha;
  List<Harvest> harvests = [];
  Admin admin = PrefUtils().getAdmin();
  bool hasInternet = true;

  bool isLoadingHarvests = true;

  int? harvestValue;

  bool isSync = false;

  @override
  void initState() {
    super.initState();

    final currentMetric = PrefUtils().getAreaUnit();

    if (currentMetric == 'ha') {
      metricUnit = MetricUnits.ha;
    } else {
      metricUnit = MetricUnits.alq;
    }

    Future.delayed(Duration.zero, () async {
      _getHarvests();

      final connectivityType = await NetworkOperations.checkConnectionType();

      if (connectivityType != ConnectivityResult.wifi) {
        hasInternet = false;
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: ListView(shrinkWrap: true, children: [
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
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 40,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                visualDensity: const VisualDensity(
                                  vertical: -4,
                                  horizontal: -4,
                                ),
                                dense: true,
                                title: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: PhosphorIcon(
                                        IconsList.getIcon('gear'),
                                        color: theme.colorScheme.secondary,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      'Configurações',
                                      style:
                                          theme.textTheme.bodyLarge!.copyWith(
                                        color: theme.colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                visualDensity: const VisualDensity(
                                  vertical: -4,
                                  horizontal: -4,
                                ),
                                onTap: () async {
                                  try {
                                    await launchUrl(
                                        Uri.parse(
                                            "${dotenv.env['SYSTEM_URL']}/politica-de-privacidade"),
                                        mode: LaunchMode.externalApplication);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                dense: true,
                                title: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: PhosphorIcon(
                                        IconsList.getIcon('lock'),
                                        color: theme.colorScheme.secondary,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      'Política de privacidade',
                                      style: theme.textTheme.bodyLarge,
                                    )
                                  ],
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                visualDensity: const VisualDensity(
                                  vertical: -4,
                                  horizontal: -4,
                                ),
                                onTap: () async {
                                  try {
                                    await launchUrl(
                                        Uri.parse(
                                            "${dotenv.env['SYSTEM_URL']}/termos-de-uso"),
                                        mode: LaunchMode.externalApplication);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                dense: true,
                                title: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: PhosphorIcon(
                                        IconsList.getIcon('book'),
                                        color: theme.colorScheme.secondary,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      'Termos de uso',
                                      style: theme.textTheme.bodyLarge,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 40,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: PhosphorIcon(
                                      IconsList.getIcon('gear'),
                                      color: theme.colorScheme.secondary,
                                      size: 22,
                                    ),
                                  ),
                                  Text(
                                    'Configurações',
                                    style: theme.textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Selecione o ano agrícola que você está trabalhando",
                                style: theme.textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (isLoadingHarvests)
                                DefaultCircularIndicator.getIndicator()
                              else if (!hasInternet)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Você está trabalhando na safra ${harvestValue == null ? 'atual' : harvests.firstWhere((element) => element.id == harvestValue).name}\nSó é possível alterar a safra utilizando o Wi-Fi",
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var harvest in harvests)
                                      ListTile(
                                        visualDensity: const VisualDensity(
                                          horizontal: -4,
                                          vertical: -4,
                                        ),
                                        onTap: () {
                                          _handleSelectHarvest(
                                            harvest.id,
                                            harvest.isLastHarvert!,
                                          );
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: Row(
                                          children: [
                                            Radio(
                                              value: harvest.id,
                                              groupValue: harvestValue,
                                              visualDensity:
                                                  const VisualDensity(
                                                vertical: -4,
                                                horizontal: -4,
                                              ),
                                              onChanged: (value) {},
                                            ),
                                            Text(
                                              harvest.name,
                                              style: theme.textTheme.bodyLarge,
                                            )
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              const SizedBox(height: 10),
                              Text(
                                "Selecione a forma de visualização das medidas de área.",
                                style: theme.textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                    onTap: () {
                                      PrefUtils().setAreaUnit('ha');
                                      metricUnit = MetricUnits.ha;
                                      setState(() {});
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: [
                                        Radio(
                                          value: MetricUnits.ha,
                                          groupValue: metricUnit,
                                          visualDensity: const VisualDensity(
                                            vertical: -4,
                                            horizontal: -4,
                                          ),
                                          onChanged: (value) {},
                                        ),
                                        Text(
                                          "Hectares (ha)",
                                          style: theme.textTheme.bodyLarge,
                                        )
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                    onTap: () {
                                      PrefUtils().setAreaUnit('alq');
                                      metricUnit = MetricUnits.alq;
                                      setState(() {});
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: [
                                        Radio(
                                          value: MetricUnits.alq,
                                          groupValue: metricUnit,
                                          visualDensity: const VisualDensity(
                                            vertical: -4,
                                            horizontal: -4,
                                          ),
                                          onChanged: (value) {},
                                        ),
                                        Text(
                                          "Alqueire (alq)",
                                          style: theme.textTheme.bodyLarge,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        drawer: DrawerComponent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return BaseAppBar();
  }

  _getHarvests() async {
    final response = await DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listHarvest}",
      context,
      showSnackBar: 0,
    );
    final data = jsonDecode(response.body);

    if (data['harvests'] != null) {
      harvests = Harvest.fromJsonList(data['harvests']);
      isLoadingHarvests = false;

      if (PrefUtils().getActualHarvest() == null) {
        for (var harvest in harvests) {
          if (harvest.isLastHarvert == 1) {
            // PrefUtils().setActualHarvest(harvest.id);
            harvestValue = harvest.id;
          }
        }
      } else {
        harvestValue = PrefUtils().getActualHarvest();
      }
      setState(() {});
    }
  }

  _handleSelectHarvest(int id, int isLastHarvert) {
    DefaultRequest.simplePostRequest(
      "${ApiRoutes.updateActualHarvest}",
      {
        "admin_id": admin.id,
        "harvest_id": isLastHarvert == 1 ? 'null' : id,
      },
      context,
    ).then((value) {
      if (value) {
        PrefUtils().setActualHarvest(isLastHarvert == 1 ? null : id);
        harvestValue = id;
        setState(() {});

        if (PrefUtils().getLastSync() != '') {
          _showSettingsModal();
        }
      }
    });
  }

  _showSettingsModal() {
    Dialogs.showGeralDialog(
      context,
      title: "Atenção",
      text:
          "Você alterou a safra atual, para que as informações funcionem localmente, é necessário sincronizar algumas rotas. Caso contrário, problemas podem ocorrer na navegação do mapa.\n\n*Serão sincronizadas somente as propriedades que já foram sincronizadas em algum momento.",
      widget: Column(
        children: [
          CustomFilledButton(
            text: "Sincronizar agora",
            isDisabled: isSync,
            onPressed: () async {
              await _syncRoutes();
            },
          ),
        ],
      ),
    );
  }

  _syncRoutes() async {
    setState(() {
      isSync = true;
    });
    final syncProperties = await PrefUtils().getSyncProperties();
    final syncPropertiesExplode =
        syncProperties != null ? syncProperties.split(',') : [];

    print(syncPropertiesExplode);

    await DefaultRequest.simpleGetRequest(
      "${ApiRoutes.getPartialSincronization}/${admin.id}${syncPropertiesExplode.length > 0 ? '?properties_ids=${syncPropertiesExplode.join(',')}' : ''}",
      context,
    ).then((value) {
      final data = jsonDecode(value.body);
      if (data['routes'] != null) {
        Map<String, dynamic> allData = {};

        for (var key in data['routes'].keys) {
          allData[key] = data['routes'][key];
        }

        PrefUtils().setBulkSQLOfflineData(allData);

        PrefUtils().setLastSync(
          Formatters.formatDateString(
            DateTime.now().toString().substring(0, 10),
          ),
        );
        setState(() {
          isSync = false;
        });
        return true;
      }
    });
    setState(() {
      isSync = false;
    });
    return false;
  }
}
