class Messages {
  late final String question;
  late final String answer;

  Messages({required this.question, required this.answer});

  Map<String, String> toJson() => {"question": question, "answer": answer};
}

////////////////////////////////////////////////////////////////////////////////////

class NewsRoomData {
  final String sort;
  final String title;
  final String img;
  final String link;

  NewsRoomData(this.sort, this.title, this.img, this.link);
}

class NewsRoomData_Instagram {
  final String sort;
  final String name;
  final String img;
  final String link;
  final String channel_id;
  final String followers;
  final String instagram_id;

  NewsRoomData_Instagram({
    required this.sort,
    required this.name,
    required this.img,
    required this.link,
    required this.channel_id,
    required this.followers,
    required this.instagram_id,
  });

  factory NewsRoomData_Instagram.fromJson(Map<String, dynamic> json) {
    return NewsRoomData_Instagram(
      sort: json['sort'],
      name: json['name'],
      img: json['img'],
      link: json['link'],
      channel_id: json['channel_id'],
      followers: json['followers'],
      instagram_id: json['instagram_id'],
    );
  }
}
