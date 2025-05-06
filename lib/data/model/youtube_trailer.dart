class YoutubeTrailerListData {
  final int? id;
  final List<YoutubeTrailer>? results;

  YoutubeTrailerListData({this.id, this.results});

  factory YoutubeTrailerListData.fromJson(Map<String, dynamic> json) {
    return YoutubeTrailerListData(
      id: json['id'],
      results:
          (json['results'] as List?)
              ?.map((e) => YoutubeTrailer.fromJson(e))
              .toList(),
    );
  }
}

class YoutubeTrailer {
  final String? name;
  final String? key;
  final String? site;
  final String? type;
  final String? id;

  YoutubeTrailer({this.name, this.key, this.site, this.type, this.id});

  factory YoutubeTrailer.fromJson(Map<String, dynamic> json) {
    return YoutubeTrailer(
      name: json['name'],
      key: json['key'],
      site: json['site'],
      type: json['type'],
      id: json['id'],
    );
  }
}
