import 'package:flutter/material.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/utils/extension.dart';

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
          return Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(post.owner.picture),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${post.owner.firstName} ${post.owner.lastName}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              post.publishDate.toDDMMMYYYYHH(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Image.network(post.image, width: double.infinity),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    children: post.tags
                        .map(
                          (e) => InkWell(
                            onTap: !isPost
                                ? null
                                : () {
                                    fetchTag(e);
                                  },
                            child: Chip(
                              label: Text(e),
                              labelStyle: tag == e
                                  ? const TextStyle(color: Colors.white)
                                  : null,
                              backgroundColor: tag == e ? Colors.blue : null,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.text,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 25),
                      const SizedBox(width: 5),
                      Text(post.likes.toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: posts.length + 1,
      ),
    );
  }
}
