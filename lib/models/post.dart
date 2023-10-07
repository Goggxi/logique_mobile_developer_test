import 'user.dart';

class Post {
  final String id;
  final String image;
  final int likes;
  final List<String> tags;
  final String text;
  final DateTime publishDate;
  final User owner;

  Post({
    required this.id,
    required this.image,
    required this.likes,
    required this.tags,
    required this.text,
    required this.publishDate,
    required this.owner,
  });

  factory Post.empty() => Post(
        id: "",
        image: "",
        likes: 0,
        tags: [],
        text: "",
        publishDate: DateTime(0),
        owner: User.empty(),
      );

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"] ?? "",
        image: json["image"] ?? "",
        likes: json["likes"] ?? 0,
        tags: json["tags"] != null
            ? List<String>.from(json["tags"].map((x) => x))
            : [],
        text: json["text"] ?? "",
        publishDate: json["publishDate"] != null
            ? DateTime.parse(json["publishDate"])
            : DateTime(0),
        owner:
            json["owner"] != null ? User.fromJson(json["owner"]) : User.empty(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "likes": likes,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "text": text,
        "publishDate": publishDate.toIso8601String(),
        "owner": owner.toJson(),
      };
}
