import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class ChatPlayerWidget extends StatefulWidget {
  final String url;
  final PlayerMode mode;

  ChatPlayerWidget({required this.url, this.mode = PlayerMode.MEDIA_PLAYER})
      : super();

  @override
  State<StatefulWidget> createState() {
    return _ChatPlayerWidgetState(mode);
  }
}

class _ChatPlayerWidgetState extends State<ChatPlayerWidget> {
  // late String url;
  late PlayerMode mode;
  AudioCache audioCache = AudioCache();

  late AudioPlayer _audioPlayer;
  // late AudioPlayerState _audioPlayerState;
  Duration? _duration = Duration();
  Duration? _position = Duration();

  late PlayerState _playerState = PlayerState.stopped;
  late PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _playerCompleteSubscription;
  late StreamSubscription _playerErrorSubscription;
  late StreamSubscription _playerStateSubscription;
  // late StreamSubscription<PlayerControlCommand>
  //     _playerControlCommandSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _durationText => _duration.toString().split('.').first;
  get _positionText => _position.toString().split('.').first;

  _ChatPlayerWidgetState(this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();

    print("Audio URL : " + widget.url);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerCompleteSubscription.cancel();
    _playerErrorSubscription.cancel();
    _playerStateSubscription.cancel();
    // _playerControlCommandSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              key: Key('play_pause_button'),
              onTap: _isPlaying ? () => _pause() : () => _play(),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.cyan,
                size: 20,
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  child: Slider(
                    onChanged: (v) {
                      final Position = v * _duration!.inMilliseconds;
                      _audioPlayer
                          .seek(Duration(milliseconds: Position.round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position!.inMilliseconds > 0 &&
                            _position!.inMilliseconds <
                                _duration!.inMilliseconds)
                        ? _position!.inMilliseconds / _duration!.inMilliseconds
                        : 0.0,
                  ),
                ),
              ],
            ),
          ],
        ),

        Text(
          _position != null
              ? '${_positionText ?? ''} / ${_durationText ?? ''}'
              : _duration != null
                  ? _durationText
                  : '',
          style: TextStyle(fontSize: 12, color: Colors.white),
          textAlign: TextAlign.start,
        ),

        // Text('State: $_audioPlayerState')
      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      // if (Theme.of(context).platform == TargetPlatform.iOS) {
      //   // (Optional) listen for notification updates in the background
      //   _audioPlayer.startHeadlessService();

      //   // set at least title to see the notification bar on ios.
      //   _audioPlayer.setNotification(
      //     title: 'App Name',
      //     artist: 'Artist or blank',
      //     albumTitle: 'Name or blank',
      //     imageUrl: 'url or blank',
      //     // forwardSkipInterval: const Duration(seconds: 30), // default is 30s
      //     // backwardSkipInterval: const Duration(seconds: 30), // default is 30s
      //     duration: duration,
      //     elapsedTime: Duration(seconds: 0),
      //     hasNextTrack: true,
      //     hasPreviousTrack: false,
      //   );
      // }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    // _playerControlCommandSubscription =
    //     _audioPlayer.onPlayerCommand.listen((command) {
    //   print('command');
    // });

    // _audioPlayer.onPlayerStateChanged.listen((state) {
    //   if (!mounted) return;
    //   setState(() {
    //     _audioPlayerState = state;
    //   });
    // });

    // _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
    //   if (!mounted) return;
    //   setState(() => _audioPlayerState = state);
    // });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position!.inMilliseconds > 0 &&
            _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(
        "https://schooleverywhere-fisluxor.com/schooleverywhere/recorde/html/soundTeacherRecorde/2132052831473c182d3e14014fa24ce197009f433b129201210308.wav",
        position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
