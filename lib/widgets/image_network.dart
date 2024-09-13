import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkComponent {
  static Widget getImageNetwork(
      String path, double? height, double width, BoxFit boxFit) {
    return CachedNetworkImage(
      imageUrl: path,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(),
        width: width,
        height: height,
        alignment: Alignment.center,
      ),
      errorWidget: (context, url, error) => Container(
        width: height,
        height: width,
        child: Image.asset(
          'assets/images/backup_image.png',
          fit: boxFit,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
