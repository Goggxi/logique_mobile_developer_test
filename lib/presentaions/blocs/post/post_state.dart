part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded({required this.posts});
}

final class PostError extends PostState {
  final Failure failure;

  PostError({required this.failure});
}

final class PostTagLoading extends PostState {}

final class PostTagLoaded extends PostState {
  final List<Post> posts;

  PostTagLoaded({required this.posts});
}

final class PostTagError extends PostState {
  final Failure failure;

  PostTagError({required this.failure});
}

final class PostCommentLoading extends PostState {}

final class PostCommentLoaded extends PostState {
  final List<Comment> postComments;

  PostCommentLoaded({required this.postComments});
}

final class PostCommentError extends PostState {
  final Failure failure;

  PostCommentError({required this.failure});
}
