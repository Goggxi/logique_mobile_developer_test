import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

abstract class PostRepository {
  Future<(Failure?, List<Post>)> posts({
    required int page,
    required int limit,
  });
  Future<(Failure?, List<Post>)> postTag({
    required String tag,
    required int page,
    required int limit,
  });
  Future<(Failure?, List<Comment>)> comments({
    required String postId,
    required int page,
    required int limit,
  });
}

@LazySingleton(as: PostRepository)
class PostRepositoryImpl extends PostRepository {
  final HttpClient _httpClient;

  PostRepositoryImpl(this._httpClient);

  @override
  Future<(Failure?, List<Comment>)> comments({
    required String postId,
    required int page,
    required int limit,
  }) async {
    final response = await _httpClient.apiRequest(
      url: AppConstant.baseUrl,
      apiPath: AppConstant.postCommentUrl.replaceAll(':postId', postId),
      method: RequestMethod.get,
      headers: {'app-id': AppConstant.appId},
      queryParameter: {
        'page': page,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      final meta = Meta.fromJson(jsonDecode(response.body));
      final comments =
          (meta.data as List).map((e) => Comment.fromJson(e)).toList();
      return (null, comments);
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), <Comment>[]);
    }
  }

  @override
  Future<(Failure?, List<Post>)> postTag({
    required String tag,
    required int page,
    required int limit,
  }) async {
    final response = await _httpClient.apiRequest(
      url: AppConstant.baseUrl,
      apiPath: AppConstant.postTagUrl.replaceAll(':tagId', tag),
      method: RequestMethod.get,
      headers: {'app-id': AppConstant.appId},
      queryParameter: {
        'page': page,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      final meta = Meta.fromJson(jsonDecode(response.body));
      final posts = (meta.data as List).map((e) => Post.fromJson(e)).toList();
      return (null, posts);
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), <Post>[]);
    }
  }

  @override
  Future<(Failure?, List<Post>)> posts({
    required int page,
    required int limit,
  }) async {
    final response = await _httpClient.apiRequest(
      url: AppConstant.baseUrl,
      apiPath: AppConstant.postUrl,
      method: RequestMethod.get,
      headers: {'app-id': AppConstant.appId},
      queryParameter: {
        'page': page,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      final meta = Meta.fromJson(jsonDecode(response.body));
      final posts = (meta.data as List).map((e) => Post.fromJson(e)).toList();
      return (null, posts);
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), <Post>[]);
    }
  }
}
