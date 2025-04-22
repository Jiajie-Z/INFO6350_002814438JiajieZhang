import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post.dart';
import '../db/database_helper.dart';

class NewPostActivity extends StatefulWidget {
  const NewPostActivity({Key? key}) : super(key: key);
  static const routeName = '/new';

  @override
  State<NewPostActivity> createState() => _NewPostActivityState();
}

class _NewPostActivityState extends State<NewPostActivity> {
  final _titleCtrl       = TextEditingController();
  final _priceCtrl       = TextEditingController();
  final _descCtrl        = TextEditingController();
  final _picker          = ImagePicker();
  List<String> _images    = [];

  Future<void> _pickImage() async {
    if (_images.length >= 4) return;
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() => _images.add(file.path));
    }
  }

  Future<void> _onPost() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    final newPost = Post(
      title: _titleCtrl.text.trim(),
      price: _priceCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      images: _images,
    );
    await DatabaseHelper.instance.create(newPost);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Posted "${newPost.title}"')));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // text fields...
            TextField(controller: _titleCtrl, decoration: const InputDecoration(hintText: 'Title')),
            const SizedBox(height: 8),
            TextField(controller: _priceCtrl, decoration: const InputDecoration(hintText: 'Price')),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(hintText: 'Description'),
              maxLines: 3,
            ),

            const SizedBox(height: 16),
            // Thumbnails + “Add Image” button
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var path in _images)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(File(path), width: 80, height: 80, fit: BoxFit.cover),
                    ),
                  if (_images.length < 4)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                ],
              ),
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
