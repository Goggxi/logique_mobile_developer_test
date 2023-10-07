import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logique_mobile_developer_test/di/di.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/presentaions/blocs/blocs.dart';
import 'package:logique_mobile_developer_test/presentaions/pages/user_detail_page.dart';
import 'package:logique_mobile_developer_test/presentaions/widgets/widgets.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin {
  final _userBloc = getIt<UserBloc>();
  final _scrollController = ScrollController();
  final List<User> _users = [];
  int _currentPage = 0;
  bool _hasMoreData = true;
  bool _fristLoad = true;

  void _fetchData() {
    _userBloc.add(UserFetch(page: _currentPage, limit: AppConstant.limit));
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
      body: BlocListener<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (_, state) {
          if (state is UserError) {
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
          } else if (state is UserLoaded) {
            final listState = state.user;
            if (listState.isNotEmpty) {
              setState(() {
                _users.addAll(listState);
                _currentPage++;
              });
            }

            if (listState.length < AppConstant.limit) {
              setState(() => _hasMoreData = false);
            }

            if (_fristLoad) {
              setState(() => _fristLoad = false);
            }
          }
        },
        child: Builder(
          builder: (_) {
            if (_fristLoad) {
              return const _BuildLoadingUser();
            }

            if (_users.isEmpty && !_hasMoreData) {
              return const EmptyWidget(message: "no users");
            }

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _currentPage = 0;
                  _users.clear();
                  _fristLoad = true;
                  _hasMoreData = true;
                });
                _fetchData();
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _BuildListUser(
                    scrollController: _scrollController,
                    users: _users,
                    hasMoreData: _hasMoreData,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _BuildListUser extends StatelessWidget {
  const _BuildListUser({
    required this.scrollController,
    required this.users,
    required this.hasMoreData,
  });

  final ScrollController scrollController;
  final List<User> users;
  final bool hasMoreData;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 286,
        ),
        itemBuilder: (context, index) {
          if (index == users.length && hasMoreData) {
            return Material(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            );
          } else if (index == users.length && !hasMoreData) {
            return Card(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 40,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "no more data",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final user = users[index];
          return _BuildUserItem(user: user);
        },
        itemCount: users.length + 1,
      ),
    );
  }
}

class _BuildUserItem extends StatelessWidget {
  const _BuildUserItem({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserDetailPage(user: user)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              url: user.picture,
              radius: 16,
              width: double.infinity,
              height: 180,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                  const SizedBox(height: 6),
                  Text(
                    "${user.firstName} ${user.lastName}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildLoadingUser extends StatelessWidget {
  const _BuildLoadingUser();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 286,
            ),
            itemBuilder: (_, index) {
              return const Card(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      width: double.infinity,
                      height: 180,
                      radius: 16,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(
                            width: 50,
                            height: 20,
                            radius: 100,
                          ),
                          SizedBox(height: 6),
                          ShimmerWidget(
                            width: double.infinity,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
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
