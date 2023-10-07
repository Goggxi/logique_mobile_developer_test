import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

abstract class PostRepository {
  Future<(Failure?, Meta<Post>)> posts({
    required String page,
    required String limit,
  });
  Future<(Failure?, Meta<Post>)> postTags({required String tag});
  Future<(Failure?, Meta<Comment>)> comments({
    required String postId,
    required String page,
    required String limit,
  });
}

@LazySingleton(as: PostRepository)
class PostRepositoryImpl extends PostRepository {
  final HttpClient _httpClient;

  PostRepositoryImpl(this._httpClient);

  @override
  Future<(Failure?, Meta<Comment>)> comments({
    required String postId,
    required String page,
    required String limit,
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
      return (null, Meta<Comment>.fromJson(jsonDecode(response.body)));
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), Meta<Comment>.empty());
    }
  }

  @override
  Future<(Failure?, Meta<Post>)> postTags({required String tag}) async {
    final response = await _httpClient.apiRequest(
      url: AppConstant.baseUrl,
      apiPath: AppConstant.postTagUrl.replaceAll(':tagId', tag),
      method: RequestMethod.get,
      headers: {'app-id': AppConstant.appId},
    );

    if (response.statusCode == 200) {
      return (null, Meta<Post>.fromJson(jsonDecode(response.body)));
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), Meta<Post>.empty());
    }
  }

  @override
  Future<(Failure?, Meta<Post>)> posts({
    required String page,
    required String limit,
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
      return (null, Meta<Post>.fromJson(jsonDecode(response.body)));
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), Meta<Post>.empty());
    }
  }
}
