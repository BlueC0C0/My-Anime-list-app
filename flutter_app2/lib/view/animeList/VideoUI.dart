import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/anime/video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoUI extends StatefulWidget {
  final Video video;

  VideoUI(this.video);

  @override
  _VideoUIState createState() => _VideoUIState();
}

class _VideoUIState extends State<VideoUI> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayerController.convertUrlToId(widget.video.url),
        params: YoutubePlayerParams(
          autoPlay: false,
          showFullscreenButton: true,
          showVideoAnnotations: false,
        ));

    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    };
  }

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();

    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Stack(
              children: [
                player,
                !isPlaying
                    ? Positioned.fill(
                        child: Material(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  YoutubePlayerController.getThumbnail(
                                    videoId:
                                        YoutubePlayerController.convertUrlToId(
                                            widget.video.url),
                                    quality: ThumbnailQuality.medium,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                !isPlaying
                    ? Positioned.fill(
                        child: YoutubeValueBuilder(
                          controller: _controller,
                          builder: (context, value) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  print("je suis la");
                                  print(value.playerState);
                                  _controller.play();
                                  print(value.playerState);
                                  isPlaying = true;
                                });
                              },
                              child: Container(
                                color: Colors.black.withOpacity(0.3),
                                child: const Center(
                                  child: Icon(Icons.play_arrow, size: 70),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
