// import 'dart:ui' as ui;

// import 'package:fitoagricola/core/app_export.dart';
// import 'package:fitoagricola/core/utils/filter_crop.dart';
// import 'package:fitoagricola/core/utils/formatters.dart';
// import 'package:fitoagricola/data/models/crop/crop.dart';
// import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
// import 'package:fitoagricola/data/models/property_monitoring/property_monitoring.dart';
// import 'package:fitoagricola/widgets/app_bar/crop_list.dart';
// import 'package:fitoagricola/widgets/default_circular_progress.dart';
// import 'package:fitoagricola/widgets/icons/icons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:label_marker/label_marker.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

// class MapCrop extends StatefulWidget {
//   final Crop? crop;
//   final List<dynamic>? crops;
//   final bool fullScreen;
//   final PropertyMonitoring? propertyMonitoring;
//   final bool? showList;
//   final bool? tapAction;
//   final Function(LatLng)? monitoringFunction;

//   MapCrop({
//     this.crop,
//     this.crops,
//     this.fullScreen = false,
//     this.propertyMonitoring,
//     this.showList = true,
//     this.tapAction = true,
//     this.monitoringFunction,
//   });

//   @override
//   _MapCropState createState() => _MapCropState();
// }

// class _MapCropState extends State<MapCrop> {
//   GoogleMapController? mapController;
//   Set<Marker> markers = Set();
//   Set<Polygon> polygons = Set();
//   LatLng mapCenter = LatLng(-27.827097, -50.33408);
//   double _zoomLevel = 10; // Valor inicial
//   Future _mapFuture = Future.delayed(Duration(milliseconds: 250), () => true);

//   String currentTab = 'map';

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _mapFuture,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return DefaultCircularIndicator.getIndicator();
//         }
//         return Stack(
//           children: [
//             GoogleMap(
//               onCameraMove: (CameraPosition position) {
//                 _updateZoomLevel(); // Atualiza o zoom cada vez que a câmera move
//               },
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: mapCenter,
//               ),
//               onTap: widget.monitoringFunction == null
//                   ? null
//                   : (LatLng latLng) {
//                       // inserir marcador
//                       markers.add(
//                         Marker(
//                           markerId: MarkerId('monitoring'),
//                           position: latLng,
//                           icon: BitmapDescriptor.defaultMarkerWithHue(
//                               BitmapDescriptor.hueRed),
//                         ),
//                       );

//                       if (mounted) {
//                         setState(() {});
//                       }

//                       widget.monitoringFunction!(latLng);
//                     },
//               markers: _zoomLevel <= 13 ? {} : markers,
//               polygons: polygons,
//               myLocationButtonEnabled: false,
//               mapType: MapType.satellite,
//               // ...other GoogleMap properties...
//             ),
//             if (widget.showList == true)
//               IgnorePointer(
//                 ignoring: currentTab == 'map',
//                 child: AnimatedOpacity(
//                   opacity: currentTab != 'map' ? 1 : 0,
//                   duration: const Duration(milliseconds: 170),
//                   child: CropList(
//                     widget.crops,
//                     height: 1,
//                   ),
//                 ),
//               ),
//             if (widget.showList == true)
//               Positioned(
//                 top: 30,
//                 right: 20,
//                 child: Container(
//                   width: 80,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 5,
//                         offset: Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   clipBehavior: Clip.hardEdge,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if (mounted) {
//                             setState(() {
//                               currentTab = 'map';
//                             });
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border(
//                               right: BorderSide(
//                                 color: appTheme.gray300,
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                           width: 40,
//                           height: 40,
//                           child: PhosphorIcon(
//                             IconsList.getIcon('map-trifold'),
//                             size: 20,
//                             color: currentTab == 'map'
//                                 ? theme.colorScheme.secondary
//                                 : appTheme.gray400,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (mounted) {
//                             setState(() {
//                               currentTab = 'list';
//                             });
//                           }
//                         },
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           child: PhosphorIcon(
//                             IconsList.getIcon('list-dashes'),
//                             size: 20,
//                             color: currentTab != 'map'
//                                 ? theme.colorScheme.secondary
//                                 : appTheme.gray400,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   void _updateZoomLevel() async {
//     if (mounted) {
//       final zoomLevel = await mapController?.getZoomLevel();
//       if (mounted) {
//         setState(() {
//           _zoomLevel = zoomLevel ?? 10; // Define um valor padrão caso seja null
//         });
//       }
//     }
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     _updateZoomLevel();

//     if (widget.crops != null) {
//       _setPolygons();
//     }

//     if (widget.propertyMonitoring != null) {
//       _setMarkersMonitoring();
//     }
//   }

//   String _getRiskColor(int risk) {
//     if (risk == 1) {
//       return "green";
//     } else if (risk == 2) {
//       return "yellow";
//     } else if (risk == 3) {
//       return "red";
//     }

//     return "green";
//   }

//   _setMarkersMonitoring() async {
//     final propertyMonitoring = widget.propertyMonitoring!;

//     if (propertyMonitoring.diseases != null) {
//       int index = 1;
//       for (var disease in propertyMonitoring.diseases!) {
//         _markerMonitoringAction(index, disease, disease.disease!.name, "do");
//         index++;
//       }
//     }

//     if (propertyMonitoring.pests != null) {
//       int index = 1;
//       for (var pest in propertyMonitoring.pests!) {
//         _markerMonitoringAction(index, pest, pest.pest!.name, "p");
//         index++;
//       }
//     }

//     if (propertyMonitoring.weeds != null) {
//       int index = 1;
//       for (var weed in propertyMonitoring.weeds!) {
//         _markerMonitoringAction(index, weed, weed.weed!.name, "da");
//         index++;
//       }
//     }

//     if (propertyMonitoring.stages != null) {
//       int index = 1;
//       for (var stage in propertyMonitoring.stages!) {
//         _markerMonitoringAction(
//             index, stage, Formatters.getStageText(stage), "e");
//         index++;
//       }
//     }
//   }

//   Future<BitmapDescriptor> createCustomMarkerBitmap(String imagePath) async {
//     ByteData data = await rootBundle.load(imagePath);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: 70);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     final bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();

//     return BitmapDescriptor.fromBytes(bytes);
//   }

//   _markerMonitoringAction(
//       int index, dynamic object, String name, String imagePrefix) async {
//     if (object.coordinates != null) {
//       BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

//       // ImageConfiguration configuration = ImageConfiguration(size: Size(61, 68));

//       // await BitmapDescriptor.fromAssetImage(configuration,
//       //         "assets/images/map_markers/${imagePrefix}-${index}-${_getRiskColor(object.risk!)}.png")
//       //     .then(
//       //   (icon) {
//       //     markerIcon = icon;
//       //   },
//       // );
//       markerIcon = await createCustomMarkerBitmap(
//           "assets/images/map_markers/${imagePrefix}-${index}-${_getRiskColor(object.risk!)}.png");

//       markers.add(
//         Marker(
//           markerId: MarkerId('${imagePrefix}-${object.id}'),
//           position: LatLng(object.coordinates!['coordinates']![1],
//               object.coordinates!['coordinates']![0]),
//           infoWindow: InfoWindow(
//             title: name,
//           ),
//           icon: markerIcon,
//         ),
//       );
//     }
//   }

//   _setPolygons() {
//     for (var crop in widget.crops!) {
//       try {
//         List<LatLng> points = _getPoints(crop is Crop ? crop : crop.crop!);
//         LatLng centerPoint = _getPolygonCenter(points);

//         final cropItem = crop is Crop ? crop : crop.crop!;

//         final color = crop.color != null
//             ? int.parse("FF" + crop.color!.replaceAll("#", ""), radix: 16)
//             : 0xFF2E9AAA;

//         polygons.add(
//           Polygon(
//               polygonId: PolygonId(crop.id.toString()),
//               points: points,
//               strokeWidth: 4,
//               consumeTapEvents: widget.tapAction == true ? true : false,
//               strokeColor: Color(color),
//               fillColor: Color(color).withOpacity(0.5),
//               onTap: widget.tapAction == true
//                   ? () {
//                       if (crop is CropJoin) {
//                         FilterCrop.filterCrop(context, crop.id);
//                       } else {
//                         FilterCrop.filterCropByCropId(context, crop.id);
//                       }
//                     }
//                   : null),
//         );

//         markers
//             .addLabelMarker(
//           LabelMarker(
//             label: cropItem.name,
//             markerId: MarkerId("${crop.id}-${cropItem.name}"),
//             position: centerPoint,
//             backgroundColor: Colors.transparent,
//             textStyle: TextStyle(
//               color: Colors.white,
//               fontSize: 45,
//               fontWeight: FontWeight.normal,
//               fontFamily: 'Inter',
//             ),
//             anchor: Offset(0, 0),
//           ),
//         )
//             .then(
//           (value) {
//             if (mounted) {
//               setState(() {});
//             }
//           },
//         );
//       } catch (e) {
//         print(e);
//       }
//     }

//     LatLngBounds bounds =
//         _calculateBounds(widget.crop != null ? [widget.crop] : widget.crops!);

//     mapController?.animateCamera(
//       CameraUpdate.newLatLngBounds(bounds, 10),
//     );

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   LatLngBounds _calculateBounds(dynamic crops) {
//     double northMost = -90.0,
//         southMost = 90.0,
//         westMost = 180.0,
//         eastMost = -180.0;

//     for (var crop in crops) {
//       List<LatLng> points = _getPoints(crop is Crop ? crop : crop.crop!);
//       points.forEach((point) {
//         if (point.latitude > northMost) northMost = point.latitude;
//         if (point.latitude < southMost) southMost = point.latitude;
//         if (point.longitude > eastMost) eastMost = point.longitude;
//         if (point.longitude < westMost) westMost = point.longitude;
//       });
//     }

//     LatLng northEast = LatLng(northMost, eastMost);
//     LatLng southWest = LatLng(southMost, westMost);

//     return LatLngBounds(northeast: northEast, southwest: southWest);
//   }

//   List<LatLng> _getPoints(Crop crop) {
//     List<LatLng> points = [];

//     final drawArea = crop.drawArea!.split('|||');
//     for (var point in drawArea) {
//       final pointSplit = point.split(',');

//       if (pointSplit.length == 2 &&
//           double.tryParse(pointSplit[0]) != null &&
//           double.tryParse(pointSplit[1]) != null) {
//         points.add(
//             LatLng(double.parse(pointSplit[0]), double.parse(pointSplit[1])));
//       }
//     }

//     return points;
//   }

//   LatLng _getPolygonCenter(List<LatLng> points) {
//     double lat = 0;
//     double lng = 0;

//     for (var point in points) {
//       lat += point.latitude;
//       lng += point.longitude;
//     }

//     lat /= points.length;
//     lng /= points.length;
//     return LatLng(lat, lng);
//   }
// }
