import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // اسم قاعدة البيانات وإصدارها
  static const _databaseName = "wallet_database.db";
  static const _databaseVersion = 1;

  // اسم الجدول وأعمدته (كمثال لمحفظة رقمية)
  static const table = 'users';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnBalance = 'balance';

  // جعل الكلاس Singleton عشان نستخدم نفس الاتصال في كل التطبيق
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // دالة للتحقق: هل قاعدة البيانات موجودة؟ إذا لا، أنشئها.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // تهيئة قاعدة البيانات وإنشائها في مسار ملفات الجوال
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion, 
      onCreate: _onCreate,
    );
  }

  // كود إنشاء الجداول
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnBalance REAL NOT NULL
          )
          ''');
  }

  // ---------------- الدوال الخاصة بالعمليات (CRUD) ----------------

  // 1. دالة لإضافة مستخدم جديد (ترجع رقم الـ id للمستخدم الجديد)
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // 2. دالة لجلب بيانات كل المستخدمين (ترجع قائمة بالبيانات)
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // 3. دالة للبحث عن مستخدم بالاسم (مفيدة للتحقق وقت تسجيل الدخول)
  Future<Map<String, dynamic>?> getUserByName(String name) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnName = ?',
      whereArgs: [name],
    );
    
    if (result.isNotEmpty) {
      return result.first; // إذا وجد المستخدم، يرجع بياناته
    }
    return null; // إذا لم يجده، يرجع null
  }

  // 4. دالة لتحديث الرصيد (عند تحويل الأموال أو الإيداع)
  Future<int> updateBalance(int id, double newBalance) async {
    Database db = await instance.database;
    return await db.update(
      table,
      {columnBalance: newBalance},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}