import 'package:fitoagricola/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: theme.colorScheme.primary,
        title: Text(''),
        leading: Container(
          height: 20,
          child: IconButton(
            icon: PhosphorIcon(PhosphorIcons.arrowLeft()),
            color: appTheme.whiteA70001,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        backgroundDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
