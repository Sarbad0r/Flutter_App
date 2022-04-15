import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/db/ice_creame_db_provider.dart';
import 'package:sqlfllite/pages/about_page.dart';
import 'package:sqlfllite/pages/order_page.dart';
import '../home_page.dart';
import '../provider/provider.dart';

class Cartt extends StatefulWidget {
  const Cartt({Key? key}) : super(key: key);

  @override
  _CarttState createState() => _CarttState();
}

class _CarttState extends State<Cartt> {
  @override
  Widget build(BuildContext context) {
    var getPriceList = Provider.of<ProviderProduct>(context);
    var _textStyle = const TextStyle(color: Colors.black, fontSize: 18);
    return Scaffold(
        backgroundColor:
            getPriceList.getQuantity() == 0 ? Colors.white : Colors.amber,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
                onPressed: () {
                  if (getPriceList.getPriceList().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Карта пуста"),
                      duration: Duration(milliseconds: 1500),
                    ));
                    return;
                  }
                  DbIceCreamHelper.deleteQuantity(0);
                  getPriceList.clearCart();
                },
                icon: Icon(Icons.delete)),
          ],
          title: Text("Корзина", style: const TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                // Container(
                //   height: 45,
                //   width: MediaQuery.of(context).size.width,
                //   color: Colors.amber,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(right: 10),
                //         child: IconButton(
                //             onPressed: () async {
                //               if (getPriceList.getPriceList().isEmpty) {
                //                 ScaffoldMessenger.of(context).showSnackBar(
                //                     const SnackBar(
                //                         duration: Duration(milliseconds: 1000),
                //                         content: Text("Cart is empty")));
                //               }
                //               getPriceList.clearCart();
                //               await DbIceCreamHelper.deleteQuantity(0);
                //               getPriceList.notify();
                //             },
                //             icon: const Icon(
                //               Icons.delete,
                //               color: Colors.white,
                //             )),
                //       )
                //     ],
                //   ),
                // ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 200,
                    color: Colors.white,
                    // decoration: const BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.only(
                    //         bottomLeft: Radius.circular(30),
                    //         bottomRight: Radius.circular(30))),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: getPriceList.getPriceList().isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // const Text(
                                  //   "Ой, пусто!",
                                  //   style: TextStyle(
                                  //       color: Colors.black, fontSize: 20),
                                  // ),
                                  const Text("Ваша корзина пуста,"),
                                  const Text(
                                      " добавьте понравившийся товар из 'Меню'"),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.amber)),
                                      onPressed: () {
                                        getPriceList.bottomNavBarIndex(0);
                                      },
                                      child: const Text("Перейти в меню"))
                                ],
                              ))
                            : Scrollbar(
                                showTrackOnHover: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (getPriceList.getQuantity() == 1)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Text(
                                          "${getPriceList.getQuantity()} товар за ${getPriceList.getAllPrice()}с",
                                          style: _textStyle,
                                        ),
                                      ),
                                    if (getPriceList.getQuantity() > 1 &&
                                        getPriceList.getQuantity() < 5)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Text(
                                          "${getPriceList.getQuantity()} товарa за ${getPriceList.getAllPrice()}с",
                                          style: _textStyle,
                                        ),
                                      ),
                                    if (getPriceList.getQuantity() > 4)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Text(
                                          "${getPriceList.getQuantity()} товаров за ${getPriceList.getAllPrice()}с",
                                          style: _textStyle,
                                        ),
                                      ),
                                    Expanded(
                                      child: ListView.builder(
                                          // physics:
                                          //     NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: getPriceList
                                              .getPriceList()
                                              .length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AboutPage(
                                                                pricelist:
                                                                    getPriceList
                                                                            .getPriceList()[
                                                                        index])));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30,
                                                    left: 10,
                                                    bottom: 20),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                                        // mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: 100,
                                                            height: 100,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey,
                                                                      spreadRadius:
                                                                          4,
                                                                      blurRadius:
                                                                          10,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              3))
                                                                ]),
                                                            child: Hero(
                                                              tag: getPriceList
                                                                  .getPriceList()[
                                                                      index]
                                                                  .name,
                                                              child:
                                                                  Image.asset(
                                                                "assets/priceListImages/${getPriceList.getPriceList()[index].image}",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Text(
                                                                    getPriceList
                                                                        .getPriceList()[
                                                                            index]
                                                                        .name,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Text(
                                                                    getPriceList
                                                                        .getPriceList()[
                                                                            index]
                                                                        .description,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: getPriceList
                                                                              .getPriceList()[
                                                                                  index]
                                                                              .quantity ==
                                                                          0
                                                                      ? MainAxisAlignment
                                                                          .start
                                                                      : MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await DbIceCreamHelper.updatePriceList(
                                                                              getPriceList.getPriceList()[index]);

                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text(getPriceList.getPriceList()[index].name),
                                                                            duration:
                                                                                const Duration(seconds: 1),
                                                                          ));
                                                                          getPriceList
                                                                              .notify();
                                                                        },
                                                                        child: getPriceList.getPriceList()[index].quantity! ==
                                                                                0
                                                                            ? const Text("Add to cart")
                                                                            : Row(
                                                                                children: [
                                                                                  TextButton(
                                                                                      onPressed: () async {
                                                                                        await DbIceCreamHelper.minusItemPriceList(getPriceList.getPriceList()[index]);

                                                                                        getPriceList.notify();
                                                                                      },
                                                                                      child: const Text("-")),
                                                                                  Text(getPriceList.getPriceList()[index].quantity.toString()),
                                                                                  TextButton(
                                                                                      onPressed: () async {
                                                                                        getPriceList.notify();
                                                                                        await DbIceCreamHelper.plusItemPriceList(getPriceList.getPriceList()[index]);
                                                                                      },
                                                                                      child: const Text("+"))
                                                                                ],
                                                                              ))
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                left: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "${getPriceList.getPriceList()[index].quantity! * getPriceList.getPriceList()[index].price}c"),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ))

                    // FutureBuilder<List<Pricelist>>(
                    //   future: DbIceCreamHelper.getPriceListCart(),
                    //   builder: (context, snap) {
                    //     final bool check = snap.connectionState == ConnectionState.done;
                    //     if (!check) {
                    //       return Text("");
                    //     } else {
                    //       return ListView.builder(
                    //           itemCount: snap.data!.length,
                    //           itemBuilder: (context, index) {
                    //             return Padding(
                    //               padding: const EdgeInsets.only(
                    //                   top: 30, left: 10, bottom: 20),
                    //               child: SizedBox(
                    //                 width: MediaQuery.of(context).size.width,
                    //                 child: Wrap(
                    //                   // crossAxisAlignment: CrossAxisAlignment.start,
                    //                   // mainAxisAlignment: MainAxisAlignment.start,
                    //                   children: [
                    //                     Container(
                    //                       width: 100,
                    //                       height: 100,
                    //                       decoration: const BoxDecoration(boxShadow: [
                    //                         BoxShadow(
                    //                             color: Colors.grey,
                    //                             spreadRadius: 4,
                    //                             blurRadius: 10,
                    //                             offset: Offset(0, 3))
                    //                       ]),
                    //                       child: Image.asset(
                    //                         "assets/priceListImages/${snap.data![index].image}",
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding:
                    //                           const EdgeInsets.only(top: 10, left: 10),
                    //                       child: Column(
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             snap.data![index].name,
                    //                             style: const TextStyle(
                    //                                 color: Colors.black, fontSize: 15),
                    //                           ),
                    //                           const SizedBox(
                    //                             height: 10,
                    //                           ),
                    //                           Text(
                    //                             snap.data![index].description,
                    //                             style: const TextStyle(fontSize: 10),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(right: 10),
                    //                       child: Row(
                    //                         mainAxisAlignment: MainAxisAlignment.end,
                    //                         children: [
                    //                           Text(snap.data![index].quantity.toString()),
                    //                           TextButton(
                    //                               onPressed: () {
                    //                                 setState(() {
                    //                                   DbIceCreamHelper
                    //                                       .addItemPricelistCart(
                    //                                           snap.data![index]);
                    //                                 });
                    //                               },
                    //                               child: Text("+")),
                    //                         ],
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             );
                    //           });
                    //     }
                    //   },
                    // )
                    ),
              ],
            ),
            Expanded(
              child: getPriceList.getQuantity() > 0
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.green)))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const OrderPage()));
                              },
                              child: const Text('Заказать'),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(""),
            )
          ],
        ));
  }
}
