import 'package:bazar/widgets/loading_card.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        // videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.videoUrl != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  GestureDetector(
                      onTap: () {
                        if (videoPlayerController.value.isPlaying) {
                          videoPlayerController.pause();
                        } else {
                          videoPlayerController.play();
                        }
                      },
                      child: SizedBox.expand(
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width:
                                  videoPlayerController.value.size.width ?? 0,
                              height:
                                  videoPlayerController.value.size.height ?? 0,
                              child: VideoPlayer(videoPlayerController),
                            )),
                      ))
                ],
              ),
            ),
          )
        : LoadingScreen();
  }
}
