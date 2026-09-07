import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // تحديث إلى v4 لاعتماد البيانات الشخصية الجديدة
  static const _databaseName = "wallet_database_v4.db";
  static const _databaseVersion = 1;

  // 1. جدول المستخدمين (بالحقول الجديدة)
  static const tableUsers = 'users';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnBalance = 'balance';
  static const columnFullName = 'full_name'; // الاسم الرباعي
  static const columnDob = 'dob'; // تاريخ الميلاد
  static const columnPhone = 'phone'; // رقم الجوال
  static const columnBirthPlaceDate = 'birth_place_date'; // مكان وتاريخ الميلاد
  static const columnCurrentLocation = 'current_location'; // الموقع الحالي

  // 2. جدول العمليات
  static const tableTransactions = 'transactions';
  static const transId = 'id';
  static const transUsername = 'username'; 
  static const transTitle = 'title'; 
  static const transAmount = 'amount'; 
  static const transDate = 'date'; 
  static const transType = 'type'; 

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion, 
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUsers (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnBalance REAL NOT NULL,
            $columnFullName TEXT,
            $columnDob TEXT,
            $columnPhone TEXT,
            $columnBirthPlaceDate TEXT,
            $columnCurrentLocation TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableTransactions (
            $transId INTEGER PRIMARY KEY AUTOINCREMENT,
            $transUsername TEXT NOT NULL,
            $transTitle TEXT NOT NULL,
            $transAmount REAL NOT NULL,
            $transDate TEXT NOT NULL,
            $transType TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, row);
  }

  Future<Map<String, dynamic>?> getUserByName(String name) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(tableUsers, where: '$columnName = ?', whereArgs: [name]);
    if (result.isNotEmpty) return result.first; 
    return null; 
  }

  Future<int> updateBalance(String name, double newBalance) async {
    Database db = await instance.database;
    return await db.update(tableUsers, {columnBalance: newBalance}, where: '$columnName = ?', whereArgs: [name]);
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTransactions, row);
  }

  Future<List<Map<String, dynamic>>> getTransactionsByUser(String username) async {
    Database db = await instance.database;
    return await db.query(tableTransactions, where: '$transUsername = ?', whereArgs: [username], orderBy: '$transId DESC');
  }
}