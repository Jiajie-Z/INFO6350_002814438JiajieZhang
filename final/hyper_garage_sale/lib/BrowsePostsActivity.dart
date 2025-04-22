// lib/BrowsePostsActivity.dart
import 'package:flutter/material.dart';
import 'PostDetailActivity.dart';
import '../models/post.dart';
import '../db/database_helper.dart';
import 'NewPostActivity.dart';

class BrowsePostsActivity extends StatefulWidget {
  const BrowsePostsActivity({Key? key}) : super(key: key);
  static const routeName = '/browse';

  @override
  State<BrowsePostsActivity> createState() => _BrowsePostsActivityState();
}

class _BrowsePostsActivityState extends State<BrowsePostsActivity> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _refreshPosts();
  }

  Future<void> _refreshPosts() async {
    final posts = await DatabaseHelper.instance.readAllPosts();
    setState(() => _posts = posts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Posts')),
      body: _posts.isEmpty
          ? const Center(child: Text('No posts yet.'))
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (ctx, i) {
          final p = _posts[i];
          return ListTile(
            title: Text(p.title),
            subtitle: Text('\$${p.price}'),
            onTap: () {
              Navigator.of(context).pushNamed(
                PostDetailActivity.routeName,
                arguments: p,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final didPost = await Navigator.of(context)
              .pushNamed(NewPostActivity.routeName);
          if (didPost == true) _refreshPosts();
        },
        child: const Icon(Icons.add),
        tooltip: 'New Post',
      ),
    );
  }
}
