import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sqlfllite/db/ice_creame_db_provider.dart';
import 'package:sqlfllite/models/bundle.dart';
import 'package:sqlfllite/models/pricelist.dart';
import 'package:http/http.dart' as http;

class ProviderProduct extends ChangeNotifier {
  List<Pricelist> pricelist = [];
  Future fetchPriceList() async {
    try {
      final response = await http.get(Uri.parse(
          "https://korgar.tj/avera-api/priceslist?key=sd34lfkjsdklf@1234234DKFJS634DK@*\$%5Evmklsdfjlks234df"));

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> list = map['data']['pricelist'];
        for (int i = 0; i < list.length; i++) {
          pricelist.add(Pricelist.fromJson(list[i]));
          DbIceCreamHelper.inserToDb(pricelist[i]);
        }
        print(pricelist.length);
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      print(e);
    }
  }

  List<Pricelist> getPriceList() {
    return _pricelistDb.where((element) => element.quantity! > 0).toList();
  }

  double getAllPrice() {
    late double get = 0.0;
    for (Pricelist p in getPriceList()) {
      get += p.quantity! * p.price;
    }
    print(get);
    return get;
  }

  int getQuantity() {
    late int get = 0;
    for (Pricelist p in getPriceList()) {
      get += p.quantity!;
    }
    return get;
  }

  void clearCart() {
    getPriceList().forEach((element) {
      element.quantity = 0;
    });
    notifyListeners();
  }
  List<Pricelist> getPriceListZero()
  {
    return _pricelistDb.where((element) => element.quantity == 0).toList();
  }

  String _adress = '';
  int _index = 0;
  List<Pricelist> _pricelistDb = [];
  List<Pricelist> _cart = [];

  ProviderProduct() {
    [..._pricelistDb];
    [..._cart];
    load();
    // notify();
  }

  void load() async {
    await fetchAdress();
    await fetchPriceList();
    await fetchAndSetData();
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  List<Pricelist> get pricelistDb => [..._pricelistDb];
  List<Pricelist> get cart => [..._cart];
  String get address => _adress;
  int get index => _index;


  Future<List<Pricelist>> fetchAndSetData() async {
    final data = await DbIceCreamHelper.getPriceList();
    print(data.length);
    if (data.isNotEmpty) {
      _pricelistDb = data.map((e) {
        return Pricelist(
            id: e.id,
            image: e.image,
            name: e.name,
            description: e.description,
            price: e.price,
            quantity: e.quantity,
            checked: e.checked,
            type: e.type);
      }).toList();
    }
    return _pricelistDb;
  }

  void add(Pricelist pricelist) {
    var check = _cart.where((element) => element.id == pricelist.id);

    if (check.isNotEmpty) {
      check.first.quantity = 0;
      _cart.remove(check.first);
      return;
    } else {
      pricelist.quantity = 1;
      _cart.add(pricelist);
    }
    notifyListeners();
  }

  void minusItemQuantity(Pricelist pricelist) {
    var found =
        _pricelistDb.where((element) => element.id == pricelist.id).first;

    if (found.quantity! > 1) {
      found.quantity = found.quantity! - 1;
    } else {
      delete(found);
    }
    notifyListeners();
  }

  void plusItemQuantity(Pricelist pricelist) {
    var found =
        _pricelistDb.where((element) => element.id == pricelist.id).first;
    found.quantity = found.quantity! + 1;
    notifyListeners();
  }

  void delete(Pricelist pricelist) {
    var found =
        _pricelistDb.where((element) => element.id == pricelist.id).first;
    found.quantity = 0;
    notifyListeners();
  }

 void updateAddress(String address){
    _adress = address;
    notifyListeners();
 }
  //
  Future<void> fetchAdress() async {
    final check = await DbIceCreamHelper.getAdress();
    if(check.isNotEmpty)
      {
        _adress = check;
        print("adressSS ${_adress}");
      }
    notifyListeners();
  }


  void bottomNavBarIndex(int index)
  {
    _index = index;
    notifyListeners();
  }


  // Future fetchPriceList() async {
  //   final response = await http.get(Uri.parse(
  //       "https://korgar.tj/avera-api/priceslist?key=sd34lfkjsdklf@1234234DKFJS634DK@*\$%5Evmklsdfjlks234df"));
  //
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     List<dynamic> list = map['data']['pricelist'];
  //
  //       for (int i = 0; i < list.length; i++) {
  //         _pricelist.add(Pricelist.fromJson(list[i]));
  //         DbIceCreamHelper.inserToDb(_pricelist[i]);
  //       }
  //
  //     print(pricelist.length);
  //   } else {
  //     throw Exception("Error");
  //   }
  //   notifyListeners();
  // }
  //
  // void addItemToPriceListCart(Pricelist pricelist)
  // {
  //
  //   var foundCart = _cart.where((element) => element.id == pricelist.id);
  //   if(foundCart.isNotEmpty)
  //     {
  //       foundCart.first.quantity = 0;
  //       _cart.remove(foundCart.first);
  //       DbIceCreamHelper.insertPricelistCart(foundCart.first);
  //       return;
  //     }
  //   else
  //     {
  //       pricelist.quantity = 1;
  //       _cart.add(pricelist);
  //       DbIceCreamHelper.insertPricelistCart(pricelist);
  //
  //     }
  //
  // notifyListeners();
  // }
  // void addQuantityOfPriceList(Pricelist pricelist)
  // {
  //   var found = _pricelist.where((element) => element.id == pricelist.id).first;
  //
  //   if(found.quantity !> 0)
  //     {
  //       found.checked = false;
  //       found.quantity = 0;
  //       return;
  //     }
  //   else
  //     {
  //       found.checked = true;
  //       found.quantity = 1;
  //     }
  //   notifyListeners();
  // }

  // List<Pricelist> _priceList = [];
  // List<Pricelist> get pricelist => [..._priceList];
  // ProviderProduct() {
  //   _priceList;
  //   notifyListeners();
  // }
  // void setToCartPriceList(Pricelist pricelist) {
  //   var found = _priceList.where((element) => element.id == pricelist.id);
  //   if (found.isNotEmpty) {
  //     found.first.quantity = 0;
  //     _priceList.remove(found.first);
  //   } else {
  //     pricelist.quantity = 1;
  //     _priceList.add(pricelist);
  //   }
  //
  //   notifyListeners();
  // }
  //
  // void plusItemQuantity(Pricelist pricelist) {
  //   var found = _priceList.where((element) => element.id == pricelist.id).first;
  //
  //   found.quantity = found.quantity! + 1;
  //
  //   notifyListeners();
  // }
  //
  // void minusItemQuantity(Pricelist pricelist) {
  //   var found = _priceList.where((element) => element.id == pricelist.id).first;
  //
  //   if (found.quantity! > 1) {
  //     found.quantity = found.quantity! - 1;
  //   } else {
  //     return;
  //   }
  //   notifyListeners();
  // }

  // Future<void> getFetch() async
  // {
  //   final get = await DbIceCreamHelper.getPriceListCart();
  //
  //   _priceList = get.map((item) => Pricelist(
  //       id: item.id,
  //       image: item.image,
  //       name: item.name,
  //       description: item.description,
  //       price: item.price,
  //       type: item.type)).toList();
  //
  //   notifyListeners();
  // }

// ProviderProduct() {
//   _products = [
//     Product(
//         id: 1,
//         productName: "Мороженое - Зеленый пломбир",
//         productImage: "one.jpg",
//         productTitle: "Сила Сибири",
//         price: 88.90,
//         quantity: 0,
//         checked: 0),
//     Product(
//         id: 2,
//         productName: "Мороженое - Красный пломбир",
//         productImage: "two.jpg",
//         productTitle: "Сила Сибири",
//         price: 88.90,
//         quantity: 0,
//         checked: 0),
//     Product(
//         id: 3,
//         productName: "Мороженое - Ягодный пломбир",
//         productImage: "third.jpg",
//         productTitle: "Сила Сибири",
//         price: 88.90,
//         quantity: 0,
//         checked: 0),
//   ];
//   notifyListeners();
// }

// List<Bundle> get products => _bundles;
//
// void addProductQuantity(Product product) {
//   var found = _products.where((element) => element.id == product.id).first;
//
//   if (found.quantity! > 0) {
//     found.quantity = found.quantity! + 1;
//   } else {
//     found.quantity = 1;
//   }
//   notifyListeners();
// }
//
// void deleteProduct(Product product) {
//   var found = _products.where((element) => element.id == product.id);
//   found.first.quantity = 0;
//   found.first.checked = 0;
//   notifyListeners();
// }
//
// void deleteProductQuantity(Product product) {
//   var found = _products.where((element) => element.id == product.id).first;
//
//   if (found.quantity! > 0) {
//     found.quantity = found.quantity! - 1;
//   } else {
//     found.quantity = 0;
//   }
//   notifyListeners();
// }
//
// void addItem(Product product) {
//   var found = _products.where((element) => element.id == product.id).first;
//
//   if (found.quantity! > 0) {
//     found.checked = 0;
//     return;
//   } else {
//     found.quantity = 1;
//     found.checked = 1;
//   }
//   notifyListeners();
// }
//
// double allPrice()
// {
//   double total = 0.0;
//   for(Product p in _products)
//     {
//       total += p.price * p.quantity!;
//     }
//   return total;
// }
}
