import 'dart:async';
import 'dart:io';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/error_log.dart';
import 'package:fitoagricola/core/utils/filter_crop.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/data/models/property_monitoring/property_monitoring.dart';
import 'package:fitoagricola/widgets/app_bar/crop_list.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/floating_button/components/register_activity_modal.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MapCropNative extends StatefulWidget {
  final Crop? crop;
  final CropJoin? cropJoin;
  final List<dynamic>? crops;
  final bool fullScreen;
  final PropertyMonitoring? propertyMonitoring;
  final bool? showList;
  final bool? tapAction;
  final Function(LatLng)? monitoringFunction;
  final int? propertyId;
  final int? harvestId;
  final bool? showDAP;
  final bool showRegisterMenu;

  MapCropNative({
    this.crop,
    this.crops,
    this.fullScreen = false,
    this.propertyMonitoring,
    this.showList = true,
    this.tapAction = true,
    this.monitoringFunction,
    this.harvestId,
    this.propertyId,
    this.showDAP,
    this.cropJoin,
    this.showRegisterMenu = true,
  });

  @override
  State<MapCropNative> createState() => _MapCropNativeState();
}

class _MapCropNativeState extends State<MapCropNative> {
  bool isLoading = true;
  MapController _mapController = MapController();
  List<Polygon> polygons = [];
  List<Marker> markers = [];
  final LayerHitNotifier hitNotifier = ValueNotifier(null);
  String currentTab = 'map';
  // LatLng? currentLocation;
  // Timer? updateLocation;
  // final tileProvider = FMTCStore('mapCache').getTileProvider();
  List<Map<String, dynamic>> colorsMap = [
    {
      'color': Color(0xFFA468AD),
      'label': "SEM PLANTIO",
    }
  ];

  Orientation orientation = Orientation.portrait;

  bool isOpen = false;

  final List options = [
    {
      "icon": 'plant',
      "text": "Plantio",
      "onTap": "seed",
    },
    {
      "icon": 'waves',
      "text": "Fertilizantes",
      "onTap": "fertilizer",
    },
    {
      "icon": 'flask',
      "text": "Aplicação",
      "onTap": "defensive",
    },
    {
      "icon": 'tractor',
      "text": "Colheita",
      "onTap": "harvest",
    },
    {
      "icon": 'cloud-rain',
      "text": "Chuva",
      "onTap": "rain",
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orientation = MediaQuery.of(context).orientation;
  }

  initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await FMTCStore('mapStore').manage.create();

      // _checkLocation();

      if (widget.crops != null && widget.crops!.isNotEmpty) {
        await _setPolygons();
      }
      // else {
      //   await _mapController.move(LatLng(-28.209063, -51.525634), 13);
      // }

      if (widget.propertyMonitoring != null) {
        await _setMarkersMonitoring();
      }

      orientation = MediaQuery.of(context).orientation;

      setState(() {});
    });
  }

  @override
  void dispose() {
    // updateLocation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMap(),
        // isLoading
        //     ? DefaultCircularIndicator.getIndicator()
        //     : Column(
        //         children: [
        if (widget.showList == true) _buildCropList(),
        if (widget.showList == true) _buildTopRightButtons(),
        if (widget.crop != null) _buildCropAreaBox(),
        _buildColorLegend(),
        _buildRegisterActivity(),
      ],
      //         ),
      // ],
    );
  }

  _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          onMapReady: () {
            setState(() {
              isLoading = false;
            });
          },
          initialCenter: LatLng(-28.209063, -51.525634),
          interactionOptions: InteractionOptions(),
          // initialCameraFit: widget.crops != null && widget.crops!.length > 0
          //     ? CameraFit.bounds(
          //         bounds: _calculateBounds(
          //             widget.crop != null ? [widget.crop] : widget.crops),
          //         padding: EdgeInsets.zero,
          //       )
          //     : null,
          onTap: widget.monitoringFunction == null
              ? null
              : (TapPosition position, LatLng point) {
                  _insertMarker(point);
                }),
      children: [
        TileLayer(
          urlTemplate: 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
          subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
          userAgentPackageName: 'com.fitoagricola.app',
          tileProvider: FMTCStore('mapStore').getTileProvider(),
        ),
        CurrentLocationLayer(
          alignPositionOnUpdate: (widget.crops == null || widget.crops!.isEmpty)
              ? AlignOnUpdate.once
              : AlignOnUpdate.never,
          alignDirectionOnUpdate: AlignOnUpdate.never,
          style: LocationMarkerStyle(
            markerSize: const Size(30, 30),
            markerDirection: MarkerDirection.heading,
          ),
        ),
        MouseRegion(
          hitTestBehavior: HitTestBehavior.deferToChild,
          cursor: SystemMouseCursors
              .click, // Use a special cursor to indicate interactivity
          child: GestureDetector(
            onTap: () {
              final LayerHitResult? hitResult = hitNotifier.value;
              if (hitResult == null) return;

              if (widget.monitoringFunction != null) {
                _insertMarker(hitResult.coordinate);
              }

              if (widget.tapAction == false) {
                return;
              }

              for (final hitValue in hitResult.hitValues) {
                if (hitValue is CropJoin &&
                    (widget.crop == null ||
                        (widget.crop != null &&
                            hitValue.crop!.id != widget.crop!.id))) {
                  FilterCrop.filterCrop(context, hitValue.id);
                } else if (hitValue is Crop &&
                    (widget.crop == null ||
                        (widget.crop != null &&
                            hitValue.id != widget.crop!.id))) {
                  FilterCrop.filterCropByCropId(context, hitValue.id);
                }
              }
            },
            // And/or any other gesture callback
            child: polygons.isNotEmpty
                ? PolygonLayer(
                    hitNotifier: hitNotifier,
                    polygons: polygons,
                    drawLabelsLast: true,
                    simplificationTolerance: Platform.isIOS ? 0 : 1.5,
                    useAltRendering: true,
                  )
                : null,
          ),
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }

  _buildCropList() {
    return IgnorePointer(
      ignoring: currentTab == 'map',
      child: AnimatedOpacity(
        opacity: currentTab != 'map' ? 1 : 0,
        duration: const Duration(milliseconds: 170),
        child: CropList(
          widget.crops,
          height: 1,
        ),
      ),
    );
  }

  _buildTopRightButtons() {
    return Positioned(
      top: orientation == Orientation.portrait ? 30 : 10,
      right: orientation == Orientation.portrait ? 20 : 10,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    currentTab = 'map';
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: appTheme.gray300,
                      width: 1,
                    ),
                  ),
                ),
                width: 40,
                height: 40,
                child: PhosphorIcon(
                  IconsList.getIcon('map-trifold'),
                  size: 20,
                  color: currentTab == 'map'
                      ? theme.colorScheme.secondary
                      : appTheme.gray400,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    currentTab = 'list';
                  });
                }
              },
              child: Container(
                width: 40,
                height: 40,
                child: PhosphorIcon(
                  IconsList.getIcon('list-dashes'),
                  size: 20,
                  color: currentTab != 'map'
                      ? theme.colorScheme.secondary
                      : appTheme.gray400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCropAreaBox() {
    return Positioned(
      top: orientation == Orientation.portrait ? 30 : 10,
      left: 10,
      child: Visibility(
        visible: currentTab == 'map',
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Text(
              "${widget.crop!.area != null ? Formatters.formatToBrl(double.parse(widget.crop!.area!)) : 0} ${PrefUtils().getAreaUnit()}"),
        ),
      ),
    );
  }

  _buildColorLegend() {
    return Visibility(
      visible: currentTab == 'map',
      child: Positioned(
        bottom: 10,
        left: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var colorItem in colorsMap)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        Container(
                          width: orientation == Orientation.portrait ? 15 : 10,
                          height: orientation == Orientation.portrait ? 15 : 10,
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: colorItem['color'],
                          ),
                        ),
                        Text(
                          colorItem['label'] ?? "Sem legenda",
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize:
                                orientation == Orientation.portrait ? 11 : 8,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildRegisterActivity() {
    return Visibility(
      visible: currentTab == 'map' && widget.showRegisterMenu,
      child: Positioned(
        bottom: 15,
        right: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: isOpen,
              child: AnimatedOpacity(
                opacity: isOpen ? 1 : 0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                child: orientation == Orientation.portrait
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (var option in options) _buildOption(option)
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: Row(
                          children: [
                            for (var option in options) _buildOption(option)
                          ],
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.all(
                    orientation == Orientation.portrait ? 20.v : 15.v),
                child: PhosphorIcon(
                  IconsList.getIcon('plus'),
                  color: Colors.white,
                  size: 20.v,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildOption(option) {
    return GestureDetector(
      onTap: () {
        Dialogs.showGeralDialog(
          context,
          title: "Registrar atividade - ${option['text']}",
          text: "Preencha os campos abaixo para registrar a atividade",
          widget: RegisterActivityModal(
            propertyId: widget.propertyId,
            harvestId: widget.harvestId,
            code: option["onTap"],
            contextScreen: context,
          ),
        );
      },
      child: Container(
        margin: orientation == Orientation.portrait
            ? EdgeInsets.only(bottom: 7)
            : EdgeInsets.only(right: 7),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.v),
              child: PhosphorIcon(
                option["icon"] == 'tractor'
                    ? Icons.agriculture_outlined
                    : IconsList.getIcon(option["icon"]),
                color: Colors.white,
                size: orientation == Orientation.portrait ? 16 : 14,
              ),
            ),
            Text(
              option["text"],
              style: CustomTextStyles.bodyMediumWhite,
            ),
          ],
        ),
      ),
    );
  }

  _setPolygons() async {
    final cultures = PrefUtils().getSeed();

    for (var crop in widget.crops!) {
      try {
        List<LatLng> points = _getPoints(crop is Crop ? crop : crop.crop!);

        final cropItem = crop is Crop ? crop : crop.crop!;

        final color = crop.color != null && crop.color != 'null'
            ? int.parse("FF" + crop.color!.replaceAll("#", ""), radix: 16)
            : 0xFFA468AD;

        // adicionando cor se já não estiver na lista
        if (!colorsMap.any((element) => element['color'] == Color(color)) &&
            cultures != null) {
          // pegando cultura com a mesma cor
          final culture = cultures.firstWhere(
              (element) => element['color'] == crop.color,
              orElse: () => null);

          if (culture != null) {
            colorsMap.add({
              'color': Color(color),
              'label': culture['name'],
            });
          }
        }

        if (points.isNotEmpty) {
          bool okToGo = false;

          if (widget.cropJoin == null) {
            okToGo = true;
          } else {
            if ((widget.cropJoin!.isSubharvest == 0 ||
                widget.cropJoin!.cropId != cropItem.id ||
                (widget.cropJoin!.cropId == cropItem.id &&
                    widget.cropJoin!.id == crop.id))) {
              okToGo = true;
            }
          }
          if (okToGo) {
            String name =
                "${cropItem.name} ${crop is CropJoin ? (crop.subharvestName ?? '') : " "}";

            if (widget.showDAP == true &&
                crop is CropJoin &&
                crop.plantTable != null) {
              name +=
                  "\n${crop.plantTable!.split('-')[1].trim().replaceAll(' dias', '')}";
            }

            polygons.add(
              Polygon(
                points: points,
                color: Color(color).withOpacity(0.2),
                borderColor: Color(color),
                borderStrokeWidth: 1,
                strokeCap: StrokeCap.square,
                strokeJoin: StrokeJoin.bevel,
                label: name,
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                hitValue: crop,
              ),
            );
          }
        }
      } catch (e, stackTrace) {
        ErrorLog.logError(e.toString(), stackTrace);
        Logger().e(e);
      }
    }

    // Logger().e(
    //     _calculateBounds(widget.crop != null ? [widget.crop] : widget.crops));

    List<dynamic>? cropToUse = [];

    if (widget.crop != null) {
      if (widget.crop!.drawArea != '') {
        cropToUse = [widget.crop];
      } else {
        // find same crop in widget.crops
        for (var crop in widget.crops!) {
          if (crop is Crop && crop.id == widget.crop!.id) {
            cropToUse.add(crop);
          }

          if (crop is CropJoin && crop.crop!.id == widget.crop!.id) {
            cropToUse.add(crop);
          }
        }
      }
    } else {
      cropToUse = widget.crops;
    }

    _mapController.fitCamera(CameraFit.bounds(
      bounds: _calculateBounds(cropToUse),
      padding: EdgeInsets.zero,
    ));
  }

  LatLngBounds _calculateBounds(dynamic crops) {
    double northMost = -90.0,
        southMost = 90.0,
        westMost = 180.0,
        eastMost = -180.0;

    for (var crop in crops) {
      List<LatLng> points = _getPoints(crop is Crop ? crop : crop.crop!);
      // Logger().e(points);
      points.forEach((point) {
        if (point.latitude > northMost) northMost = point.latitude;
        if (point.latitude < southMost) southMost = point.latitude;
        if (point.longitude > eastMost) eastMost = point.longitude;
        if (point.longitude < westMost) westMost = point.longitude;
      });
    }

    LatLng northEast = LatLng(northMost, eastMost);
    LatLng southWest = LatLng(southMost, westMost);

    return LatLngBounds(northEast, southWest);
  }

  List<LatLng> _getPoints(Crop crop) {
    List<LatLng> points = [];
    // Logger().i(crop.drawArea);
    final drawArea = crop.drawArea!.split('|||');
    for (var point in drawArea) {
      final pointSplit = point.split(',');

      if (pointSplit.length == 2 &&
          double.tryParse(pointSplit[0]) != null &&
          double.tryParse(pointSplit[1]) != null) {
        points.add(
            LatLng(double.parse(pointSplit[0]), double.parse(pointSplit[1])));
      }
    }

    return points;
  }

  _setMarkersMonitoring() async {
    final propertyMonitoring = widget.propertyMonitoring!;

    if (propertyMonitoring.diseases != null) {
      int index = 1;
      for (var disease in propertyMonitoring.diseases!) {
        _markerMonitoringAction(index, disease, disease.disease!.name, "do");
        index++;
      }
    }

    if (propertyMonitoring.pests != null) {
      int index = 1;
      for (var pest in propertyMonitoring.pests!) {
        _markerMonitoringAction(index, pest, pest.pest!.name, "p");
        index++;
      }
    }

    if (propertyMonitoring.weeds != null) {
      int index = 1;
      for (var weed in propertyMonitoring.weeds!) {
        _markerMonitoringAction(index, weed, weed.weed!.name, "da");
        index++;
      }
    }

    if (propertyMonitoring.stages != null) {
      int index = 1;
      for (var stage in propertyMonitoring.stages!) {
        _markerMonitoringAction(
            index, stage, Formatters.getStageText(stage), "e");
        index++;
      }
    }
  }

  String _getRiskColor(int risk) {
    if (risk == 1) {
      return "green";
    } else if (risk == 2) {
      return "yellow";
    } else if (risk == 3) {
      return "red";
    }

    return "green";
  }

  _markerMonitoringAction(
      int index, dynamic object, String name, String imagePrefix) async {
    if (object.coordinates != null) {
      final imagePath =
          "assets/images/map_markers/${imagePrefix}-${index}-${_getRiskColor(object.risk!)}.png";

      markers.add(
        Marker(
          point: LatLng(object.coordinates!['coordinates']![1],
              object.coordinates!['coordinates']![0]),
          height: 31,
          width: 38,
          child: Tooltip(
            message: name,
            child: Image.asset(imagePath),
            triggerMode: TooltipTriggerMode.tap,
            waitDuration: Duration(milliseconds: 0),
          ),
        ),
      );
    }
  }

  _insertMarker(LatLng point) {
    // removendo outro marker
    markers.removeWhere((element) =>
        element.key != null &&
        element.key!.toString() != "[<'current-location'>]");

    markers.add(
      Marker(
        key: Key('marker-${markers.length}'),
        point: point,
        width: 31,
        height: 38,
        child: Image.asset('assets/images/default-map-marker.png'),
      ),
    );

    setState(() {});

    widget.monitoringFunction!(point);
  }
}
