part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserFetch extends UserEvent {
  final int page;
  final int limit;

  UserFetch({required this.page, required this.limit});
}

class UserFetchDetail extends UserEvent {
  final String userId;

  UserFetchDetail({required this.userId});
}

class UserFetchPost extends UserEvent {
  final String userId;
  final int page;
  final int limit;

  UserFetchPost({
    required this.userId,
    required this.page,
    required this.limit,
  });
}
