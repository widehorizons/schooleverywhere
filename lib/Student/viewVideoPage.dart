import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../Constants/StringConstants.dart';
import '../Style/theme.dart';

class viewVideoPage extends StatefulWidget {
  final String lessonId;
  viewVideoPage(this.lessonId);

  @override
  State<StatefulWidget> createState() {
    return new _viewVideoPageState();
  }
}

class _viewVideoPageState extends State<viewVideoPage> {
  late TargetPlatform _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.lessonId)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    ;
    // _videoPlayerController2 = VideoPlayerController.network(widget.lessonId)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    ;
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );

    print(widget.lessonId);
    // this.initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  // Future<void> initializePlayer() async {
  //   _videoPlayerController1 = VideoPlayerController.network(widget.lessonId);
  //   await _videoPlayerController1.initialize();
  //   _videoPlayerController2 = VideoPlayerController.network(widget.lessonId);
  //   await _videoPlayerController2.initialize();
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController1,
  //     autoPlay: true,
  //     looping: true,
  //     // Try playing around with some of these other options:

  //     // showControls: false,
  //     // materialProgressColors: ChewieProgressColors(
  //     //   playedColor: Colors.red,
  //     //   handleColor: Colors.blue,
  //     //   backgroundColor: Colors.grey,
  //     //   bufferedColor: Colors.lightGreen,
  //     // ),
  //     // placeholder: Container(
  //     //   color: Colors.grey,
  //     // ),
  //     // autoInitialize: true,
  //   );
  //   setState(() {});
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Video Demo',
  //     home: Scaffold(
  //       body: Center(
  //         child: _videoPlayerController1.value.isInitialized
  //             ? AspectRatio(
  //                 aspectRatio: _videoPlayerController1.value.aspectRatio,
  //                 child: VideoPlayer(_videoPlayerController1),
  //               )
  //             : Container(),
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: () {
  //           setState(() {
  //             _videoPlayerController1.value.isPlaying
  //                 ? _videoPlayerController1.pause()
  //                 : _videoPlayerController1.play();
  //           });
  //         },
  //         child: Icon(
  //           _videoPlayerController1.value.isPlaying
  //               ? Icons.pause
  //               : Icons.play_arrow,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(SCHOOL_NAME),
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController.videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
          FlatButton(
            onPressed: () {
              _chewieController.enterFullScreen();
            },
            child: Text('Fullscreen'),
          ),
        ],
      ),
    );
  }
}
