import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/access_consts.dart';
import 'package:fitoagricola/core/utils/firebase_token.dart';
import 'package:fitoagricola/core/utils/logout.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerComponent extends StatefulWidget {
  DrawerComponent({super.key});

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  Admin admin = PrefUtils().getAdmin();

  final List<Map<String, String>> constlinks = [
    {
      'title': 'Início',
      'icon': 'house',
      'route': AppRoutes.homeScreen,
    },
    {
      'title': 'Propriedades',
      'icon': 'circle',
      'route': AppRoutes.propertyList,
      'accessConst': AccessConsts.PROPERTIES,
    },
    // {
    //   'title': 'Lavouras',
    //   'icon': 'warehouse',
    //   'route': '',
    // },
    {
      'title': 'Relatórios',
      'icon': 'chart-pie-slice',
      'route': AppRoutes.reportsScreen,
      'accessConst': AccessConsts.REPORTS,
    },
    {
      'title': 'Bens',
      'icon': 'car',
      'route': AppRoutes.assetScreen,
      'accessConst': AccessConsts.ASSETS,
    },
    {
      'title': 'Conteúdos',
      'icon': 'clipboard-text',
      'accessConst': AccessConsts.CONTENTS,
    },
    {
      'title': 'Meus dados',
      'icon': 'user',
      'route': AppRoutes.userPage,
    },
    {
      'title': 'Sincronizar Offline',
      'icon': 'arrows-clockwise',
      'route': AppRoutes.offlinePage,
    },
    {
      'title': 'Configurações',
      'icon': 'gear',
      'route': AppRoutes.settingsPage,
    },
    {
      'title': 'Suporte',
      'icon': 'whatsapp-logo',
      'route': 'whatsapp',
    },
    {
      'title': 'Sair',
      'icon': 'sign-out',
      'route': AppRoutes.logout,
    },
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _checkAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      // backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      width: 330,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
            ),
            child: Row(
              children: [
                admin.profilePicture != ''
                    ? Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: ImageNetworkComponent.getImageNetwork(
                              "${dotenv.env['IMAGE_URL']}/admins/${admin.profilePicture}",
                              45,
                              45,
                              BoxFit.cover,
                            )
                            // Image.network(
                            //   "${dotenv.env['IMAGE_URL']}/admins/${admin.profilePicture}",
                            //   fit: BoxFit.cover,
                            // ),
                            ),
                      )
                    : Container(),
                SizedBox(width: 10),
                Text(
                  "Olá, ${admin.name}!",
                  style: CustomTextStyles.bodyMedium15,
                ),
              ],
            ),
          ),
          ...constlinks.map((link) {
            return
                // (link['title'] != "Conteúdos") ||
                //       (link['title'] != "Conteúdos" && admin.accessLevel == 1)
                //   ?
                Column(
              children: [
                if (link['title'] == 'Conteúdos')
                  Column(
                    children: [
                      ExpansionTile(
                        // collapsedBackgroundColor: Colors.red,
                        tilePadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        dense: true,
                        title: Text(
                          link['title']!,
                          style: theme.textTheme.bodyLarge,
                        ),
                        leading: PhosphorIcon(
                          IconsList.getIcon(link['icon']!),
                          color: theme.colorScheme.secondary,
                          size: 23,
                        ),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        children: [
                          if (admin.level
                              .toString()
                              .contains(link['accessConst']!))
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                NavigatorService.pushNamed(
                                  AppRoutes.publicationListPage,
                                  arguments: {
                                    'contentType': 1,
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 45,
                                  top: 10,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: PhosphorIcon(
                                        IconsList.getIcon(link['icon']!),
                                        color: theme.colorScheme.secondary,
                                        size: 23,
                                      ),
                                    ),
                                    Text(
                                      "Cursos",
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              NavigatorService.pushNamed(
                                AppRoutes.publicationListPage,
                                arguments: {
                                  'contentType': 2,
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 45,
                                top: 15,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: PhosphorIcon(
                                      IconsList.getIcon('seal-check'),
                                      color: theme.colorScheme.secondary,
                                      size: 23,
                                    ),
                                  ),
                                  Text(
                                    "M.A",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                else if (_validateLink(link))
                  Column(
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        dense: true,
                        title: Text(
                          link['title']!,
                          style: theme.textTheme.bodyLarge,
                        ),
                        leading: PhosphorIcon(
                          IconsList.getIcon(link['icon']!),
                          color: theme.colorScheme.secondary,
                          size: 23,
                        ),
                        minLeadingWidth: 25,
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        onTap: () {
                          if (link['route'] == AppRoutes.logout) {
                            // Chama a função de logout aqui e então fecha o drawer
                            LogoutFunctionOperation(context);
                          } else if (link['route'] == 'whatsapp') {
                            // Abre o whatsapp
                            launchWhatsApp();
                          } else {
                            // Navega para a rota especificada
                            Navigator.pop(context);
                            NavigatorService.pushNamed(link['route']!);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
              ],
            );
            // : SizedBox();
          }).toList(),
        ],
      ),
    );
  }

  _validateLink(link) {
    if (link['route'] == AppRoutes.offlinePage &&
        (admin.propertiesCount == null ||
            (admin.propertiesCount != null && admin.propertiesCount! > 0))) {
      return true;
    }

    if (link['route'] != AppRoutes.offlinePage && link['accessConst'] == null ||
        (link['accessConst'] != null &&
            admin.level.toString().contains(link['accessConst']!))) {
      return true;
    }

    return false;
  }

  launchWhatsApp() {
    launchUrl(Uri.parse(
        'https://wa.me/+555497009322?text=Olá, necessito de auxílio com o Fito App.'));
  }

  _checkAdmin() async {
    // if (admin.accessMA == null) {
    if (await NetworkOperations.checkConnection()) {
      DefaultRequest.simpleGetRequest(
        '${ApiRoutes.readAdmin}/${admin.id}',
        context,
        showSnackBar: 0,
      ).then(
        (value) {
          final data = jsonDecode(value.body);

          if (data['admin'] != null) {
            PrefUtils().setAdmin(jsonEncode(data['admin']));
            final newAdmin = PrefUtils().getAdmin();
            if (newAdmin.actualHarvestId != PrefUtils().getActualHarvest()) {
              PrefUtils().setActualHarvest(newAdmin.actualHarvestId);
            }

            final adminToken = PrefUtils().getFirebaseToken();
            bool hasToken = false;

            if (newAdmin.tokens != null) {
              for (var token in newAdmin.tokens!) {
                if (token.token == adminToken) {
                  hasToken = true;
                  break;
                }
              }
            }

            if (!hasToken) {
              FirebaseToken.getDeviceFirebaseToken();
            }

            if (mounted) {
              setState(() {
                admin = newAdmin;
              });
            }
          }
        },
      );
    }
    // }
  }
}
