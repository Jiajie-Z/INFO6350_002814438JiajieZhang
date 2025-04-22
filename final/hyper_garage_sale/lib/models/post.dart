import 'dart:convert';

class Post {
  final int? id;
  final String title;
  final String price;
  final String description;
  final List<String> images;

  Post({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    this.images = const [],
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'images': jsonEncode(images),
  };

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int?,
      title: map['title'] as String,
      price: map['price'] as String,
      description: map['description'] as String,
      images: List<String>.from(
        jsonDecode(map['images'] as String) as List<dynamic>,
      ),
    );
  }

  Post copyWith({
    int? id,
    String? title,
    String? price,
    String? description,
    List<String>? images,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
    );
  }
}
