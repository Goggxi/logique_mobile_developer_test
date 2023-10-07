import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logique_mobile_developer_test/di/di.dart';
import 'package:logique_mobile_developer_test/presentaions/cubits/cubits.dart';
import 'package:logique_mobile_developer_test/presentaions/widgets/widgets.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _savedPostCubit = getIt<SavedPostsCubit>();

  @override
  void initState() {
    _savedPostCubit.fetchSavedPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPostsCubit, SavedPostsState>(
      bloc: _savedPostCubit,
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Favorite"),
            centerTitle: true,
            elevation: 0,
          ),
          body: state.posts.isEmpty
              ? const Center(child: Text("Belum ada data"))
              : state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (_, i) {
                        final post = state.posts[i];
                        return PostItemWidget(
                          post: post,
                          isPost: false,
                          fetchTag: (_) {},
                          isLiked: state.posts.any((e) => e.id == post.id),
                          onLike: () {
                            if (state.posts.any((e) => e.id == post.id)) {
                              getIt<SavedPostsCubit>().unsavePost(post);
                            } else {
                              getIt<SavedPostsCubit>().savePost(post);
                            }
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: state.posts.length,
                    ),
        );
      },
    );
  }
}
