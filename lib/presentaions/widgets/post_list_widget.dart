import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logique_mobile_developer_test/di/di.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/presentaions/cubits/cubits.dart';

import 'widgets.dart';

class PostListWidget extends StatelessWidget {
  const PostListWidget({
    super.key,
    required this.scrollController,
    required this.posts,
    required this.hasMoreData,
    required this.fetchTag,
    this.tag = "",
    this.isPost = true,
  });

  final ScrollController scrollController;
  final List<Post> posts;
  final bool hasMoreData;
  final void Function(String) fetchTag;
  final String tag;
  final bool isPost;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (posts.isEmpty && hasMoreData) {
            return const SizedBox(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (index == posts.length && hasMoreData) {
            return const Center(child: CircularProgressIndicator());
          } else if (index == posts.length && !hasMoreData) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text("data sudah ditampilkan semua"),
                SizedBox(height: 10),
              ],
            );
          }

          final post = posts[index];
          return BlocBuilder<SavedPostsCubit, SavedPostsState>(
            bloc: getIt<SavedPostsCubit>(),
            builder: (_, state) {
              return PostItemWidget(
                post: post,
                isPost: isPost,
                tag: tag,
                fetchTag: fetchTag,
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
          );
        },
        itemCount: posts.length + 1,
      ),
    );
  }
}
