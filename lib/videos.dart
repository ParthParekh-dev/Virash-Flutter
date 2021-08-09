class LiveSessionVideo {
  final int id;
  final String title;
  final String videoId;

  LiveSessionVideo(
      {required this.id, required this.title, required this.videoId});
}

const List sample_videos = [
  {"id": 1, "title": "Fire Up React.js", "videoId": "103201888"},
  {
    "id": 1,
    "title": "James Bowes - Introduction to GoLang",
    "videoId": "99884953"
  },
  {"id": 1, "title": "Think Erlang", "videoId": "74553076"},
  {
    "id": 1,
    "title": "Web Assembly at the Edge | Web Directions Code 2020",
    "videoId": "463340424"
  },
];
