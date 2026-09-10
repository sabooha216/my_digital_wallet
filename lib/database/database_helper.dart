import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "wallet_database_v5.db";

  // تم رفع الإصدار من 2 إلى 3 لإضافة أهداف الادخار
  static const _databaseVersion = 3;

  // ==========================================
  // جدول المستخدمين
  // ==========================================
  static const tableUsers = 'users';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnBalance = 'balance';
  static const columnFullName = 'full_name';
  static const columnDob = 'dob';
  static const columnPhone = 'phone';
  static const columnBirthPlaceDate = 'birth_place_date';
  static const columnCurrentLocation = 'current_location';

  // ==========================================
  // جدول العمليات
  // ==========================================
  static const tableTransactions = 'transactions';
  static const transId = 'id';
  static const transUsername = 'username';
  static const transTitle = 'title';
  static const transAmount = 'amount';
  static const transDate = 'date';
  static const transType = 'type';

  // ==========================================
  // جدول الإشعارات
  // ==========================================
  static const tableNotifications = 'notifications';
  static const notificationId = 'id';
  static const notificationUsername = 'username';
  static const notificationTitle = 'title';
  static const notificationMessage = 'message';
  static const notificationDate = 'date';
  static const notificationIsRead = 'is_read';

  // ==========================================
  // جدول أهداف الادخار 🎯
  // ==========================================
  static const tableSavingsGoals = 'savings_goals';
  static const goalId = 'id';
  static const goalUsername = 'username';
  static const goalName = 'name';
  static const goalTargetAmount = 'target_amount';
  static const goalSavedAmount = 'saved_amount';
  static const goalDate = 'date';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  static Database? _database;

  // ==========================================
  // الحصول على قاعدة البيانات
  // ==========================================
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  // ==========================================
  // إنشاء قاعدة البيانات
  // ==========================================
  Future<Database> _initDatabase() async {
    Directory documentsDirectory =
        await getApplicationDocumentsDirectory();

    String path = join(
      documentsDirectory.path,
      _databaseName,
    );

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ==========================================
  // إنشاء الجداول لأول مرة
  // ==========================================
  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // جدول المستخدمين
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

    // جدول العمليات
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

    // جدول الإشعارات
    await db.execute('''
      CREATE TABLE $tableNotifications (
        $notificationId INTEGER PRIMARY KEY AUTOINCREMENT,
        $notificationUsername TEXT NOT NULL,
        $notificationTitle TEXT NOT NULL,
        $notificationMessage TEXT NOT NULL,
        $notificationDate TEXT NOT NULL,
        $notificationIsRead INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // جدول أهداف الادخار 🎯
    await db.execute('''
      CREATE TABLE $tableSavingsGoals (
        $goalId INTEGER PRIMARY KEY AUTOINCREMENT,
        $goalUsername TEXT NOT NULL,
        $goalName TEXT NOT NULL,
        $goalTargetAmount REAL NOT NULL,
        $goalSavedAmount REAL NOT NULL DEFAULT 0,
        $goalDate TEXT NOT NULL
      )
    ''');
  }

  // ==========================================
  // تحديث قاعدة البيانات بدون حذف البيانات
  // ==========================================
  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // الإصدار 2: إضافة الإشعارات
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $tableNotifications (
          $notificationId INTEGER PRIMARY KEY AUTOINCREMENT,
          $notificationUsername TEXT NOT NULL,
          $notificationTitle TEXT NOT NULL,
          $notificationMessage TEXT NOT NULL,
          $notificationDate TEXT NOT NULL,
          $notificationIsRead INTEGER NOT NULL DEFAULT 0
        )
      ''');
    }

    // الإصدار 3: إضافة أهداف الادخار
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE $tableSavingsGoals (
          $goalId INTEGER PRIMARY KEY AUTOINCREMENT,
          $goalUsername TEXT NOT NULL,
          $goalName TEXT NOT NULL,
          $goalTargetAmount REAL NOT NULL,
          $goalSavedAmount REAL NOT NULL DEFAULT 0,
          $goalDate TEXT NOT NULL
        )
      ''');
    }
  }

  // ==========================================
  // المستخدمين
  // ==========================================
  Future<int> insertUser(
    Map<String, dynamic> row,
  ) async {
    Database db = await instance.database;

    return await db.insert(
      tableUsers,
      row,
    );
  }

  Future<Map<String, dynamic>?> getUserByName(
    String name,
  ) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> result = await db.query(
      tableUsers,
      where: '$columnName = ?',
      whereArgs: [name],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<int> updateBalance(
    String name,
    double newBalance,
  ) async {
    Database db = await instance.database;

    return await db.update(
      tableUsers,
      {
        columnBalance: newBalance,
      },
      where: '$columnName = ?',
      whereArgs: [name],
    );
  }

  // ==========================================
  // العمليات
  // ==========================================
  Future<int> insertTransaction(
    Map<String, dynamic> row,
  ) async {
    Database db = await instance.database;

    return await db.insert(
      tableTransactions,
      row,
    );
  }

  Future<List<Map<String, dynamic>>> getTransactionsByUser(
    String username,
  ) async {
    Database db = await instance.database;

    return await db.query(
      tableTransactions,
      where: '$transUsername = ?',
      whereArgs: [username],
      orderBy: '$transId DESC',
    );
  }

  // ==========================================
  // تعديل بيانات المستخدم
  // ==========================================
  Future<int> updateUserProfile(
    String username,
    String fullName,
    String dob,
    String phone,
    String birthPlace,
    String location,
  ) async {
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

  // ==========================================
  // حذف المستخدم وعملياته وإشعاراته وأهدافه
  // ==========================================
  Future<int> deleteUser(
    String username,
  ) async {
    Database db = await instance.database;

    await db.delete(
      tableTransactions,
      where: '$transUsername = ?',
      whereArgs: [username],
    );

    await db.delete(
      tableNotifications,
      where: '$notificationUsername = ?',
      whereArgs: [username],
    );

    await db.delete(
      tableSavingsGoals,
      where: '$goalUsername = ?',
      whereArgs: [username],
    );

    return await db.delete(
      tableUsers,
      where: '$columnName = ?',
      whereArgs: [username],
    );
  }

  // ==========================================
  // الإشعارات
  // ==========================================

  Future<int> insertNotification(
    Map<String, dynamic> row,
  ) async {
    Database db = await instance.database;

    return await db.insert(
      tableNotifications,
      row,
    );
  }

  Future<List<Map<String, dynamic>>> getNotificationsByUser(
    String username,
  ) async {
    Database db = await instance.database;

    return await db.query(
      tableNotifications,
      where: '$notificationUsername = ?',
      whereArgs: [username],
      orderBy: '$notificationId DESC',
    );
  }

  Future<int> getUnreadNotificationCount(
    String username,
  ) async {
    Database db = await instance.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) as count
      FROM $tableNotifications
      WHERE $notificationUsername = ?
      AND $notificationIsRead = 0
      ''',
      [username],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> markNotificationAsRead(
    int notificationIdValue,
  ) async {
    Database db = await instance.database;

    return await db.update(
      tableNotifications,
      {
        notificationIsRead: 1,
      },
      where: '$notificationId = ?',
      whereArgs: [notificationIdValue],
    );
  }

  Future<int> markAllNotificationsAsRead(
    String username,
  ) async {
    Database db = await instance.database;

    return await db.update(
      tableNotifications,
      {
        notificationIsRead: 1,
      },
      where:
          '$notificationUsername = ? AND $notificationIsRead = 0',
      whereArgs: [username],
    );
  }

  // ==========================================
  // أهداف الادخار 🎯
  // ==========================================

  // إضافة هدف جديد
  Future<int> insertSavingsGoal(
    Map<String, dynamic> row,
  ) async {
    Database db = await instance.database;

    return await db.insert(
      tableSavingsGoals,
      row,
    );
  }

  // جلب أهداف مستخدم معين
  Future<List<Map<String, dynamic>>> getSavingsGoalsByUser(
    String username,
  ) async {
    Database db = await instance.database;

    return await db.query(
      tableSavingsGoals,
      where: '$goalUsername = ?',
      whereArgs: [username],
      orderBy: '$goalId DESC',
    );
  }

  // تحديث المبلغ المدخر في الهدف
  Future<int> updateSavingsGoalAmount(
    int goalIdValue,
    double newSavedAmount,
  ) async {
    Database db = await instance.database;

    return await db.update(
      tableSavingsGoals,
      {
        goalSavedAmount: newSavedAmount,
      },
      where: '$goalId = ?',
      whereArgs: [goalIdValue],
    );
  }

  // حذف هدف ادخار
  Future<int> deleteSavingsGoal(
    int goalIdValue,
  ) async {
    Database db = await instance.database;

    return await db.delete(
      tableSavingsGoals,
      where: '$goalId = ?',
      whereArgs: [goalIdValue],
    );
  }
}