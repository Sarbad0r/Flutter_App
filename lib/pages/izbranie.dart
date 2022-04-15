import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/db/ice_creame_db_provider.dart';
import 'package:sqlfllite/home_page.dart';
import 'package:sqlfllite/models/pricelist.dart';
import 'package:sqlfllite/pages/bundle_product_page.dart';
import 'package:sqlfllite/provider/bundleProvider.dart';

class Izbrannoe extends StatefulWidget {
  const Izbrannoe({
    Key? key,
  }) : super(key: key);

  @override
  State<Izbrannoe> createState() => _IzbrannoeState();
}

class _IzbrannoeState extends State<Izbrannoe> {
  @override
  Widget build(BuildContext context) {
    var getBundle = Provider.of<BundleProvider>(context);
    return Scaffold(
        backgroundColor: Colors.amber,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height ,
                color: Colors.white,
                // decoration: const BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.only(
                //         bottomLeft: Radius.circular(30),
                //         bottomRight: Radius.circular(30))),
                child: getBundle.getIzbrannieList().isEmpty
                    ? const Center(child: Text("Пусто"))
                    : Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ListView.builder(
                          itemCount: getBundle.getIzbrannieList().length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 10, bottom: 20),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: GestureDetector(
                                      onTap: () async {
                                        List<dynamic> l = await DbIceCreamHelper
                                            .getBundleIdAndPriceListId();
                                        // List<Pricelist> sortered = l
                                        //     .where((element) => bundles[index]
                                        //     .ids!
                                        //     .contains(element.id))
                                        //     .toList();
                                        List<Pricelist> listpriceListDb =
                                            await DbIceCreamHelper
                                                .getProductsDb();
                                        List<Pricelist> list = [];
                                        List ids = [];
                                        for (int i = 0; i < l.length; i++) {
                                          if (l[i]['bundleId'] ==
                                              getBundle
                                                  .getIzbrannieList()[index]
                                                  .id) {
                                            ids.add(l[i]['pricelistId']);
                                            print(
                                                "id = ${l[i]['bundleId']} , ids = ${l[i]['pricelistId']} ,");
                                          }
                                        }
                                        list = listpriceListDb
                                            .where((element) =>
                                                ids.contains(element.id))
                                            .toList();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BundleProductPage(
                                                        priceList: list)));
                                      },
                                      child: Column(
                                        children: [
                                          Wrap(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          spreadRadius: 4,
                                                          blurRadius: 10,
                                                          offset: Offset(0, 3))
                                                    ]),
                                                child: Image.asset(
                                                  "assets/bundleImages/${getBundle.getIzbrannieList()[index].id - 1}.jpg",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(getBundle
                                                        .getIzbrannieList()[index]
                                                        .description),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      getBundle
                                                          .getIzbrannieList()[
                                                              index]
                                                          .name,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  DbIceCreamHelper
                                                                      .updateBundles(
                                                                          getBundle
                                                                              .getIzbrannieList()[index]);
                                                                  //
                                                                  getBundle.deleteBundleFromIzbrannie(
                                                                      getBundle
                                                                              .getIzbrannieList()[
                                                                          index]);
                                                                },
                                                                child: const Text(
                                                                    "Delete")),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            // ElevatedButton(
                                                            //     onPressed: () {
                                                            //      setState(() {
                                                            //
                                                            //      });
                                                            //     },
                                                            //     child: const Text(
                                                            // //         "Update")),
                                                            // Padding(
                                                            //     padding:
                                                            //         EdgeInsets.only(
                                                            //             left: 10)),
                                                            // Text(snap.data![index]
                                                            //     .quantity
                                                            //     .toString())
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.end,
                                          //   children: [
                                          //     IconButton(
                                          //         onPressed: () {
                                          //           setState(() {
                                          //             getProduct
                                          //                 .deleteProductQuantity(
                                          //                     snap.data![index]);
                                          //             DbIceCreamHelper
                                          //                 .updateProduct(getProduct
                                          //                     .products[index]);
                                          //           });
                                          //         },
                                          //         icon: Icon(Icons.remove)),
                                          //     Text(getProduct
                                          //         .products[index].quantity
                                          //         .toString()),
                                          //     IconButton(
                                          //         onPressed: () {
                                          //           setState(() {
                                          //             getProduct.addProductQuantity(
                                          //                 snap.data![index]);
                                          //             DbIceCreamHelper
                                          //                 .updateProduct(getProduct
                                          //                     .products[index]);
                                          //           });
                                          //         },
                                          //         icon: Icon(Icons.add)),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    )));
                          }),
                    )

                // FutureBuilder<List<Bundle>>(
                //     future: DbIceCreamHelper.getProductsDbBundles(),
                //     builder:
                //         (context, snap) {
                //       var check = snap.connectionState == ConnectionState.done;
                //       if (!check) {
                //         return const Center(child: CircularProgressIndicator());
                //       } else {
                //         return ListView.builder(
                //             itemCount: snap.data!.length,
                //             itemBuilder: (BuildContext context, int index) {
                //               return Padding(
                //                 padding: const EdgeInsets.only(
                //                     top: 30, left: 10, bottom: 20),
                //                 child: SizedBox(
                //                     width: MediaQuery.of(context).size.width,
                //                     child: snap.data![index].izbrannoe == 1
                //                         ? Column(
                //                             children: [
                //                               Wrap(
                //                                 // crossAxisAlignment: CrossAxisAlignment.start,
                //                                 // mainAxisAlignment:
                //                                 //     MainAxisAlignment.start,
                //                                 children: [
                //                                   Container(
                //                                     width: 100,
                //                                     height: 100,
                //                                     decoration:
                //                                         const BoxDecoration(
                //                                             boxShadow: [
                //                                           BoxShadow(
                //                                               color: Colors.grey,
                //                                               spreadRadius: 4,
                //                                               blurRadius: 10,
                //                                               offset:
                //                                                   Offset(0, 3))
                //                                         ]),
                //                                     child: Image.asset(
                //                                       "assets/bundleImages/${snap.data![index].id - 1}.jpg",
                //                                       fit: BoxFit.cover,
                //                                     ),
                //                                   ),
                //                                   Padding(
                //                                     padding:
                //                                         const EdgeInsets.only(
                //                                       top: 10,
                //                                     ),
                //                                     child: Column(
                //                                       crossAxisAlignment:
                //                                           CrossAxisAlignment
                //                                               .start,
                //                                       children: [
                //                                         Text(snap.data![index]
                //                                             .description),
                //                                         const SizedBox(
                //                                           height: 10,
                //                                         ),
                //                                         Text(
                //                                           snap.data![index].name,
                //                                           style: const TextStyle(
                //                                               fontSize: 15),
                //                                         ),
                //                                         Row(
                //                                           mainAxisAlignment:
                //                                               MainAxisAlignment
                //                                                   .spaceBetween,
                //                                           children: [
                //                                             Row(
                //                                               children: [
                //                                                 ElevatedButton(
                //                                                     onPressed:
                //                                                         () async {
                //                                                       DbIceCreamHelper
                //                                                           .updateBundles(
                //                                                               snap.data![index]);
                //                                                     },
                //                                                     child: const Text(
                //                                                         "Delete")),
                //                                                 const SizedBox(
                //                                                   width: 10,
                //                                                 ),
                //                                                 // ElevatedButton(
                //                                                 //     onPressed: () {
                //                                                 //      setState(() {
                //                                                 //
                //                                                 //      });
                //                                                 //     },
                //                                                 //     child: const Text(
                //                                                 // //         "Update")),
                //                                                 // Padding(
                //                                                 //     padding:
                //                                                 //         EdgeInsets.only(
                //                                                 //             left: 10)),
                //                                                 // Text(snap.data![index]
                //                                                 //     .quantity
                //                                                 //     .toString())
                //                                               ],
                //                                             ),
                //                                           ],
                //                                         )
                //                                       ],
                //                                     ),
                //                                   )
                //                                 ],
                //                               ),
                //                               // Row(
                //                               //   mainAxisAlignment:
                //                               //       MainAxisAlignment.end,
                //                               //   children: [
                //                               //     IconButton(
                //                               //         onPressed: () {
                //                               //           setState(() {
                //                               //             getProduct
                //                               //                 .deleteProductQuantity(
                //                               //                     snap.data![index]);
                //                               //             DbIceCreamHelper
                //                               //                 .updateProduct(getProduct
                //                               //                     .products[index]);
                //                               //           });
                //                               //         },
                //                               //         icon: Icon(Icons.remove)),
                //                               //     Text(getProduct
                //                               //         .products[index].quantity
                //                               //         .toString()),
                //                               //     IconButton(
                //                               //         onPressed: () {
                //                               //           setState(() {
                //                               //             getProduct.addProductQuantity(
                //                               //                 snap.data![index]);
                //                               //             DbIceCreamHelper
                //                               //                 .updateProduct(getProduct
                //                               //                     .products[index]);
                //                               //           });
                //                               //         },
                //                               //         icon: Icon(Icons.add)),
                //                               //   ],
                //                               // )
                //                             ],
                //                           )
                //                         : const SizedBox(
                //                             height: -900,
                //                           )),
                //               );
                //             });
                //       }
                //     }),
                ),
            // const Padding(
            //   padding: EdgeInsets.only(top: 10),
            //   child: Center(
            //       child: Text(
            //     "Total : "
            //     // +
            //     //     getProduct.allPrice().toStringAsFixed(2),
            //     ,
            //     style: TextStyle(color: Colors.white),
            //   )),
            // )
          ],
        ));
  }
}
