part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final List<User> user;

  UserLoaded({required this.user});
}

final class UserError extends UserState {
  final Failure failure;

  UserError({required this.failure});
}

final class UserDetailLoading extends UserState {}

final class UserDetailLoaded extends UserState {
  final UserDetail userDetail;

  UserDetailLoaded({required this.userDetail});
}

final class UserDetailError extends UserState {
  final Failure failure;

  UserDetailError({required this.failure});
}

final class UserPostLoading extends UserState {}

final class UserPostLoaded extends UserState {
  final List<Post> userPosts;

  UserPostLoaded({required this.userPosts});
}

final class UserPostError extends UserState {
  final Failure failure;

  UserPostError({required this.failure});
}
