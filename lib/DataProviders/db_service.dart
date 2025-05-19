import 'package:flutter/services.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _db;

  /* add new columns through alter query. here pass table name and 
  columns name with type to newColumns variable. */
  static final Map<String, Map<String, String>> newColumns = {
    AppConstants.branchDataTable: {'username': 'TEXT'},
  };

  static final DBService instance = DBService._constructor();

  DBService._constructor();

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), AppConstants.databaseName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // tables are created dynamically later
        await createTables(db);
        await applyAlterQueries();
      },
    );
    return _db!;
  }

  static Future createTables(Database db) async {
    try {
      String sqlQueries = await rootBundle.loadString(
        AppConstants.dbTablesFilePath,
      );
      print('$sqlQueries sqlQueries');

      // Split by semicolon and remove empty entries
      List<String> sqlStatements =
          sqlQueries
              .split(';')
              .map((stmt) => stmt.trim())
              .where((stmt) => stmt.isNotEmpty)
              .toList();

      for (String statement in sqlStatements) {
        await db.execute(statement);
      }
    } catch (e) {
      print('Error in createTable: $e');
    }
  }

  // static Future<void> alterQuery(
  //   String tablename,
  //   List<String> columnNames,
  //   List<String> columnTypes,
  // ) async {
  //   final db = await database;
  //   for (int i = 0; i < columnNames.length; i++) {
  //     try {
  //       String alterSQL =
  //           'ALTER TABLE $tablename ADD COLUMN ${columnNames[i]} ${columnTypes[i]}';
  //       await db.execute(alterSQL);
  //     } catch (e) {
  //       // Ignore error if column already exists or log it
  //       print('Error altering table $tablename: $e');
  //     }
  //   }
  // }

  static Future<void> applyAlterQueries() async {
    final db = await database;
    for (final table in newColumns.keys) {
      final columns = newColumns[table]!;
      for (final columnName in columns.keys) {
        final columnType = columns[columnName]!;
        try {
          await db.execute(
            'ALTER TABLE $table ADD COLUMN $columnName $columnType',
          );
        } catch (e) {
          print('Could not add column $columnName to $table: $e');
        }
      }
    }
  }

  static Future<dynamic> basicInsert(
    String tableName,
    List<String> keys,
    List<dynamic> values,
  ) async {
    try {
      final db = await database;
      String columns = keys.join(',');
      String placeholders = List.filled(values.length, '?').join(',');
      String query = 'INSERT INTO $tableName ($columns) VALUES ($placeholders)';
      return await db.rawInsert(query, values);
    } catch (e) {
      print('Insert error: $e');
      return e;
    }
  }

  static Future<dynamic> deleteTablesData(String tableName) async {
    try {
      final db = await database;
      return await db.rawDelete('DELETE FROM $tableName');
    } catch (e) {
      print('Delete error: $e');
      return e;
    }
  }

  static Future<dynamic> getAllData(String tableName, [String? colName]) async {
    try {
      final db = await database;
      if (colName != null) {
        return await db.rawQuery('SELECT * FROM $tableName ORDER BY $colName');
      } else {
        return await db.rawQuery('SELECT * FROM $tableName');
      }
    } catch (e) {
      print('Delete error: $e');
      return e;
    }
  }

  // close db on exit app
  static Future<void> closeDB() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}
