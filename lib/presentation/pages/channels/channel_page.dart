import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lentach/domain/entities/channel.dart';
import 'package:lentach/injection_container.dart' as di;
import 'package:lentach/presentation/blocs/channels_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/usecases/channel.dart';

class ChannelPage extends StatefulWidget {
  final Channel channel;

  const ChannelPage({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelPage> createState() => _ChannelPageState(channel);
}

class _ChannelPageState extends State<ChannelPage> {
  final channels = di.sl<GetChannels>();
  final Channel channel;

  _ChannelPageState(this.channel);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChannelsBloc(di.sl<GetChannels>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(channel.title),
        ),
        body: ChannelBuild(channel: channel),
      ),
    );
  }
}

class ChannelBuild extends StatelessWidget {
  final Channel channel;

  const ChannelBuild({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        PostWidget(
          avatarUrl: "https://telegrator.ru/wp-content/uploads/2020/01/chat_avatar-46.jpg", // Замените на URL вашего аватара
          username: 'AnimeVost.org - аниме стабильно и без задержек.',
          content: 'asdads\ndasdsdadsa as sad ds das',
          imageUrl: '', // Если нет изображения, оставьте пустым
          videoUrl: '', // Если нет видео, оставьте пустым
        ),
        SizedBox(height: 10),
        PostWidget(
          avatarUrl: "https://telegrator.ru/wp-content/uploads/2020/01/chat_avatar-46.jpg", // Замените на URL вашего аватара
          username: 'AnimeVost.org - аниме стабильно и без задержек.',
          content: '',
          imageUrl: 'http://192.168.0.156:8080/storage/image/y70MehCKqh2Vflof.png', // Замените на URL вашего изображения
          videoUrl: '', // Если нет видео, оставьте пустым
        ),
        SizedBox(height: 10),
        PostWidget(
          avatarUrl: "https://telegrator.ru/wp-content/uploads/2020/01/chat_avatar-46.jpg", // Замените на URL вашего аватара
          username: 'AnimeVost.org - аниме стабильно и без задержек.',
          content: '',
          imageUrl: '', // Если нет изображения, оставьте пустым
          videoUrl: 'http://192.168.0.156:8080/storage/video/AWp0zDMlLQgWe534.mp4', // Замените на URL вашего видео
        ),
      ],
    );
    // return Container(decoration: BoxDecoration(color: Colors.blue),);
  }
}

class PostWidget extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String content;
  final String imageUrl;
  final String videoUrl;

  const PostWidget({
    Key? key,
    required this.avatarUrl,
    required this.username,
    required this.content,
    required this.imageUrl,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (content.isNotEmpty) ...[
              Text(content),
              SizedBox(height: 10),
            ],
            if (imageUrl.isNotEmpty) ...[
              Image.network(imageUrl),
              SizedBox(height: 10),
            ],
            if (videoUrl.isNotEmpty) ...[
              VideoPlayerWidget(url: videoUrl),
              SizedBox(height: 10),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.favorite_border, color: Colors.grey),
                Icon(Icons.remove_red_eye, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {}); // Ensure the UI gets rebuilt once the video is initialized
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    _ControlsOverlay(controller: _controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.fullscreen, color: Colors.white),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenVideoPlayer(controller: _controller),
                            ),
                          );
                          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
        ),
      ],
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  static const _iconSize = 30.0;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: _iconSize,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    _enterFullScreen();
    widget.controller.addListener(_onVideoEnd);
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Scaffold.of(context).
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    // ]);
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
  }

  void _onVideoEnd() {
    if (widget.controller.value.position == widget.controller.value.duration) {
      _exitFullScreen();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _exitFullScreen();
    widget.controller.removeListener(_onVideoEnd);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(widget.controller),
              _ControlsOverlay(controller: widget.controller),
              VideoProgressIndicator(widget.controller, allowScrubbing: true),
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: () {
                    _exitFullScreen();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}