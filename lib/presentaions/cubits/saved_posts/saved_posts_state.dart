part of 'saved_posts_cubit.dart';

@immutable
class SavedPostsState {
  const SavedPostsState({
    required this.posts,
    required this.isLoading,
    required this.failure,
  });

  final List<Post> posts;
  final bool isLoading;
  final Failure? failure;

  factory SavedPostsState.initial() {
    return const SavedPostsState(
      posts: [],
      isLoading: false,
      failure: null,
    );
  }

  SavedPostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    Failure? failure,
  }) {
    return SavedPostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }
}
