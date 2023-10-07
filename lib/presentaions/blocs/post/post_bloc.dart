import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/repositories/repository.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

part 'post_event.dart';
part 'post_state.dart';

@injectable
class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc(this._postRepository) : super(PostInitial()) {
    on<PostFetch>(_fetchPost);
    on<PostFetchTag>(_fetchPostTag);
    on<PostFetchComment>(_fetchPostComment);
  }

  void _fetchPost(
    PostFetch event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    final result = await _postRepository.posts(
      page: event.page,
      limit: event.limit,
    );

    if (result.$1 != null) {
      emit(PostError(failure: result.$1!));
    } else {
      emit(PostLoaded(post: result.$2));
    }
  }

  void _fetchPostTag(
    PostFetchTag event,
    Emitter<PostState> emit,
  ) async {
    emit(PostTagLoading());
    final result = await _postRepository.postTag(
      tag: event.tag,
      page: event.page,
      limit: event.limit,
    );

    if (result.$1 != null) {
      emit(PostTagError(failure: result.$1!));
    } else {
      emit(PostTagLoaded(postTag: result.$2));
    }
  }

  void _fetchPostComment(
    PostFetchComment event,
    Emitter<PostState> emit,
  ) async {
    emit(PostCommentLoading());
    final result = await _postRepository.comments(
      postId: event.postId,
      page: event.page,
      limit: event.limit,
    );

    if (result.$1 != null) {
      emit(PostCommentError(failure: result.$1!));
    } else {
      emit(PostCommentLoaded(postComment: result.$2));
    }
  }
}
