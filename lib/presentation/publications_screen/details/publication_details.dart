import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/content/content.dart';
import 'package:fitoagricola/data/models/content_block/content_block.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/fullscreen_image.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PublicationDetails extends StatefulWidget {
  final String publicationUrl;

  PublicationDetails({required this.publicationUrl, super.key});

  @override
  State<PublicationDetails> createState() => _PublicationDetailsState();
}

class _PublicationDetailsState extends State<PublicationDetails> {
  Content? publication;
  bool isLoading = true;

  initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _getPublication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: BaseAppBar(),
        drawer: DrawerComponent(),
        body: SizedBox(
          width: double.maxFinite,
          child: isLoading
              ? DefaultCircularIndicator.getIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          _buildBackButton(),
                          _buildImage(),
                          _builInfos(),
                          _buildBlocks(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _buildBackButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: 30,
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            PhosphorIcon(
              IconsList.getIcon('arrow-left'),
              color: theme.colorScheme.secondary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              "Conteúdos",
              style: theme.textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }

  _buildImage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImage(
                imageUrl:
                    "${dotenv.env['IMAGE_URL']}/contents/${publication!.image}"),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        // padding: EdgeInsets.symmetric(horizontal: 20),
        height: 300,
        child: ImageNetworkComponent.getImageNetwork(
          "${dotenv.env['IMAGE_URL']}/contents/${publication!.image}",
          double.infinity,
          double.infinity,
          BoxFit.cover,
        ),
      ),
    );
  }

  _builInfos() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            publication!.title,
            style: theme.textTheme.displayMedium!.copyWith(
              fontSize: 16.h,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: PhosphorIcon(
                      IconsList.getIcon('user'),
                      color: theme.colorScheme.secondary,
                      size: 16,
                    ),
                  ),
                  Text(
                    publication!.admin.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: PhosphorIcon(
                      IconsList.getIcon('calendar-blank'),
                      color: Theme.of(context).colorScheme.secondary,
                      size: 16,
                    ),
                  ),
                  Text(
                    Formatters.formatDateString(publication!.createdAt),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: PhosphorIcon(
                      IconsList.getIcon('squares-four'),
                      color: Theme.of(context).colorScheme.secondary,
                      size: 16,
                    ),
                  ),
                  Text(
                    '--',
                    // publication!.category.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildBlocks() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 40,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var block in publication!.blocks)
            Padding(
              padding: EdgeInsets.only(
                bottom: 20,
              ),
              child: _renderBlock(block),
            ),
        ],
      ),
    );
  }

  _renderBlock(ContentBlock block) {
    switch (block.type) {
      case 1:
        return Text(
          block.content,
          style: theme.textTheme.bodyMedium,
        );
      case 3:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (var image in block.images)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                            imageUrl:
                                "${dotenv.env['IMAGE_URL']}/contents/${image.image}"),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ImageNetworkComponent.getImageNetwork(
                      "${dotenv.env['IMAGE_URL']}/contents/${image.image}",
                      100,
                      100,
                      BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        );
      case 4:
        print(
            "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(block.content)!}/0.jpg");
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => VideoPlayerWidget(
            //       videoUrl: block.content,
            //       contentId: publication!.id,
            //     ),
            //   ),
            // );
          },
          child: Container(
            width: double.infinity,
            height: 250,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                  "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(block.content)!}/0.jpg",
                ),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: PhosphorIcon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        );
      // return VideoPlayerWidget(videoUrl: block.content);
      // case 5:
      //   return SingleChildScrollView(
      //     scrollDirection: Axis.horizontal,
      //     child: Container(
      //       width: 300,
      //       padding: EdgeInsets.symmetric(horizontal: 20),
      //       child: IframeWebView(iframeUrl: block.content),
      //     ),
      //   );
    }
  }

  _getPublication() {
    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.readContent}/${widget.publicationUrl}",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);
      if (data != null) {
        setState(() {
          publication = Content.fromJson(data['content']);
        });
      }
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }
}
