import 'package:flutter/material.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({
    super.key,
    required this.post,
    required this.isPost,
    this.tag = "",
    this.fetchTag,
    this.onLike,
    this.isLiked = false,
  });

  final Post post;
  final bool isPost;
  final String tag;
  final void Function(String)? fetchTag;
  final void Function()? onLike;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
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
                      onTap: !isPost ? null : () => fetchTag!(e),
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
            GestureDetector(
              onTap: onLike,
              child: Row(
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 25,
                    color: isLiked ? Colors.red : null,
                  ),
                  const SizedBox(width: 5),
                  Text(post.likes.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
