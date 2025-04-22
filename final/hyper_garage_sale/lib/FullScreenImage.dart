import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage(this.imagePath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // back arrow by default
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
