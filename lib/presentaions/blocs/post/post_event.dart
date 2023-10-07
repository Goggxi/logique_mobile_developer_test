part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

final class PostFetch extends PostEvent {
  final int page;
  final int limit;

  PostFetch({required this.page, required this.limit});
}

final class PostFetchTag extends PostEvent {
  final String tag;
  final int page;
  final int limit;

  PostFetchTag({
    required this.tag,
    required this.page,
    required this.limit,
  });
}

final class PostFetchComment extends PostEvent {
  final String postId;
  final int page;
  final int limit;

  PostFetchComment({
    required this.postId,
    required this.page,
    required this.limit,
  });
}