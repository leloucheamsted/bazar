// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// class VideoCard extends StatelessWidget {
//   late VideoPlayerController video;
//   //Video video;
//   const VideoCard({ required this.video, Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//       return Stack(
//         children: [
//           video.controller != null
//               ? GestureDetector(
//                   onTap: () {
//                     if (video.controller!.value.isPlaying) {
//                       video.controller?.pause();
//                     } else {
//                       video.controller?.play();
//                     }
//                   },
//                   child: SizedBox.expand(
//                       child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: video.controller?.value.size.width ?? 0,
//                       height: video.controller?.value.size.height ?? 0,
//                       child: VideoPlayer(video.controller!),
//                     ),
//                   )),
//                 )
//               : Container(
//                   color: Colors.black,
//                   child: Center(
//                     child: Text("Loading"),
//                   ),
//                 ),
      
//         ],
//       );
//     }
//   }
// }