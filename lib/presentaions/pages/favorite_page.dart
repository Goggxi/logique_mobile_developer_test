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

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin {
  final _savedPostCubit = getIt<SavedPostsCubit>();
  String _tag = "";

  @override
  void initState() {
    _savedPostCubit.fetchSavedPosts();
    super.initState();
  }

  void _setTag(String tag) {
    _tag = tag;
    _savedPostCubit.filterByTag(tag);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SavedPostsCubit, SavedPostsState>(
      bloc: _savedPostCubit,
      builder: (_, state) {
        return Scaffold(
          appBar: AppBarPrimary(),
          body: Builder(
            builder: (_) {
              if (state.isLoading) {
                return const PostListLoadingWidget();
              }

              if (state.posts.isEmpty) {
                return const EmptyWidget(message: "no saved posts");
              }

              return CustomScrollView(
                slivers: [
                  if (_tag.isNotEmpty)
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      pinned: true,
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text('Tag : '),
                            Chip(
                              label: Text(
                                _tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.lightBlueAccent[100],
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                              onDeleted: () {
                                _savedPostCubit.fetchSavedPosts();
                                setState(() => _tag = "");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverList.separated(
                      itemBuilder: (_, i) {
                        final post = state.posts[i];
                        return PostItemWidget(
                          post: post,
                          isTagActive: true,
                          fetchTag: _setTag,
                          tag: _tag,
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
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
