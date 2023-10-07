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
    this.isTagActive = true,
  });

  final ScrollController scrollController;
  final List<Post> posts;
  final bool hasMoreData;
  final void Function(String) fetchTag;
  final String tag;
  final bool isTagActive;

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
                Text("No more data"),
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
                isTagActive: isTagActive,
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

class PostListLoadingWidget extends StatelessWidget {
  const PostListLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              return Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ShimmerWidget(
                            width: 50,
                            height: 50,
                            radius: 100,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerWidget(
                                  width: size.width * 0.7,
                                  height: 20,
                                ),
                                const SizedBox(height: 5),
                                ShimmerWidget(
                                  width: size.width * 0.5,
                                  height: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const ShimmerWidget(
                        width: double.infinity,
                        radius: 10,
                        height: 200,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 10,
                        children: [
                          ShimmerWidget(
                            width: size.width * 0.2,
                            height: 30,
                            radius: 10,
                          ),
                          ShimmerWidget(
                            width: size.width * 0.2,
                            height: 30,
                            radius: 10,
                          ),
                          ShimmerWidget(
                            width: size.width * 0.2,
                            height: 30,
                            radius: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const ShimmerWidget(
                        width: double.infinity,
                        height: 20,
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          ShimmerWidget(
                            width: 32,
                            height: 32,
                          ),
                          SizedBox(width: 5),
                          ShimmerWidget(
                            width: 32,
                            height: 32,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
