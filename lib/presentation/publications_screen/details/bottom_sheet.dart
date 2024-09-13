import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/comments/comments.dart';
import 'package:fitoagricola/data/models/content/content.dart';
import 'package:fitoagricola/data/models/content_block/content_block.dart';
import 'package:fitoagricola/data/models/content_category/content_category.dart';
import 'package:fitoagricola/presentation/publications_screen/video_player/video_player_widget.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/fullscreen_image.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class Bottomsheet extends StatefulWidget {
  String contentUrl;
  Function() reloadItems;
  bool keepWatching;

  Bottomsheet({
    required this.contentUrl,
    required this.reloadItems,
    required this.keepWatching,
    super.key,
  });

  @override
  State<Bottomsheet> createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet> {
  bool isLoading = true;
  Content? content;
  Admin admin = PrefUtils().getAdmin();
  bool isSubmitting = false;
  List<ContentCategory> categories = [];
  bool alreadyPlayed = false;

  List<Map<String, dynamic>> textEditController = [
    {
      'id': 0,
      'controller': TextEditingController(),
      'isAnswering': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator(color: Colors.white)
        : ListView(children: [
            // _buildImage(context, content!),
            _builInfos(context, content!),
            _buildComments(context, content!),
            _buildCommentBox(context, content!, null, 0),
            SizedBox(
              height: 20,
            ),
          ]);
  }

  _handleUpdateItens() {
    _getContent();
    widget.reloadItems();
  }

  _getContent() {
    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.readContent}/${admin.id}/${widget.contentUrl}?is_from_mobile=true",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);
      if (data['content'] != null) {
        setState(() {
          content = Content.fromJson(data['content']);
          categories = ContentCategory.listFromJson(data['content_categories']);
          isLoading = false;
        });

        if (content != null &&
            (widget.keepWatching &&
                content!.currentVideo != null &&
                content!.currentVideo != 0) &&
            !alreadyPlayed) {
          final video = content!.videos!
              .firstWhere((element) => element.id == content!.currentVideo);

          if (video != null) {
            setState(() {
              alreadyPlayed = true;
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerWidget(
                  videoUrl: video.videoLink,
                  videoId: video.id,
                  reloadItems: _handleUpdateItens,
                  startAt: video.watchedSeconds!,
                  durationTime: video.durationTime,
                  checkNextVideo: _checkNextVideo,
                ),
              ),
            );
          }
        }

        _setFields();
      }
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  _setFields() {
    // adicionando controllers para os campos de edição

    textEditController = [
      {
        'id': 0,
        'controller': TextEditingController(),
        'isAnswering': false,
      }
    ];

    for (var comment in content!.comments) {
      textEditController.add({
        'id': comment.id,
        'controller': TextEditingController(text: comment.text),
        'isAnswering': false,
      });

      for (var answer in comment.answers) {
        textEditController.add({
          'id': answer.id,
          'controller': TextEditingController(text: answer.text),
          'isAnswering': false,
        });
      }
    }

    setState(() {});
  }

  _buildImage(BuildContext context, Content content) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.h),
            topRight: Radius.circular(5.h),
          ),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 20),
        height: content.isCourse == 1 ? SizeUtils.width : null,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: content.isCourse == 1
                  ? EdgeInsets.only(
                      left: 20,
                      top: 20,
                    )
                  : null,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl:
                            "${dotenv.env['IMAGE_URL']}/contents/${content.isCourse == 1 ? content.courseCover : content.image}",
                      ),
                    ),
                  );
                },
                child: Image.network(
                  "${dotenv.env['IMAGE_URL']}/contents/${content.isCourse == 1 ? content.courseCover : content.image}",
                  fit: BoxFit.contain,
                  width: content.isCourse == 1 ? null : double.infinity,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colorScheme.primary,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: PhosphorIcon(
                    IconsList.getIcon('x'),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildButtons(BuildContext context, Content content) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: content.text != ''
          ? EdgeInsets.symmetric(vertical: 20)
          : EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.gray500,
            width: 1,
          ),
          bottom: BorderSide(
            color: appTheme.gray500,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (content.videoLink != '')
          //   CustomFilledButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => VideoPlayerWidget(
          //             videoUrl: content.videoLink,
          //             contentId: content.id,
          //             reloadItems: widget.reloadItems,
          //             startAt: content.watchedSeconds,
          //           ),
          //         ),
          //       );
          //     },
          //     text: "Assistir",
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(5.h),
          //       ),
          //     ),
          //     buttonStyle: ButtonStyle(
          //       backgroundColor: WidgetStatePropertyAll(
          //           Theme.of(context).colorScheme.secondary),
          //     ),
          //     leftIcon: PhosphorIcon(
          //       Icons.play_circle,
          //       color: Colors.white,
          //       size: 28,
          //     ),
          //   ),
          _buildActionsButtons(context, content),
        ],
      ),
    );
  }

  _buildActionsButtons(BuildContext context, Content content) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _saveInteraction(context, content, 2),
          child: Row(
            children: [
              PhosphorIcon(
                IconsList.getIcon(
                    content.isLiked == 1 ? 'heart-filled' : 'heart'),
                color: content.isLiked == 1
                    ? theme.colorScheme.secondary
                    : appTheme.gray400,
                size: 30,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 5),
              //   child: Text(
              //     'Recomendar',
              //     style: Theme.of(context).textTheme.displaySmall!.copyWith(
              //           fontSize: 16.h,
              //         ),
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => _saveInteraction(context, content, 1),
          child: Row(
            children: [
              PhosphorIcon(
                content.isSaved == 1
                    ? IconsList.getIcon('x-circle-filled')
                    : IconsList.getIcon('plus-circle'),
                color:
                    content.isSaved == 1 ? appTheme.red600 : appTheme.gray400,
                size: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  content.isSaved == 1
                      ? "Remover da minha lista "
                      : 'Minha lista',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 16.h,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _builInfos(BuildContext context, Content content) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    content.title,
                    style: theme.textTheme.headlineLarge!.copyWith(
                      fontSize: 20.h,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: PhosphorIcon(
                      IconsList.getIcon('x'),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                      color: appTheme.gray400,
                      size: 16,
                    ),
                  ),
                  Text(
                    content.admin.name,
                    style: theme.textTheme.displaySmall,
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
                      color: appTheme.gray400,
                      size: 16,
                    ),
                  ),
                  Text(
                    Formatters.formatDateString(content.createdAt),
                    style: Theme.of(context).textTheme.displaySmall,
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
                      color: appTheme.gray400,
                      size: 16,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      _getCategoriesNames(),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildButtons(context, content),
          // _buildBlocks(),
          if (content.text != '')
            Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  content.text,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: appTheme.whiteA700,
                    fontSize: 16.v,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),

          _buildVideos(content),
          // Text(
          //   content.durationTime,
          //   style: theme.textTheme.labelLarge!.copyWith(
          //     color: appTheme.whiteA700,
          //   ),
          // ),
        ],
      ),
    );
  }

  _buildVideos(Content content) {
    if (content.videos == null || content.videos!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.only(top: 20),
      margin: EdgeInsets.only(top: content.text != '' ? 20 : 0),
      width: double.infinity,
      decoration: content.text != ''
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: appTheme.gray500,
                  width: 1,
                ),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var video in content.videos!)
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (video.title != '')
                      Text(
                        video.title,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: appTheme.whiteA700,
                          fontSize: 18.v,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Image.network(
                          "https://img.youtube.com/vi/${_getVideoUrl(video.videoLink)}/0.jpg",
                          height: 210.v,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    if (video.description != '')
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            video.description,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: appTheme.whiteA700,
                              // fontSize: 18.v,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    Text(
                      "${video.watchedSeconds != '' ? "${video.watchedSeconds} / " : ''}${video.durationTime}",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: appTheme.whiteA700,
                        // fontSize: 18.v,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomFilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerWidget(
                              videoUrl: video.videoLink,
                              videoId: video.id,
                              reloadItems: _handleUpdateItens,
                              startAt: video.watchedSeconds!,
                              durationTime: video.durationTime,
                              checkNextVideo: _checkNextVideo,
                            ),
                          ),
                        );
                      },
                      text: "Assistir",
                      buttonStyle: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.secondary,
                        ),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.h),
                        )),
                      ),
                      leftIcon: PhosphorIcon(
                        IconsList.getIcon('play-circle'),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  _buildBlocks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var block in content!.blocks)
          Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            child: _renderBlock(block),
          ),
      ],
    );
  }

  _renderBlock(ContentBlock block) {
    switch (block.type) {
      case 1:
        return Text(
          block.content,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: appTheme.whiteA700,
            fontSize: 16.v,
          ),
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
                    child: Image.network(
                      "${dotenv.env['IMAGE_URL']}/contents/${image.image}",
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
            ],
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

  _getCategoriesNames() {
    final categoriesIds = content!.categoriesIds;

    return categories
        .where((element) => categoriesIds.contains(element.id.toString()))
        .map((e) => e.name.trim())
        .join(', ');
  }

  _buildComments(BuildContext context, Content content) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.comments
            .map<Widget>(
              (comment) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appTheme.black600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCommentHeader(context, comment),
                        SizedBox(
                          height: 12,
                        ),
                        _buildCommentText(context, comment),
                        SizedBox(
                          height: 12,
                        ),
                        _buildFooter(context, comment),
                        SizedBox(
                          height: 20,
                        ),
                        _buildResponses(context, comment),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  _buildCommentHeader(BuildContext context, Comment comment) {
    return Row(
      children: [
        comment.admin.profilePicture != null &&
                comment.admin.profilePicture != ''
            ? CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "${dotenv.env['IMAGE_URL']}/admins/${comment.admin.profilePicture}",
                ),
              )
            : CircleAvatar(
                radius: 20,
                backgroundColor: appTheme.gray400,
                child: Text(
                  comment.admin.name[0],
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: appTheme.whiteA700,
                    fontSize: 17,
                  ),
                ),
              ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (comment.adminId == admin.id) ...[
                Text(
                  textAlign: TextAlign.start,
                  'Você',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
              ] else ...[
                Text(
                  textAlign: TextAlign.start,
                  comment.admin.name,
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 17,
                  ),
                ),
              ],
              Text(
                _getCreatedAt(comment.createdAt),
                textAlign: TextAlign.start,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: appTheme.gray400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _getCreatedAt(String createdAt) {
    // aqui temos que verificar se a data é de hoje, se for, mostrar a diferença de horas ou minutos
    final date = DateTime.parse(createdAt);
    final now = DateTime.now();

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'Agora mesmo';
      }

      if (difference.inHours > 0) {
        return 'Há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      } else {
        return 'Há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
      }
    }

    return Formatters.formatDateStringWithHours(createdAt);
  }

  _buildCommentText(BuildContext context, Comment comment) {
    final controller = textEditController.firstWhere(
      (element) => element['id'] == comment.id,
      orElse: () => {'controller': TextEditingController()},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (comment.edit) ...[
          TextField(
            controller: controller['controller'],
            style: theme.textTheme.labelLarge!.copyWith(
              color: appTheme.whiteA700,
              fontSize: 17.v,
            ),
            keyboardType: TextInputType.multiline,
            minLines: 3, //Normal textInputField will be displayed
            maxLines: 99, //
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: appTheme.whiteA700),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: appTheme.whiteA700),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: appTheme.whiteA700),
              ),
            ),
          ),
        ] else ...[
          Text(
            comment.text,
            style: theme.textTheme.labelLarge!.copyWith(
              color: appTheme.whiteA700,
              fontSize: 15.v,
            ),
            maxLines: comment.showAll ? 99 : 3,
            overflow: TextOverflow.ellipsis,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comment.text.length > 115
                ? [
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => comment.showAll = !comment.showAll);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          comment.showAll ? 'Ler menos' : 'Ler completo',
                          textAlign: TextAlign.start,
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: theme.colorScheme.secondary,
                            fontSize: 15.v,
                          ),
                        ),
                      ),
                    ),
                  ]
                : [],
          ),
        ],
      ],
    );
  }

  _buildFooter(BuildContext context, Comment comment) {
    final editFunction = textEditController.firstWhere(
      (element) => element['id'] == comment.id,
      orElse: () => {'controller': TextEditingController()},
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                _likeComment(context, comment);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: appTheme.black200,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.heart(comment.isLiked == 1
                          ? PhosphorIconsStyle.fill
                          : PhosphorIconsStyle.regular),
                      color: comment.isLiked == 1
                          ? theme.colorScheme.secondary
                          : appTheme.gray400,
                      size: 24,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      comment.likes.toString(),
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.secondary,
                        fontSize: 20.v,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (comment.adminId == admin.id) ...[
              // SizedBox(width: 170.v),
              if (comment.edit == true) ...[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _formComment(
                            context, comment, editFunction['controller']);
                      },
                      child: PhosphorIcon(
                        IconsList.getIcon('check'),
                        color: theme.colorScheme.secondary,
                        size: 28,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showEditing(context, comment);
                      },
                      child: PhosphorIcon(
                        IconsList.getIcon('x'),
                        color: theme.colorScheme.error,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showEditing(context, comment);
                      },
                      child: PhosphorIcon(
                        IconsList.getIcon('pencil-simple'),
                        color: appTheme.gray400,
                        size: 28,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _deleteComent(context, comment.id);
                      },
                      child: PhosphorIcon(
                        IconsList.getIcon('trash'),
                        color: theme.colorScheme.error,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ]
            ] else ...[
              // SizedBox(width: 110.v),
              if (comment.answerId == null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      editFunction['isAnswering'] =
                          !editFunction['isAnswering'];
                    });
                  },
                  child: Row(
                    children: [
                      PhosphorIcon(
                        editFunction['isAnswering']
                            ? PhosphorIcons.x()
                            : PhosphorIcons.arrowBendUpLeft(
                                PhosphorIconsStyle.fill),
                        color: theme.colorScheme.secondary,
                        size: 28,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        editFunction['isAnswering'] ? "Cancelar" : 'Responder',
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: theme.colorScheme.secondary,
                          fontSize: 16.v,
                        ),
                      ),
                    ],
                  ),
                ),
            ]
          ],
        ),
        if (editFunction['isAnswering'])
          _buildCommentBox(context, content!, comment.id, 0),
      ],
    );
  }

  _buildResponses(BuildContext context, Comment comment) {
    if (comment.answers.isEmpty) {
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(),
                VerticalDivider(
                  color: appTheme.black200,
                  thickness: 2,
                ),
                SizedBox(
                  width: 20.v,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: comment.answers
                        .take(comment.showAllResponses
                            ? comment.answers.length
                            : 0)
                        .map<Widget>(
                          (comment) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCommentHeader(context, comment),
                              SizedBox(
                                height: 12,
                              ),
                              _buildCommentText(context, comment),
                              SizedBox(
                                height: 12,
                              ),
                              _buildFooter(context, comment),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                  () => comment.showAllResponses = !comment.showAllResponses);
            },
            child: Text(
              comment.showAllResponses
                  ? 'Ocultar respostas'
                  : 'Mostrar respostas (${comment.answers.length})',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.secondary,
                fontSize: 15.v,
              ),
            ),
          ),
        ],
      );
    }
  }

  _buildCommentBox(
    BuildContext context,
    Content content,
    int? answerId,
    int id,
  ) {
    final controller = textEditController.firstWhere(
      (element) => element['id'] == id,
      orElse: () => {'controller': TextEditingController()},
    );

    Comment newComment = Comment(
      id: 0,
      adminId: admin.id,
      contentId: content.id,
      answerId: answerId,
      text: controller['controller'].text,
      likes: 0,
      createdAt: '',
      admin: admin,
      answers: [],
      showAll: false,
      showAllResponses: true,
      edit: false,
      isLiked: 0,
    );

    return Padding(
      padding: answerId != null
          ? EdgeInsets.only(top: 15)
          : EdgeInsets.fromLTRB(20, 5, 20, 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: appTheme.black600,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: answerId != null
              ? const EdgeInsets.all(0)
              : const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                controller['controller'],
                'Escreva ${answerId != null ? 'uma resposta' : 'um comentário'}',
                "Digite aqui",
                minLines: 3,
                maxLines: 10,
                labelStyle: theme.textTheme.labelLarge!.copyWith(
                  color: appTheme.whiteA700,
                  fontSize: 17.v,
                ),
                inputTextStyle: 'primary-white',
                maxLength: 999,
              ),
              SizedBox(
                height: 20,
              ),
              CustomFilledButton(
                onPressed: () {
                  _formComment(context, newComment, controller['controller']);
                },
                text: 'Publicar',
                isDisabled: isSubmitting,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.h),
                  ),
                ),
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.secondary),
                ),
                buttonTextStyle: TextStyle(
                  color: appTheme.black600,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteComent(BuildContext context, int id) {
    Dialogs.showDeleteDialog(
      context,
      title: "Remover comentário",
      text: "Deseja realmente remover este comentário?",
      textButton: "Excluir",
      onClick: () {
        DefaultRequest.simplePostRequest(
          ApiRoutes.removeComment,
          {
            "id": id.toString(),
            "admin_id": admin.id.toString(),
          },
          context,
        ).then((value) {
          _getContent();
        }).catchError((error) {
          print(error);
        });
      },
    );
  }

  void _showEditing(BuildContext context, Comment comment) {
    setState(() => comment.edit = !comment.edit);
  }

  void _formComment(
    BuildContext context,
    Comment comment,
    TextEditingController controller,
  ) {
    if (controller.text != '') {
      setState(() {
        isSubmitting = true;
      });

      print({
        'id': comment.id,
        'admin_id': comment.adminId,
        'content_id': comment.contentId,
        'answer_id': comment.answerId,
        'text': controller.text,
      });
      DefaultRequest.simplePostRequest(
        ApiRoutes.formComment,
        {
          'id': comment.id,
          'admin_id': comment.adminId,
          'content_id': comment.contentId,
          'answer_id': comment.answerId,
          'text': controller.text,
        },
        context,
      ).then((value) {
        if (value) {
          _getContent();

          setState(() {
            isSubmitting = false;
            controller.text = '';
          });
        }
      }).catchError((error) {
        print(error);
      }).whenComplete(() {
        setState(() {
          isSubmitting = false;
        });
      });
    }
  }

  _likeComment(BuildContext context, Comment comment) {
    DefaultRequest.simplePostRequest(
      ApiRoutes.likeComment,
      {
        'content_comment_id': comment.id,
        'admin_id': admin.id,
      },
      context,
      showSnackBar: 0,
    ).then((value) {
      if (value) {
        setState(() {
          comment.likes =
              comment.isLiked == 1 ? comment.likes - 1 : comment.likes + 1;
          comment.isLiked = comment.isLiked == 1 ? 0 : 1;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  _saveInteraction(BuildContext context, Content content, int type) {
    DefaultRequest.simplePostRequest(
      ApiRoutes.saveInteraction,
      {
        'content_id': content.id,
        'admin_id': admin.id,
        'interaction': type == 1 ? 'is_saved' : 'is_liked',
      },
      context,
      showSnackBar: 0,
    ).then((value) {
      print(value);
      if (value) {
        if (type == 1) {
          content.isSaved = content.isSaved == 1 ? 0 : 1;
        } else {
          content.isLiked = content.isLiked == 1 ? 0 : 1;
        }

        setState(() {});
        widget.reloadItems();
      }
    }).catchError((error) {
      print(error);
    });
  }

  _getVideoUrl(String url) {
    if (url.contains('live')) {
      return url.split('/').last.split('?').first;
    }

    return YoutubePlayer.convertUrlToId(url);
  }

  _checkNextVideo(int videoId) {
    if (content!.videos!.length <= 1) {
      return SizedBox();
    }

    if (content!.videos!.last.id == videoId) {
      return SizedBox();
    }

    final index =
        content!.videos!.indexWhere((element) => element.id == videoId);
    final video = content!.videos![index + 1];

    return Column(
      children: [
        const SizedBox(height: 5),
        CustomFilledButton(
          width: 200.v,
          height: 40.v,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerWidget(
                  videoUrl: video.videoLink,
                  videoId: video.id,
                  reloadItems: _handleUpdateItens,
                  startAt: video.watchedSeconds!,
                  durationTime: video.durationTime,
                  checkNextVideo: _checkNextVideo,
                ),
              ),
            );
          },
          text: "Próximo vídeo",
        ),
      ],
    );
  }
}
