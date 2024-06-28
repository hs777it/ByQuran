import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // ^0.9.35
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:welivewithquran/constant.dart';

class JustAudio extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const JustAudio(this.audioUrl, {this.speed = false, this.volume = false});

  final String audioUrl;
  final bool speed, volume;
  @override
  State<JustAudio> createState() => _JustAudioState();
}

class _JustAudioState extends State<JustAudio> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer(widget.audioUrl);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: Padding(
                    padding: EdgeInsets.only(top: 18), child: _progessBar()),
              ),
              _playbackControlButton(),
            ]),
            Row(
              children: [
                _controlButtons(),
                //_playbackControlButton(),
              ],
            )
          ]),
    );
  }

  Future<void> _setupAudioPlayer(String url) async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stacktrace) {
      print("A stream error occurred: $e");
    });
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Widget _progessBar() {
    return StreamBuilder<Duration?>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        return ProgressBar(
          baseBarColor: kSecondryColor,
          progressBarColor: kMainColor,
          bufferedBarColor: kMainColor, //Color.fromARGB(255, 2, 168, 223),
          thumbColor: kBlueGrey,
          progress: snapshot.data ?? Duration.zero,
          buffered: _player.bufferedPosition,
          total: _player.duration ?? Duration.zero,
          onSeek: (duration) {
            _player.seek(duration);
          },
        );
      },
    );
  }

  Widget _playbackControlButton() {
    return StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final processingState = snapshot.data?.processingState;
          final playing = snapshot.data?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 32,
              height: 32,
              child: const CircularProgressIndicator(
                color: kSecondryColor,
              ),
            );
          } else if (playing != true) {
            return customButton(const Icon(Icons.play_arrow), _player.play);
          } else if (processingState != ProcessingState.completed) {
            return customButton(const Icon(Icons.pause), _player.pause);
          } else {
            return customButton(
                const Icon(Icons.replay), () => _player.seek(Duration.zero));
          }
        });
  }

  Widget _controlButtons() {
    return Column(children: [
      StreamBuilder(
          stream: _player.speedStream,
          builder: (context, snapshot) {
            if (widget.speed) {
              return Row(children: [
                const Icon(Icons.speed),
                Slider(
                    min: 1,
                    max: 3,
                    value: snapshot.data ?? 1,
                    divisions: 3,
                    onChanged: (value) async {
                      await _player.setSpeed(value);
                    })
              ]);
            } else {
              return const SizedBox();
            }
          }),
      StreamBuilder(
          stream: _player.volumeStream,
          builder: (context, snapshot) {
            if (widget.volume) {
              return Row(children: [
                const Icon(Icons.volume_up),
                Slider(
                    min: 0,
                    max: 5,
                    value: snapshot.data ?? 1,
                    divisions: 5,
                    onChanged: (value) async {
                      await _player.setVolume(value);
                    })
              ]);
            } else {
              return const SizedBox();
            }
          }),
    ]);
  }

  customButton(Widget icon, void Function()? func) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300, width: 1),
        shape: BoxShape.circle,
        //color: Colors.yellow,
      ),
      child: IconButton(
        icon: icon,
        iconSize: 32,
        onPressed: func,
      ),
    );
  }
}
