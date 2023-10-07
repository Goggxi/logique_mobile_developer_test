part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  final List<Post> post;

  PostLoaded({required this.post});
}

final class PostError extends PostState {
  final Failure failure;

  PostError({required this.failure});
}

final class PostTagLoading extends PostState {}

final class PostTagLoaded extends PostState {
  final List<Post> postTag;

  PostTagLoaded({required this.postTag});
}

final class PostTagError extends PostState {
  final Failure failure;

  PostTagError({required this.failure});
}

final class PostCommentLoading extends PostState {}

final class PostCommentLoaded extends PostState {
  final List<Comment> postComment;

  PostCommentLoaded({required this.postComment});
}

final class PostCommentError extends PostState {
  final Failure failure;

  PostCommentError({required this.failure});
}
