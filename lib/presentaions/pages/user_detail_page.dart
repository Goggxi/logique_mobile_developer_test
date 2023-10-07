import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logique_mobile_developer_test/di/di.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/presentaions/blocs/blocs.dart';
import 'package:logique_mobile_developer_test/presentaions/widgets/widgets.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key, required this.user});

  final User user;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _userBloc = getIt<UserBloc>();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final List<Post> _posts = [];
  final List<Post> _postsTemp = [];
  UserDetail _user = UserDetail.empty();
  int _currentPage = 0;
  bool _hasMoreData = true;
  bool _fristLoad = true;
  String _tag = "";

  void _fetchUser() {
    _userBloc.add(UserFetchDetail(userId: widget.user.id));
  }

  void _fetchPost() {
    _userBloc.add(
      UserFetchPost(
        userId: widget.user.id,
        page: _currentPage,
        limit: AppConstant.limit,
      ),
    );
  }

  void _setTag(String tag) {
    _resetSearch();
    _tag = tag;
    _posts.clear();
    _posts.addAll(_postsTemp);
    final filter = _posts.where((e) => e.tags.contains(tag)).toList();
    _posts.clear();
    _posts.addAll(filter);
    setState(() {});
  }

  void _setSearch(String search) {
    _resetTag();
    _posts.clear();
    _posts.addAll(_postsTemp);
    final filter = _posts.where((e) => e.text.contains(search)).toList();
    _posts.clear();
    _posts.addAll(filter);
    setState(() {});
  }

  void _resetSearch() {
    _searchController.clear();
    _posts.clear();
    _posts.addAll(_postsTemp);
    setState(() {});
  }

  void _resetTag() {
    _tag = "";
    _posts.clear();
    _posts.addAll(_postsTemp);
    setState(() {});
  }

  void _clear() {
    _user = UserDetail.empty();
    _posts.clear();
    _postsTemp.clear();
    _currentPage = 0;
    _hasMoreData = true;
    _fristLoad = true;
    setState(() {});
  }

  @override
  void initState() {
    _fetchUser();
    _fetchPost();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchPost();
      }
    });
    super.initState();
  }

  @override
  dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 64,
        title: Visibility(
          visible: !_fristLoad,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 12),
            height: 48,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                isDense: true,
                hintText: "Search post by description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _setSearch(value);
                } else {
                  _resetSearch();
                }
              },
            ),
          ),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (_, state) {
          if (state is UserDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UserDetailLoaded) {
            _user = state.userDetail;
            setState(() {});
          } else if (state is UserPostLoaded) {
            final listState = state.userPosts;

            if (listState.isNotEmpty) {
              setState(() {
                _posts.addAll(listState);
                _postsTemp.addAll(listState);
                _currentPage++;
              });
            }

            if (listState.length < AppConstant.limit) {
              setState(() => _hasMoreData = false);
            }

            if (_fristLoad) {
              _fristLoad = false;
              setState(() {});
            }
          } else if (state is UserPostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
            _fristLoad = false;
            _hasMoreData = false;
            setState(() {});
          }
        },
        child: _fristLoad
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const CircularProgressIndicator(),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  _clear();
                  _resetTag();
                  _resetSearch();
                  _fetchUser();
                  _fetchPost();
                },
                child: CustomScrollView(
                  slivers: [
                    if (_tag.isNotEmpty)
                      SliverAppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        pinned: true,
                        automaticallyImplyLeading: false,
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
                                onDeleted: () => _resetTag(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverToBoxAdapter(
                        child: _UserWidgetSection(user: _user),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Post",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    PostListWidget(
                      scrollController: _scrollController,
                      posts: _posts,
                      hasMoreData: _hasMoreData,
                      isTagActive: true,
                      fetchTag: _setTag,
                      tag: _tag,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _UserWidgetSection extends StatelessWidget {
  const _UserWidgetSection({required this.user});

  final UserDetail user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppImage(
              url: user.picture,
              radius: 100,
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent[100],
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      user.title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _textRich("Date Of Birth", user.dateOfBirth.toDDMMMYYYY()),
            const SizedBox(height: 8),
            _textRich("Join From", user.registerDate.toDDMMMYYYY()),
            const SizedBox(height: 8),
            _textRich("Email", user.email),
            const SizedBox(height: 8),
            _textRich(
              "Address",
              "${user.location.street} ${user.location.city} ${user.location.state} ${user.location.country}",
            ),
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  Widget _textRich(String title, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
