import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/repositories/repository.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

part 'saved_posts_state.dart';

@lazySingleton
class SavedPostsCubit extends Cubit<SavedPostsState> {
  final PostRepository _postRepository;

  SavedPostsCubit(this._postRepository) : super(SavedPostsState.initial());

  void fetchSavedPosts() async {
    emit(state.copyWith(isLoading: true));
    final result = await _postRepository.getSavedPosts();
    await Future.delayed(const Duration(milliseconds: 50));
    if (result.$1 != null) {
      emit(state.copyWith(
        isLoading: false,
        failure: result.$1,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        posts: result.$2,
      ));
    }
  }

  void savePost(Post post) async {
    final result = await _postRepository.savePost(post);
    if (result.$1 != null) {
      emit(state.copyWith(failure: result.$1));
    } else {
      final newPosts = state.posts..add(post);
      emit(state.copyWith(posts: newPosts));
    }
  }

  void unsavePost(Post post) async {
    final result = await _postRepository.deletePost(post);
    if (result.$1 != null) {
      emit(state.copyWith(failure: result.$1));
    } else {
      final newPosts = state.posts..removeWhere((e) => e.id == post.id);
      emit(state.copyWith(posts: newPosts));
    }
  }

  bool isSaved(Post post) {
    return state.posts.any((e) => e.id == post.id);
  }

  void filterByTag(String tag) {
    emit(state.copyWith(isLoading: true));
    _postRepository.getSavedPosts().then(
      (v) async {
        await Future.delayed(const Duration(milliseconds: 50));
        if (v.$1 != null) {
          emit(state.copyWith(
            isLoading: false,
            failure: v.$1,
          ));
        } else {
          final newPosts = v.$2.where((e) => e.tags.contains(tag)).toList();
          emit(state.copyWith(
            isLoading: false,
            posts: newPosts,
          ));
        }
      },
    );
  }
}
