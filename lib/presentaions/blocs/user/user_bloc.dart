import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/repositories/repository.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

part 'user_event.dart';
part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<UserFetch>(_fetchUser);
    on<UserFetchDetail>(_fetchUserDetail);
    on<UserFetchPost>(_fetchUserPost);
  }

  void _fetchUser(
    UserFetch event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _userRepository.users(
      page: event.page,
      limit: event.limit,
    );

    if (result.$1 != null) {
      emit(UserError(failure: result.$1!));
    } else {
      emit(UserLoaded(user: result.$2));
    }
  }

  void _fetchUserDetail(
    UserFetchDetail event,
    Emitter<UserState> emit,
  ) async {
    emit(UserDetailLoading());
    final result = await _userRepository.userDetail(userId: event.userId);

    if (result.$1 != null) {
      emit(UserDetailError(failure: result.$1!));
    } else {
      emit(UserDetailLoaded(userDetail: result.$2));
    }
  }

  void _fetchUserPost(
    UserFetchPost event,
    Emitter<UserState> emit,
  ) async {
    emit(UserPostLoading());
    final result = await _userRepository.userPosts(
      userId: event.userId,
      page: event.page,
      limit: event.limit,
    );

    if (result.$1 != null) {
      emit(UserPostError(failure: result.$1!));
    } else {
      emit(UserPostLoaded(userPosts: result.$2));
    }
  }
}
