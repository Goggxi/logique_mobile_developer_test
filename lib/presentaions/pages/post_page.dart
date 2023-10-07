import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logique_mobile_developer_test/di/di.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/presentaions/blocs/blocs.dart';
import 'package:logique_mobile_developer_test/presentaions/widgets/widgets.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with AutomaticKeepAliveClientMixin {
  final _postBloc = getIt<PostBloc>();
  final _scrollController = ScrollController();
  final List<Post> _posts = [];
  int _currentPage = 0;
  bool _hasMoreData = true;
  bool _fristLoad = true;
  String _tag = "";

  void _fetchData() {
    _postBloc.add(PostFetch(page: _currentPage, limit: AppConstant.limit));
  }

  void _fetchTag(String tag) {
    _resetData();
    setState(() {
      _tag = tag;
    });
    _postBloc.add(
      PostFetchTag(tag: tag, page: _currentPage, limit: AppConstant.limit),
    );
  }

  void _resetData() {
    setState(() {
      _currentPage = 0;
      _posts.clear();
      _fristLoad = true;
      _hasMoreData = true;
    });
  }

  @override
  void initState() {
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchData();
      }
    });
    super.initState();
  }

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBarPrimary(),
      body: BlocListener<PostBloc, PostState>(
        bloc: _postBloc,
        listener: (_, state) {
          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );

            if (_fristLoad) {
              setState(() => _fristLoad = false);
            }

            if (_hasMoreData) {
              setState(() => _hasMoreData = false);
            }
          } else if (state is PostLoaded) {
            final listState = state.posts;
            if (listState.isNotEmpty) {
              setState(() {
                _posts.addAll(listState);
                _currentPage++;
              });
            }

            if (listState.length < AppConstant.limit) {
              setState(() => _hasMoreData = false);
            }

            if (_fristLoad) {
              setState(() => _fristLoad = false);
            }
          } else if (state is PostTagLoaded) {
            final listState = state.posts;
            if (listState.isNotEmpty) {
              setState(() {
                _posts.addAll(listState);
                _currentPage++;
              });
            }

            if (listState.length < AppConstant.limit) {
              setState(() => _hasMoreData = false);
            }

            if (_fristLoad) {
              setState(() => _fristLoad = false);
            }
          } else if (state is PostTagError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );

            if (_fristLoad) {
              setState(() => _fristLoad = false);
            }

            if (_hasMoreData) {
              setState(() => _hasMoreData = false);
            }
          }
        },
        child: _posts.isEmpty && !_hasMoreData
            ? const SizedBox(child: Center(child: Text('no posts')))
            : _fristLoad
                // TODO: Add shimmer loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      _resetData();
                      if (_tag.isNotEmpty) {
                        _fetchTag(_tag);
                        return;
                      }
                      _fetchData();
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
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
                                    backgroundColor:
                                        Colors.lightBlueAccent[100],
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    onDeleted: () {
                                      setState(() => _tag = "");
                                      _resetData();
                                      _fetchData();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        PostListWidget(
                          scrollController: _scrollController,
                          posts: _posts,
                          hasMoreData: _hasMoreData,
                          tag: _tag,
                          fetchTag: _fetchTag,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
