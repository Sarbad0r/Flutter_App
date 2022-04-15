import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sqlfllite/models/bundle.dart';
import 'package:http/http.dart' as http;
import '../db/ice_creame_db_provider.dart';

class BundleProvider extends ChangeNotifier {
  List<Bundle> _bundles = [];
  Future fetchBundle() async {
    try {
      final response = await http.get(Uri.parse(
          "https://korgar.tj/avera-api/priceslist?key=sd34lfkjsdklf@1234234DKFJS634DK@*\$%5Evmklsdfjlks234df"));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> list = map['data']['bundles'];
        print(list.length);

        for (int i = 0; i < list.length; i++) {
          _bundles.add(Bundle.fromJson(list[i]));
          DbIceCreamHelper.insertToBundles(_bundles[i]);
        }
        DbIceCreamHelper.insetToBundles_id(_bundles);
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      print(e);
    }
  }

  List<Bundle> _bundleDb = [];

  BundleProvider() {
    notify();
    load();
    notifyListeners();
  }

  List<Bundle> getIzbrannieList() {
    return _bundleDb.where((element) => element.izbrannoe == 1).toList();
  }

  void load() async {
    await fetchBundle();
    await fetchBundleDb();
  }

  List<Bundle> get bundleDb => [..._bundleDb];

  Future<void> fetchBundleDb() async {
    final data = await DbIceCreamHelper.getProductsDbBundles();

    _bundleDb = data.map((e) {
      return Bundle(
          id: e.id,
          name: e.name,
          description: e.description,
          type: e.type,
          discount: e.discount,
          izbrannoe: e.izbrannoe);
    }).toList();
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void addItemToBundle(Bundle bundle) {
    var found = _bundleDb.where((element) => element.id == bundle.id);

    if (found.isNotEmpty) {
      found.first.izbrannoe = 0;
    }
    notifyListeners();
  }

  void deleteBundleFromIzbrannie(Bundle bundle) {
    var found = _bundleDb.where((element) => element.id == bundle.id);
    found.first.izbrannoe = 0;
    notifyListeners();
  }
}
