import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/models/pricelist.dart';

import '../db/ice_creame_db_provider.dart';
import '../provider/provider.dart';

class AboutPage extends StatelessWidget {
  Pricelist pricelist;
  AboutPage({Key? key, required this.pricelist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getPricelist = Provider.of<ProviderProduct>(context, listen: true);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(3, 0),
                        spreadRadius: 5,
                        blurRadius: 1)
                  ]),
                  width: MediaQuery.of(context).size.width,
                  height: 240,
                  child: Hero(
                    tag: pricelist.name,
                    child: Image.asset(
                      "assets/priceListImages/${pricelist.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pricelist.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(pricelist.description,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("${pricelist.price}c",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          )),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
            const Expanded(child: Text("")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: Colors.green)))),
                      onPressed: () async {
                        await DbIceCreamHelper.updatePriceList(pricelist);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(pricelist.name),
                          duration: const Duration(seconds: 1),
                        ));
                        getPricelist.notify();
                      },
                      child: pricelist.quantity! == 0
                          ? const Text("Add to cart")
                          : Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      await DbIceCreamHelper.minusItemPriceList(
                                          pricelist);

                                      getPricelist.notify();
                                    },
                                    child: const Text(
                                      "-",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Text(pricelist.quantity.toString()),
                                TextButton(
                                    onPressed: () async {
                                      getPricelist.notify();
                                      await DbIceCreamHelper.plusItemPriceList(
                                          pricelist);
                                    },
                                    child: const Text("+",
                                        style: TextStyle(color: Colors.white)))
                              ],
                            )),
                ),
              ],
            )
          ],
        ));
  }
}
