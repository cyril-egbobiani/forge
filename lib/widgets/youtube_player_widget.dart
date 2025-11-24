// import 'package:flutter/material.dart';
 
// class YoutubePlayerWidget extends StatefulWidget {
//   final String youtubeUrl;
//   const YoutubePlayerWidget({super.key, required this.youtubeUrl});

//   @override
//   State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
// }

// class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
//     _controller = YoutubePlayerController(
//       initialVideoId: videoId ?? '',
//       flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayer(
//       controller: _controller,
//       showVideoProgressIndicator: true,
//       progressIndicatorColor: Colors.amber,
//     );
//   }
// }
