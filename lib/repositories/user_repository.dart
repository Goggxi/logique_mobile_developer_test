import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

abstract class UserRepository {
  Future<(Failure?, List<User>)> users({
    required int page,
    required int limit,
  });
  Future<(Failure?, UserDetail)> userDetail({
    required String userId,
  });
  Future<(Failure?, List<Post>)> userPosts({
    required String userId,
    required int page,
    required int limit,
  });
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final HttpClient _httpClient;

  UserRepositoryImpl(this._httpClient);

  @override
  Future<(Failure?, UserDetail)> userDetail({required String userId}) async {
    final response = await _httpClient.apiRequest(
      url: AppConstant.baseUrl,
      apiPath: AppConstant.userDetailUrl.replaceAll(':userId', userId),
      method: RequestMethod.get,
      headers: {'app-id': AppConstant.appId},
    );

    if (response.statusCode == 200) {
      return (null, UserDetail.fromJson(jsonDecode(response.body)));
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), UserDetail.empty());
    }
  }

  @override
  Future<(Failure?, List<Post>)> userPosts({
    required String userId,
    required int page,
    required int limit,
  }) async {
    final response = await _httpClient.apiRequest(
      url: AppConstant.baseUrl,
      apiPath: AppConstant.userPostUrl.replaceAll(':userId', userId),
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
  Future<(Failure?, List<User>)> users({
    required int page,
    required int limit,
  }) async {
    final response = await _httpClient.apiRequest(
      url: AppConstant.baseUrl,
      apiPath: AppConstant.userUrl,
      method: RequestMethod.get,
      headers: {'app-id': AppConstant.appId},
      queryParameter: {
        'page': page,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      final meta = Meta.fromJson(jsonDecode(response.body));
      final users = (meta.data as List).map((e) => User.fromJson(e)).toList();
      return (null, users);
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), <User>[]);
    }
  }
}
