import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logique_mobile_developer_test/di/di.dart';
import 'package:logique_mobile_developer_test/models/models.dart';
import 'package:logique_mobile_developer_test/presentaions/blocs/blocs.dart';
import 'package:logique_mobile_developer_test/presentaions/pages/user_detail.dart';
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
      appBar: AppBar(
        title: const Text("User"),
        centerTitle: true,
        elevation: 0,
      ),
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
        child: _users.isEmpty && !_hasMoreData
            ? const SizedBox(child: Center(child: Text('Belum ada data')))
            : _fristLoad
                // TODO: Add shimmer loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
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
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          if (users.isEmpty && hasMoreData) {
            return const SizedBox(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (index == users.length && hasMoreData) {
            return const Center(child: CircularProgressIndicator());
          } else if (index == users.length && !hasMoreData) {
            return const Card(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, size: 40),
                  SizedBox(height: 10),
                  Text("data sudah habis"),
                ],
              ),
            );
          }

          final user = users[index];
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.picture),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(user.title, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${user.firstName} ${user.lastName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: users.length + 1,
      ),
    );
  }
}
