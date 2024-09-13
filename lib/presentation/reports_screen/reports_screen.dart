import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/permissions.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_body.dart';
import 'package:fitoagricola/presentation/reports_screen/components/reports_header.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_filex/open_filex.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int selectedValue = 1;
  int currentPage = 1;
  int totalPages = 1;
  Admin admin = PrefUtils().getAdmin();

  bool isLoading = true;

  List<dynamic> itemsReponse = [];
  dynamic productivityGraph = [];
  ReportsFilterParams? filtersParam;

  final tabs = [
    {
      'id': 1,
      'code': 'geral',
      'title': 'Geral',
    },
    {
      'id': 2,
      'code': 'pests',
      'title': 'Pragas',
    },
    {
      'id': 3,
      'code': 'weeds',
      'title': 'Daninhas',
    },
    {
      'id': 4,
      'code': 'diseases',
      'title': 'Doenças',
    },
    {
      'id': 5,
      'code': 'inputs',
      'title': 'Insumos',
    },
    {
      'id': 6,
      'code': 'data-seeds',
      'title': 'Sementes',
    },
    {
      'id': 7,
      'code': 'application',
      'title': 'Fungicidas',
    },
    {
      'id': 8,
      'code': 'rain-gauges',
      'title': 'Pluviômetro',
    },
    {
      'id': 9,
      'code': 'monitoring',
      'title': 'Monitoramento',
    },
    {
      'id': 10,
      'code': 'productivity',
      'title': 'Produtividade',
    },
    {
      'id': 11,
      'code': 'cultures',
      'title': 'Cultura',
    },
  ];

  GlobalKey widgetKey = GlobalKey();

  InAppWebViewController? controllerToScreenshot;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getItens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: BaseAppBar(),
        drawer: DrawerComponent(),
        body: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 30,
                  right: 20,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    ReportsHeader(
                      activeFilter: filtersParam,
                      exportFile: capturePng,
                      currentTabCode: tabs
                          .firstWhere((element) =>
                              element['id'] == selectedValue)['code']
                          .toString(),
                      onFilterChanged: (newFilters) {
                        int? actualUserHarvest = PrefUtils().getActualHarvest();

                        if (actualUserHarvest != null) {
                          if (newFilters != null &&
                              newFilters.harvestsId == null) {
                            newFilters.harvestsId =
                                actualUserHarvest.toString();
                          } else if (newFilters == null) {
                            newFilters = ReportsFilterParams(
                                harvestsId: actualUserHarvest.toString());
                          }
                        }
                        setState(() {
                          filtersParam = newFilters;
                        });
                        Navigator.pop(context);
                        getItens();
                      },
                    ),
                    SizedBox(height: 20.v),
                    Text(
                      'Relatórios disponíveis. Algumas tabelas ultrapassam o limite da tela, sendo necessário arrastar a barra para o lado',
                      style: theme.textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
              ReportsBody(
                isLoading: isLoading,
                itemsResponse: itemsReponse,
                selectedValue: selectedValue,
                filtersParam: filtersParam != null
                    ? filtersParam!.toRequestQueryParams()
                    : null,
                tabs: tabs,
                currentPage: currentPage,
                updatePageFunction: updateCurrentPage,
                totalPages: totalPages,
                globalKey: widgetKey,
                productivityGraph: productivityGraph,
                functionController: _setController,
                onTabChanged: (newValue) {
                  if (newValue == null) return;
                  setState(() {
                    currentPage = 1;
                    selectedValue = newValue;
                    filtersParam = null;
                  });
                  if (newValue != 11) getItens();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setController(InAppWebViewController controller) {
    setState(() {
      controllerToScreenshot = controller;
    });
  }

  void updateCurrentPage(int page) {
    setState(() {
      currentPage = page;
    });

    getItens();
  }

  void getItens() async {
    setState(() {
      isLoading = true;
    });

    final code = tabs.firstWhere(
      (element) => element['id'] == selectedValue,
    )['code'];

    var apiUrl = '/api/reports/list/${admin.id}/$code?';
    if (filtersParam != null) {
      apiUrl += filtersParam!.toRequestQueryParams() + '&';
    }

    if (code == 'productivity') {
      var apiUrlGraph = '/api/reports/list/${admin.id}/productivity-graph?';
      if (filtersParam != null) {
        apiUrlGraph += filtersParam!.toRequestQueryParams() + '&';
      }

      await DefaultRequest.simpleGetRequest(
        apiUrlGraph,
        context,
        showSnackBar: 0,
      ).then((value) {
        Map<String, dynamic> data = jsonDecode(value.body);

        if (data['reports'] != null) {
          setState(() {
            productivityGraph = data['reports'];
          });
        } else {
          SnackbarComponent.showSnackBar(
              context, 'error', 'Ocorreu um erro ao carregar os dados.');
        }
      }).catchError((error) {
        SnackbarComponent.showSnackBar(
            context, 'error', 'Ocorreu um erro ao carregar os dados.');
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }

    apiUrl += 'page=${currentPage}';
    DefaultRequest.simpleGetRequest(
      apiUrl,
      context,
      showSnackBar: 0,
    ).then((value) {
      Map<String, dynamic> data = jsonDecode(value.body);

      if (data['reports'] != null) {
        setState(() {
          itemsReponse = data['reports'];
          totalPages = data['total'];
        });
      }
      // else {
      //   SnackbarComponent.showSnackBar(
      //       context, 'error', 'Ocorreu um erro ao carregar os dados.');
      // }
    }).catchError((error) {
      SnackbarComponent.showSnackBar(
          context, 'error', 'Ocorreu um erro ao carregar os dados.');
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> capturePng() async {
    SnackbarComponent.showSnackBar(
      context,
      'loading',
      'Fazendo exportação da imagem, aguarde um momento.',
      duration: Duration(seconds: 50),
    );
    Uint8List? bytes;

    if (controllerToScreenshot != null) {
      bytes = await controllerToScreenshot!.takeScreenshot();
    }
    // if (Platform.isIOS) {
    // } else {
    //   RenderRepaintBoundary boundary =
    //       widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    //   ui.Image image = await boundary.toImage();
    //   ByteData? byteData =
    //       await image.toByteData(format: ui.ImageByteFormat.png);
    //   // Uint8List pngBytes = byteData!.buffer.asUint8List();

    //   // Salvar a imagem no diretório do aplicativo
    //   String? dir = await PermissionsComponent.getGalleryPath();

    //   if (dir == null) {
    //     Navigator.pop(context);
    //     SnackbarComponent.showSnackBar(
    //       context,
    //       'error',
    //       'Não foi possível salvar a imagem',
    //     );
    //     return;
    //   }

    //   bytes = byteData!.buffer.asUint8List();
    // }
    // File fileDownload = File('$dir/relatorio-cultura.png');
    // await fileDownload.writeAsBytes(pngBytes);
    // print("Imagem salva em $dir/relatorio-cultura.png");

    if (bytes == null) {
      return;
    }

    final result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: 'relatorio-cultura',
      isReturnImagePathOfIOS: Platform.isIOS,
    );

    print(result);

    Navigator.pop(context);
    if (result['isSuccess'] == false) {
      SnackbarComponent.showSnackBar(
          context, 'error', 'Erro ao salvar a imagem na galeria');
      return;
    }

    if (Platform.isIOS) {
      // abrindo imagem
      SnackbarComponent.showSnackBar(context, 'success',
          'Imagem salva na sua galeria com sucesso! Clique para abrir a galeria.',
          duration: Duration(seconds: 20), onClick: () async {
        const url = 'photos-redirect://';
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch $url';
        }
      });
    } else {
      bool hasPermission = await PermissionsComponent.photoManagerAccess();

      if (!hasPermission) {
        return;
      }

      print(hasPermission);

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.image,
      );

      bool findImage = false;
      AssetEntity? assetEntity;

      if (albums.isNotEmpty) {
        final List<AssetEntity> media = await albums[0]
            .getAssetListPaged(page: 0, size: 100); // Get first 100 images

        for (var i = 0; i < media.length; i++) {
          final file = await media[i].file;
          if (media[i].title!.contains('relatorio-cultura')) {
            findImage = true;
            assetEntity = media[i];
            break;
          }
        }
      }

      print(assetEntity);

      if (!findImage || assetEntity == null) {
        SnackbarComponent.showSnackBar(
            context, 'error', 'Erro ao salvar a imagem na galeria');
        return;
      }

      final file = await assetEntity.file;

      print(file);
      // abrindo imagem
      SnackbarComponent.showSnackBar(context, 'success',
          'Imagem salva na sua galeria com sucesso! Clique para abrir a imagem.',
          duration: Duration(seconds: 20), onClick: () async {
        await OpenFilex.open(file!.path);
      });
    }
  }
}
