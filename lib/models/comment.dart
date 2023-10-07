import 'models.dart';

class Comment {
  final String id;
  final String message;
  final User owner;
  final String post;
  final DateTime publishDate;

  Comment({
    required this.id,
    required this.message,
    required this.owner,
    required this.post,
    required this.publishDate,
  });

  factory Comment.empty() => Comment(
        id: "",
        message: "",
        owner: User.empty(),
        post: "",
        publishDate: DateTime(0),
      );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"] ?? "",
        message: json["message"] ?? "",
        owner:
            json["owner"] != null ? User.fromJson(json["owner"]) : User.empty(),
        post: json["post"],
        publishDate: json["publishDate"] != null
            ? DateTime.parse(json["publishDate"])
            : DateTime(0),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "owner": owner.toJson(),
        "post": post,
        "publishDate": publishDate.toIso8601String(),
      };
}
