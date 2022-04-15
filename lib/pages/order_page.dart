import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/db/ice_creame_db_provider.dart';
import 'package:sqlfllite/home_page.dart';
import 'package:sqlfllite/map/customer_address.dart';
import 'package:sqlfllite/map/location_screen.dart';
import 'package:sqlfllite/map/place_mark.dart';
import 'package:sqlfllite/map/polyline.dart';
import 'package:sqlfllite/map/yandex_map.dart';
import 'package:sqlfllite/models/address.dart';
import 'package:sqlfllite/pages/cart.dart';

import '../map/map_controls_page.dart';
import '../map/reverse_search.dart';
import '../provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
  }) : super(key: key);
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    var getProvider = Provider.of<ProviderProduct>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Общая количество товаров: ${getProvider.getQuantity().toString()}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 15,
            ),
            Text("Общая сумма : ${getProvider.getAllPrice().toString()} \$",
                style: TextStyle(fontSize: 16)),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    child: getProvider.address.isNotEmpty
                        ? Text(getProvider.address)
                        : const Text(
                            "Добавьте адресс",
                          ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white, primary: Colors.green),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ReverseSearchPage()),
                      );
                    },
                    child: const Text("Добавить из карты"))
              ],
            ),
            TextButton(
                onPressed: () {
                  if (getProvider.address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text("Сначала добавьте адресс")));
                    return;
                  }
                  print(getProvider.address);
                  getProvider.clearCart();
                  DbIceCreamHelper.deleteQuantity(0);
                  DbIceCreamHelper.addressApi("");
                  getProvider.updateAddress('');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 1000),
                      content: Text("Отправлено")));
                },
                child: const Text(
                  "Отправить",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
