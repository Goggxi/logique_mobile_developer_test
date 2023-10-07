import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

abstract class UserRepository {
  Future<(Failure?, Meta<User>)> users({
    required String page,
    required String limit,
  });
  Future<(Failure?, UserDetail)> userDetail({
    required String userId,
  });
  Future<(Failure?, Meta<Post>)> userPosts({
    required String userId,
    required String page,
    required String limit,
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
  Future<(Failure?, Meta<Post>)> userPosts({
    required String userId,
    required String page,
    required String limit,
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
      return (null, Meta<Post>.fromJson(jsonDecode(response.body)));
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), Meta<Post>.empty());
    }
  }

  @override
  Future<(Failure?, Meta<User>)> users({
    required String page,
    required String limit,
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
      return (null, Meta<User>.fromJson(jsonDecode(response.body)));
    } else {
      final message = jsonDecode(response.body)['error'];
      final statusCode = response.statusCode;
      return (ServerFailure(message, code: statusCode), Meta<User>.empty());
    }
  }
}
