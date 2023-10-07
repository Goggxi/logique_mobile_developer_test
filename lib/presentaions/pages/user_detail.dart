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
  UserDetail _user = UserDetail.empty();
  final List<Post> _posts = [];
  int _currentPage = 0;
  bool _hasMoreData = true;
  bool _fristLoad = true;

  void _fetchUser() {
    _userBloc.add(UserFetchDetail(userId: widget.user.id));
  }

  void _fetchPost() {
    _userBloc.add(UserFetchPost(
        userId: widget.user.id, page: _currentPage, limit: AppConstant.limit));
  }

  void _clear() {
    _user = UserDetail.empty();
    _posts.clear();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Detail"),
        centerTitle: true,
        elevation: 0,
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
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  _clear();
                  _fetchUser();
                  _fetchPost();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverToBoxAdapter(
                        child: _UserWidgetSection(user: _user),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(12),
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
                      fetchTag: (_) {},
                      isPost: false,
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
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.picture),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(user.title, textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            "${user.firstName} ${user.lastName}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            const SizedBox(height: 10),
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
