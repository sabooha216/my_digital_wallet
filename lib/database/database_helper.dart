import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // تم تغيير اسم القاعدة إلى v5 لحل مشكلة التعليق في الحفظ
  static const _databaseName = "wallet_database_v5.db";
  static const _databaseVersion = 1;

  static const tableUsers = 'users';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnBalance = 'balance';
  static const columnFullName = 'full_name'; 
  static const columnDob = 'dob'; 
  static const columnPhone = 'phone'; 
  static const columnBirthPlaceDate = 'birth_place_date'; 
  static const columnCurrentLocation = 'current_location'; 

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

  // ==========================================
  // دوال التعديل والحذف
  // ==========================================
  Future<int> updateUserProfile(String username, String fullName, String dob, String phone, String birthPlace, String location) async {
    Database db = await instance.database;
    return await db.update(
      tableUsers,
      {
        columnFullName: fullName,
        columnDob: dob,
        columnPhone: phone,
        columnBirthPlaceDate: birthPlace,
        columnCurrentLocation: location,
      },
      where: '$columnName = ?',
      whereArgs: [username],
    );
  }

  Future<int> deleteUser(String username) async {
    Database db = await instance.database;
    await db.delete(tableTransactions, where: '$transUsername = ?', whereArgs: [username]);
    return await db.delete(tableUsers, where: '$columnName = ?', whereArgs: [username]);
  }
}