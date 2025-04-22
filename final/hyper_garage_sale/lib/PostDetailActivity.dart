import 'dart:io';
import 'package:flutter/material.dart';

import 'models/post.dart';
import 'FullScreenImage.dart';

class PostDetailActivity extends StatelessWidget {
  final Post post;
  const PostDetailActivity(this.post, {Key? key}) : super(key: key);

  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Use Material 3 style `titleLarge` instead of the removed `headline6`
          Text('\$${post.price}', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(post.description),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.images.map((path) {
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FullScreenImage(path),
                  ),
                ),
                child: Image.file(
                  File(path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
