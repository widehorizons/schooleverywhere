import 'package:schooleverywhere/Student/player_widget.dart';

import '../Style/theme.dart';
import '../Constants/StringConstants.dart';
// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef void OnError(Exception exception);

class viewAudioPage extends StatefulWidget {
  final String lessonId;
  viewAudioPage(this.lessonId);

  @override
  State<StatefulWidget> createState() {
    return new _viewAudioPageState();
  }
}

class _viewAudioPageState extends State<viewAudioPage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  get children => null;

  get key => null;

  @override
  void initState() {
    super.initState();
    print("Lesson Id in Audio Plyer is [${widget.lessonId}]");
    // if (kIsWeb) {
    //   // Calls to Platform.isIOS fails on web
    //   return;
    // }
    // if (Platform.isIOS) {
    //   if (audioCache.fixedPlayer != null) {
    //     audioCache.fixedPlayer!.startHeadlessService();
    //   }
    //   advancedPlayer.startHeadlessService();
    // }
  }

  Widget remoteUrl() {
    return SingleChildScrollView(
      child: _Tab(children: [
        Text(
          'Voice Recorder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: widget.lessonId),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(SCHOOL_NAME),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('img/logo.png'),
                  )
                ],
              ),
              backgroundColor: AppTheme.appColor,
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TabBarView(
                children: [
                  remoteUrl(),
                ],
              ),
            )),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final List<Widget> children;

  const _Tab({required this.children}) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: children
                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList(),
          ),
        ),
      ),
    );
  }
}
