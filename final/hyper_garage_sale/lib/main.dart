// lib/main.dart
import 'package:flutter/material.dart';

// your screens:
import 'BrowsePostsActivity.dart';
import 'NewPostActivity.dart';
import 'PostDetailActivity.dart';

// your model:
import 'models/post.dart';


void main() => runApp(const HyperGarageSaleApp());

class HyperGarageSaleApp extends StatelessWidget {
  const HyperGarageSaleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'HyperGarageSale',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: BrowsePostsActivity.routeName,
      routes: {
        BrowsePostsActivity.routeName: (_) => const BrowsePostsActivity(),
        NewPostActivity.routeName:    (_) => const NewPostActivity(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == PostDetailActivity.routeName) {
          final post = settings.arguments as Post;
          return MaterialPageRoute(
            builder: (_) => PostDetailActivity(post),
          );
        }
        return null;
      },
    );
  }
}


class HyperGarageSalePage extends StatefulWidget {
  const HyperGarageSalePage({Key? key}) : super(key: key);

  @override
  State<HyperGarageSalePage> createState() => _HyperGarageSalePageState();
}

class _HyperGarageSalePageState extends State<HyperGarageSalePage> {
  final _titleController       = TextEditingController();
  final _priceController       = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onPost() {
    final title       = _titleController.text.trim();
    final price       = _priceController.text.trim();
    final description = _descriptionController.text.trim();

    // 1) SHOW SNACKBAR
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title.isEmpty
              ? 'Please enter a title first.'
              : 'Posted: “$title” — \$$price',
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: hook up your real “post” logic here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HyperGarageSale'),
        actions: [
          // 2a) Direct icon button
          IconButton(
            icon: const Icon(Icons.post_add),
            tooltip: 'Post item',
            onPressed: _onPost,
          ),

          // 2b) Overflow menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'post') _onPost();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'post',
                child: Text('Post new item'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title of the item',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Price
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Enter price',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter description of the item',
                border: InputBorder.none,
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onPost,
        icon: const Icon(Icons.send),
        label: const Text('POST'),
      ),
    );
  }
}
