import 'package:flutter/material.dart';
import 'package:flutter_virash/videos.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_virash/animationWidgets.dart';

class LiveSession extends StatefulWidget {
  static var route = '/liveSession';

  @override
  _LiveSessionState createState() => _LiveSessionState();
}

class _LiveSessionState extends State<LiveSession> {
  List<LiveSessionVideo> _videos = sample_videos
      .map(
        (video) => LiveSessionVideo(
            id: video['id'], title: video['title'], videoId: video['videoId']),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = context.watch<InternetProvider>().isConnected;
    if (!isConnected) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationWidgets().noInternet,
        )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Live Sessions'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          child: VimeoPlayer(
                            videoId: "${_videos[index].videoId}",
                          ),
                        ),
                        Text(
                          "${_videos[index].title}",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )),
        ),
      );
    }
  }
}
