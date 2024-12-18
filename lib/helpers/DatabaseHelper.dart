import 'package:password_manager/helpers/EncryptionHelper.dart';
import 'package:password_manager/models/Password.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  final encryptHelper = EncryptionHelper();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), 'password_manager.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            userId INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            full_name TEXT,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE passwords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            nama_akun TEXT,
            username TEXT,
            password TEXT,
            FOREIGN KEY(user_id) REFERENCES users(userId)
          )
        ''');
      },
    );
  }

  Future<int> registerUser(String username, String fullName, String password) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'full_name': fullName,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> checkUser(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Password>> getPasswords(int userId, String username) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('passwords', where: 'user_id = ?', whereArgs: [userId]);
    return List.generate(maps.length, (item) {
      Password data = Password.fromMap(maps[item]);
      data.password = encryptHelper.decrypt(username, data.password);
      return data;
    });
  }

  Future<int> addPassword(Password input) async {
    final db = await database;
    return await db.insert('passwords', input.toMap());
  }

  Future<void> updatePassword(Password input) async {
    final db = await database;
    await db.update(
      'passwords',
      input.toMap(),
      where: 'id = ?',
      whereArgs: [input.id],
    );
  }

  Future<void> deletePassword(int id) async {
    final db = await database;
    await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    final db = await database;
    final result = await db.query('users', where: 'userId = ?', whereArgs: [userId]);
    return result.isNotEmpty ? result.first : null;
  }
}