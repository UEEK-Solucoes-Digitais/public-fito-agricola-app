import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final int videoId;
  Function() reloadItems;
  String startAt;
  String durationTime;
  Function(int videoId) checkNextVideo;

  VideoPlayerWidget({
    required this.videoUrl,
    required this.videoId,
    required this.reloadItems,
    required this.startAt,
    required this.durationTime,
    required this.checkNextVideo,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  Duration lastPosition = Duration(seconds: 0, milliseconds: 0);
  bool isRequesting = false;
  Admin admin = PrefUtils().getAdmin();
  bool isFinished = false;

  _getVideoUrl() {
    if (widget.videoUrl.contains('live') ||
        widget.videoUrl.contains('shorts')) {
      return widget.videoUrl.split('/').last.split('?').first;
    }

    return YoutubePlayer.convertUrlToId(widget.videoUrl);
  }

  _convertToSeconds(String time) {
    List<String> timeList = time.split(':');
    return int.parse(timeList[0]) * 3600 +
        int.parse(timeList[1]) * 60 +
        int.parse(timeList[2]);
  }

  @override
  void initState() {
    super.initState();
    // int startAt = 0;

    // converter duração em segundos
    // if (widget.startAt != '') {
    //   startAt = _convertToSeconds(widget.startAt);
    //   print("começar em ${startAt}");
    // }

    _controller = YoutubePlayerController(
      initialVideoId: _getVideoUrl(),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: false,
        forceHD: true,
        mute: false,
        // startAt: startAt,
      ),
    );

    _controller.addListener(_checkVideo);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return Stack(
              children: [
                Center(
                  child: isFinished
                      ? Container(
                          height: 210.v,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://img.youtube.com/vi/${_getVideoUrl()}/0.jpg"),
                              fit: BoxFit.cover,
                              opacity: 0.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Você já finalizou este vídeo!",
                                style: CustomTextStyles.bodyLargeOnWhite,
                              ),
                              const SizedBox(height: 10),
                              CustomElevatedButton(
                                text: "Assistir novamente",
                                width: 200.v,
                                height: 40.v,
                                onPressed: () {
                                  _controller.seekTo(
                                    Duration(seconds: 0),
                                    allowSeekAhead: false,
                                  );
                                  setState(() {
                                    isFinished = false;
                                  });
                                },
                              ),
                              widget.checkNextVideo(widget.videoId),
                            ],
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: _getAspectRatio(orientation),
                          // aspectRatio: _getAspectRatio(orientation),
                          child: YoutubePlayer(
                            aspectRatio: widget.videoUrl.contains('shorts')
                                ? (9 / 16)
                                : (16 / 9),
                            width: MediaQuery.of(context).size.width,
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            bottomActions: [
                              CurrentPosition(
                                controller: _controller,
                              ),
                              ProgressBar(
                                controller: _controller,
                                isExpanded: true,
                              ),
                              RemainingDuration(
                                controller: _controller,
                              ),
                              PlaybackSpeedButton(
                                controller: _controller,
                              ),
                              if (!widget.videoUrl.contains('shorts'))
                                FullScreenButton(
                                  controller: _controller,
                                  color: Colors.white,
                                ),
                            ],
                            onReady: () => {
                              if (widget.startAt != '' &&
                                  widget.startAt != '00:00:00' &&
                                  widget.startAt != widget.durationTime)
                                {
                                  _controller.seekTo(Duration(
                                      seconds:
                                          _convertToSeconds(widget.startAt)))
                                }
                            },
                            onEnded: (metaData) {
                              _finishVideo();
                            },
                          ),
                        ),
                ),
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                      widget.reloadItems();
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 40,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          Text(
                            'Voltar',
                            style: CustomTextStyles.bodyLargeOnWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                  top: 0,
                  left: 0,
                ),
              ],
            );
          },
        );
      }),
    );
  }

  double _getAspectRatio(Orientation screenOrientation) {
    final isVideoHorizontal = widget.videoUrl.contains('shorts');
    final isScreenPortrait = screenOrientation == Orientation.portrait;

    if (isVideoHorizontal) {
      return 9 / 16;
    } else {
      return isScreenPortrait ? MediaQuery.of(context).size.aspectRatio : 1.5;
    }
  }

  _checkVideo() {
    // verificando se o duration anterior for 0 ou se o duration atual for 10 segundos maior que o anterior
    if (_controller.value.position.inSeconds == 1 ||
        (_controller.value.position.inMilliseconds -
                lastPosition.inMilliseconds >=
            15000) ||
        (_controller.value.position.inMilliseconds -
                lastPosition.inMilliseconds <
            0)) {
      if (isRequesting) return;

      setState(() {
        isRequesting = true;
      });

      String hours = _controller.value.position.inHours
          .toString()
          .padLeft(2, "0")
          .substring(0, 2);
      String minutes = _controller.value.position.inMinutes
          .toString()
          .padLeft(2, "0")
          .substring(0, 2);
      String seconds = _controller.value.position.inSeconds
          .toString()
          .padLeft(2, "0")
          .substring(0, 2);

      print("${hours}:${minutes}:${seconds}");

      DefaultRequest.simplePostRequest(
        ApiRoutes.updateWatched,
        {
          'admin_id': admin.id,
          'content_video_id': widget.videoId,
          'item': 'last_second',
          'value': "${hours}:${minutes}:${seconds}",
        },
        null,
        showSnackBar: 0,
        closeModal: false,
      ).then((value) {
        if (value) {
          print('alterado com sucesso');
          lastPosition = _controller.value.position;
          isRequesting = false;
          setState(() {});
        }
      });
    }
  }

  _finishVideo() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await DefaultRequest.simplePostRequest(
      ApiRoutes.updateWatched,
      {
        'admin_id': admin.id,
        'content_video_id': widget.videoId,
        'item': 'last_second',
        'value': widget.durationTime,
      },
      null,
      showSnackBar: 0,
      closeModal: false,
    ).then((value) {
      if (value) {}
    });

    await DefaultRequest.simplePostRequest(
      ApiRoutes.updateWatched,
      {
        'admin_id': admin.id,
        'content_video_id': widget.videoId,
        'item': 'is_finished',
        'value': "1",
      },
      null,
      showSnackBar: 0,
      closeModal: false,
    ).then((value) {
      if (value) {
        widget.reloadItems();
        setState(() {
          isFinished = true;
        });
        // Navigator.pop(context);
      }
    });
  }
}
