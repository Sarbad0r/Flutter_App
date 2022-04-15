import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/pages/form_page.dart';

import '../db/ice_creame_db_provider.dart';
import '../pages/order_page.dart';
import '../provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    var getPricelist = Provider.of<ProviderProduct>(context, listen: true);
    return Container(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Avera", style: TextStyle(color: Colors.white)),
                Text('2022c', style: TextStyle(color: Colors.white)),
                ElevatedButton(
                    child: Text("Login"),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => FormPage()));
                    }),
                TextButton(onPressed: (){
                  print("String ${getPricelist.address}");
                }, child: Text("ewe"))
              ],
            )
            // FutureBuilder<List<Product>>(
            //     future: DbIceCreamHelper.getProductsDb(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<Product>> snap) {
            //       return snap.data!.isEmpty
            //           ? const Text("No element")
            //           : Column(
            //               children: [
            //                 ...snap.data!.map((e) {
            //                   return Stack(
            //                     children: [Text("1212")],
            //                   );
            //                 })
            //               ],
            //             );
            //     }),
            ));
  }
}
