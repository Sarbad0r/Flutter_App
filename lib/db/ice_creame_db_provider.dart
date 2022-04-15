import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqlfllite/models/address.dart';
import 'package:sqlfllite/models/bundle.dart';
import 'package:sqlfllite/models/pricelist.dart';

class DbIceCreamHelper with ChangeNotifier {
  static final Future<Database> database =
      getDatabasesPath().then((value) async {
    return openDatabase(join(value, 'magazin.db'),
        onCreate: (db, version) async {
          await db.execute(""
              "CREATE TABLE priceList (id INTEGER PRIMARY KEY, image TEXT , name TEXT, description TEXT,"
              " price REAL, type TEXT, quantity INTEGER, checked INTEGER)");

          await db.execute('''
          CREATE TABLE address (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, address_location TEXT)
          ''');

          await db.execute("CREATE TABLE bundles_cart (id INTEGER PRIMARY KEY,"
              "name TEXT, description TEXT, type TEXT, discount INTEGER)");

          await db.execute('''
          CREATE TABLE bundles_products (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, bundleId INTEGER, pricelistId INTEGER)
          ''');

          await db.execute('''
          CREATE TABLE priceList_cart (id INTEGER PRIMARY KEY , image TEXT, name TEXT, description TEXT,
           price REAL, type TEXT, quantity INTEGER)
          ''');

          await db.execute('''
            CREATE TABLE bundles (id INTEGER PRIMARY KEY, name TEXT, description TEXT, type TEXT, discount INTEGER, izbrannoe INTEGER)
            ''');
        },
        version: 26,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 26) {
            db.execute('''
          CREATE TABLE address (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, address_location TEXT)
          ''');
            db.execute(""
                "CREATE TABLE priceList (id INTEGER PRIMARY KEY, image TEXT , name TEXT, description TEXT,"
                " price REAL, type TEXT, quantity INTEGER, checked INTEGER)");

            db.execute('''
            CREATE TABLE bundles (id INTEGER PRIMARY KEY, name TEXT, description TEXT, type TEXT, discount INTEGER, izbrannoe INTEGER)
            ''');

            db.execute("CREATE TABLE bundles_cart (id INTEGER PRIMARY KEY,"
                "name TEXT, description TEXT, type TEXT, discount INTEGER)");

            db.execute('''
          CREATE TABLE bundles_products (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, bundleId INTEGER, pricelistId INTEGER)
          ''');

            db.execute('''
          CREATE TABLE priceList_cart (id INTEGER PRIMARY KEY , image TEXT, name TEXT, description TEXT,
           price REAL, type TEXT, quantity INTEGER)
          ''');
            // db.execute("DROP TABLE IF EXISTS bundles");
          }
        });
  });

  static Future<void> inserToDb(Pricelist pricelist) async {
    final db = await database;

    await db.insert("priceList", pricelist.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> insertToBundles(Bundle bundle) async {
    final db = await database;

    await db.insert("bundles", bundle.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> insetToBundles_id(List<Bundle> bundle) async {
    final db = await database;

    final check = await db.query("bundles_products");

    if (check.isNotEmpty) {
      return;
    } else {
      for (int i = 0; i < bundle.length; i++) {
        for (int j = 0; j < bundle[i].ids!.length; j++) {
          await db.rawInsert(
              "INSERT INTO bundles_products (bundleId , pricelistId) VALUES (${bundle[i].id}, ${bundle[i].ids![j]})");
        }
      }
    }
  }

  static Future<List<dynamic>> getBundleIdAndPriceListId() async {
    List<dynamic> list = [];
    final bd = await database;
    final List<Map<String, dynamic>> maps = await bd.query("bundles_products");

    for (int i = 0; i < maps.length; i++) {
      list.add(maps[i]);
    }
    return list;
  }

  static Future<void> insertPricelistCart(Pricelist pricelist) async {
    final db = await database;
    final found = await db
        .query("priceList_cart", where: "id = ?", whereArgs: [pricelist.id]);
    if (found.isNotEmpty) {
      db.delete("priceList_cart", whereArgs: [pricelist.id], where: "id =? ");
    } else {
      pricelist.quantity = 1;
      await db.insert("priceList_cart", pricelist.toJsonforCart(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<void> addItemPricelistCart(Pricelist pricelist) async {
    final db = await database;
    final found = await db
        .query("priceList_cart", where: "id = ?", whereArgs: [pricelist.id]);
    if (found.isNotEmpty) {
      // db.delete("priceList_cart", whereArgs: [pricelist.id], where: "id =? ");
      pricelist.quantity = pricelist.quantity! + 1;
      await db.update("priceList_cart", pricelist.toJsonforCart(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<List<Pricelist>> getPriceList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("priceList");

    return List.generate(maps.length, (i) {
      return Pricelist(
          id: maps[i]['id'],
          image: maps[i]['image'],
          name: maps[i]['name'],
          description: maps[i]['description'],
          price: maps[i]['price'],
          type: maps[i]['type'],
          quantity: maps[i]['quantity']);
    });
  }

  static Future<List<Pricelist>> getProductsDb() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query("priceList");

    return List.generate(maps.length, (i) {
      return Pricelist(
          id: maps[i]['id'],
          image: maps[i]['image'],
          name: maps[i]['name'],
          description: maps[i]['description'],
          price: maps[i]['price'],
          type: maps[i]['type'],
          quantity: maps[i]['quantity'],
          checked: maps[i]['checked']);
    });
  }

  // static Future<int> tableIsEmpty() async {
  //   int count = 0;
  //   final db = await database;
  //   count = Sqflite.firstIntValue(
  //       await db.rawQuery("SELECT COUNT(*) FROM priceList"))!;
  //   return count;
  // }

  static Future<List<Bundle>> getProductsDbBundles() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query("bundles");

    return List.generate(maps.length, (i) {
      return Bundle(
          id: maps[i]['id'],
          name: maps[i]['name'],
          description: maps[i]['description'],
          type: maps[i]['type'],
          discount: maps[i]['discount'],
          izbrannoe: maps[i]['izbrannoe']);
    });
  }

  static Future<List<Bundle>> getBundles() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('bundles_cart');

    return List.generate(maps.length, (index) {
      return Bundle(
          id: maps[index]['id'],
          name: maps[index]['name'],
          description: maps[index]['description'],
          type: maps[index]['type'],
          discount: maps[index]['discount'],
          izbrannoe: maps[index]['izbrannoe']);
    });
  }

  static Future<void> deleteProduct(int id) async {
    final db = await database;

    await db.delete("products", where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteIzbrannie(int id) async {
    final db = await database;

    await db.delete("bundles_cart", where: "id = ?", whereArgs: [id]);
  }

  static Future<void> setIfNotExists(Pricelist pricelist) async {
    var found = await database;

    var check = await found
        .query('priceList', where: 'id = ?', whereArgs: [pricelist.id]);

    if (check.isNotEmpty) {
      found.delete("priceList", where: "id = ?", whereArgs: [pricelist.id]);

      //print(" Quantity ${product.quantity}");
      // print("Checked ${product.checked}");
    } else {
      found.insert("priceList", pricelist.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      //print(" Quantity ${product.quantity}");
      //print("Checked ${product.checked}");
    }
  }

  static Future<void> setIfNotExistsIzbrannie(Bundle bundle) async {
    var found = await database;

    var check = await found
        .query('bundles_cart', where: 'id = ?', whereArgs: [bundle.id]);

    if (check.isNotEmpty) {
      // bundle.izbrannoe = false;
      found.delete("bundles_cart", where: "id = ?", whereArgs: [bundle.id]);
    } else {
      // bundle.izbrannoe = true;
      bundle.izbrannoe = 1;
      found.insert("bundles_cart", bundle.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<void> updatePriceList(Pricelist pricelist) async {
    final db = await database;

    var cheack =
        await db.query("priceList", where: "id = ?", whereArgs: [pricelist.id]);

    if (cheack.first['quantity'] == 1) {
      pricelist.quantity = 0;
      db.update('priceList', pricelist.toJson(),
          where: "id = ?", whereArgs: [pricelist.id]);
    } else {
      pricelist.quantity = 1;
      db.update("priceList", pricelist.toJson(),
          where: "id = ? ", whereArgs: [pricelist.id]);
    }
  }

  static Future<void> updateBundles(Bundle bundle) async {
    final db = await database;

    var check =
        await db.query("bundles", where: "id = ?", whereArgs: [bundle.id]);

    if (check.first['izbrannoe'] == 1) {
      bundle.izbrannoe = 0;
      db.update("bundles", bundle.toMap(),
          where: "id = ? ", whereArgs: [bundle.id]);
    } else {
      bundle.izbrannoe = 1;
      db.update("bundles", bundle.toMap(),
          where: "id = ? ", whereArgs: [bundle.id]);
    }
  }

  static Future<void> minusItemPriceList(Pricelist pricelist) async {
    final db = await database;

    var check =
        await db.query("priceList", where: "id = ?", whereArgs: [pricelist.id]);

    if (check.first['quantity'] != 0) {
      pricelist.quantity = pricelist.quantity! - 1;
      db.update("priceList", pricelist.toJson(),
          where: "id = ? ", whereArgs: [pricelist.id]);
    } else {
      pricelist.quantity = 0;
      db.update("priceList", pricelist.toJson(),
          where: "id = ? ", whereArgs: [pricelist.id]);
    }
  }

  static Future<void> plusItemPriceList(Pricelist pricelist) async {
    final db = await database;
    pricelist.quantity = pricelist.quantity! + 1;
    db.update("priceList", pricelist.toJson(),
        where: "id = ? ", whereArgs: [pricelist.id]);
  }

  static Future<void> addressApi(String addresss) async {
    final db = await database;

    var check = await db.query("address");
    if (check.isEmpty) {
      await db.rawInsert(
          "INSERT INTO address (address_location) VALUES ('$addresss')");
    } else {
      await db.rawUpdate('UPDATE address SET address_location = ?', [addresss]);
    }
  }

  static Future<String> getAdress() async {
    String res;
    final db = await database;
    List<Map<String, dynamic>> map = await db.query("address");
    if (map.isEmpty) {
      return '';
    } else {
      res = await map[0]['address_location'];
      return res;
    }
  }

  static Future<void> deleteQuantity(int index) async {
    final db = await database;
    await db
        .rawUpdate("UPDATE priceList SET quantity = $index WHERE quantity > 0");
  }

  //
  // static Future<bool> queryOneDaily (Product product) async {
  //   final db = await database;
  //   final check = await db.query(
  //     "products",
  //     where: "id = ?",
  //     whereArgs: [product.id],
  //   );
  //   if(check.isNotEmpty)
  //     {
  //       return false;
  //     }
  //   else
  //     {
  //       return true;
  //     }
  // }

  // static Future<bool> tableIsEmpty(Product product) async {
  //   var db = await database;
  //
  //   var check = await db
  //       .rawQuery("SELECT * FROM `newProducts` WHERE `id` = ${product.id}");
  //
  //   if (check.isEmpty) {
  //     print("Empty");
  //     return true;
  //   } else {
  //     print(check);
  //     return false;
  //   }
  // }
}
