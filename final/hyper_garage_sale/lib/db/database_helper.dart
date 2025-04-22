import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/post.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path   = join(dbPath, 'posts.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE posts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          price TEXT NOT NULL,
          description TEXT NOT NULL,
          images TEXT NOT NULL
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Only attempt once—and ignore “duplicate column” errors
          try {
            await db.execute(
                'ALTER TABLE posts ADD COLUMN images TEXT NOT NULL DEFAULT \'[]\''
            );
          } catch (e) {
            // If it’s “duplicate column” we can safely ignore it
            print('Migration to v2 failed (column exists?): $e');
          }
        }
      },
    );
    return _db!;
  }

  Future<Post> create(Post post) async {
    final db = await database;
    final id = await db.insert('posts', post.toMap());
    return post.copyWith(id: id);
  }

  Future<List<Post>> readAllPosts() async {
    final db     = await database;
    final result = await db.query('posts', orderBy: 'id DESC');
    return result.map((m) => Post.fromMap(m)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
