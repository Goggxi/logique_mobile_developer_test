class AppConstant {
  static const String appId = "6520dc35d61b8ea4a4606365";
  static const String baseUrl = "https://dummyapi.io/data/v1";

  static const String postUrl = "/post";
  static const String postCommentUrl = "/post/:postId/comment";
  static const String postTagUrl = "/tag/:tagId/post";
  static const String userUrl = "/user";
  static const String userDetailUrl = "/user/:userId";
  static const String userPostUrl = "/user/:userId/post";

  static const int limit = 20;

  static const String assetPath = "assets/images";
  static const String imageLogo = "$assetPath/logo.png";

  static const String animsPath = "assets/anims";
  static const String animLike = "$animsPath/like.json";
}
