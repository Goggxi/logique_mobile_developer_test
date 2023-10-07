import 'package:flutter/material.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/presentaions/widgets/widgets.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({
    super.key,
    required this.post,
    required this.isTagActive,
    this.tag = "",
    this.fetchTag,
    this.onLike,
    this.isLiked = false,
  });

  final Post post;
  final bool isTagActive;
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
                AppImage(
                  url: post.owner.picture,
                  radius: 100,
                  width: 50,
                  height: 50,
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
            AppImage(
              url: post.image,
              heightLoading: 200,
              width: double.infinity,
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 10,
              children: post.tags
                  .map(
                    (e) => InkWell(
                      onTap: !isTagActive ? null : () => fetchTag!(e),
                      child: Chip(
                        label: Text(
                          e,
                          style: tag == e
                              ? const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )
                              : null,
                        ),
                        backgroundColor:
                            tag == e ? Colors.lightBlueAccent[100] : null,
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
                    size: 32,
                    color: isLiked ? Colors.red : null,
                  ),
                  const SizedBox(width: 5),
                  Text((post.likes + (isLiked ? 1 : 0)).toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
