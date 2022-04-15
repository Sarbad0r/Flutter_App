import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/db/ice_creame_db_provider.dart';
import 'package:sqlfllite/models/pricelist.dart';
import 'package:sqlfllite/pages/bundle_product_page.dart';
import 'package:sqlfllite/pages/cart.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sqlfllite/provider/bundleProvider.dart';
import 'package:sqlfllite/screens/side_bar.dart';
import 'package:sqlfllite/widgets/homePage_priceList_widget.dart';
import '../pages/about_page.dart';
import '../pages/izbranie.dart';
import '../provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    var getbundle = Provider.of<BundleProvider>(context);

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 55,
        color: Colors.white,
        // delete
        // decoration: const BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(30),
        //         bottomRight: Radius.circular(30))),
        child: NotificationListener<ScrollNotification>(
            onNotification: (notify) {
              print(notify);
              return true;
            },
            child: Scrollbar(
                showTrackOnHover: true,
                child: ListView(shrinkWrap: true, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(Icons.menu)),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 13),
                              child: Text(
                                "Avera Company ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 10),
                          //   child: IconButton(
                          //     onPressed: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (context) => const Izbrannoe()));
                          //       print("Bundle izbarnnoe");
                          //     },
                          //     icon: const Icon(Icons.store),
                          //     iconSize: 30,
                          //   ),
                          // ),
                          // Padding(
                          //     padding: const EdgeInsets.only(right: 10),
                          //     child: Padding(
                          //         padding: const EdgeInsets.only(right: 10),
                          //         child: IconButton(
                          //           onPressed: () {
                          //             getPricelist.notify();
                          //             Navigator.of(context).push(MaterialPageRoute(
                          //                 builder: (context) => const Cartt()));
                          //
                          //             print("pricelistCart");
                          //           },
                          //           icon: getPricelist.getQuantity() == 0
                          //               ? const Icon(Icons.store_mall_directory_outlined)
                          //               : Badge(
                          //                   badgeColor: Colors.redAccent,
                          //                   badgeContent: Text(
                          //                     getPricelist.getQuantity().toString(),
                          //                     style: TextStyle(color: Colors.white),
                          //                   ),
                          //                   child: const Icon(
                          //                       Icons.store_mall_directory_outlined),
                          //                 ),
                          //           iconSize: 30,
                          //         )))
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "Лучшие гарантированные технологии только у нас",
                          style: TextStyle(fontSize: 45),
                        ),
                      ),
                      Container(
                          height: 280,
                          child: getbundle.bundleDb.isEmpty
                              ? Center(
                                  child: Column(
                                  children: const [
                                    CircularProgressIndicator(
                                      color: Colors.amber,
                                    ),
                                    SizedBox(height: 3),
                                    Text("Подключение к интернету",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10))
                                  ],
                                ))
                              : Scrollbar(
                                  showTrackOnHover: true,
                                  child: ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: getbundle.bundleDb.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            List<dynamic> l =
                                                await DbIceCreamHelper
                                                    .getBundleIdAndPriceListId();
                                            // List<Pricelist> sortered = l
                                            //     .where((element) => bundles[index]
                                            //     .ids!list = listpriceListDb
                                            // .where((element) => ids.contains(element.id))
                                            // .toList();
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            // builder: (context) =>
                                            // BundleProductPage(priceList: list)));
                                            //     .contains(element.id))
                                            //     .toList();
                                            List<Pricelist> listpriceListDb =
                                                await DbIceCreamHelper
                                                    .getProductsDb();
                                            List<Pricelist> list = [];
                                            List ids = [];
                                            for (int i = 0; i < l.length; i++) {
                                              if (l[i]['bundleId'] ==
                                                  getbundle
                                                      .bundleDb[index].id) {
                                                ids.add(l[i]['pricelistId']);
                                                print(
                                                    "id = ${l[i]['bundleId']} , ids = ${l[i]['pricelistId']} ,");
                                              }
                                            }
                                            print(ids.length);

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
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 25),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getbundle.bundleDb[index]
                                                      .description,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: 200,
                                                  height: 150,
                                                  decoration:
                                                      const BoxDecoration(
                                                          boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            spreadRadius: 4,
                                                            blurRadius: 10,
                                                            offset:
                                                                Offset(0, 3))
                                                      ]),
                                                  child: Image.asset(
                                                    "assets/bundleImages/$index.jpg",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(getbundle
                                                    .bundleDb[index].name),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Нажмите чтобы увидеть комплект",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          // DbIceCreamHelper
                                                          //     .setIfNotExistsIzbrannie(
                                                          //         snap.data![index]);

                                                          await DbIceCreamHelper
                                                              .updateBundles(
                                                                  getbundle
                                                                          .bundleDb[
                                                                      index]);

                                                          getbundle.notify();

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                "${getbundle.bundleDb[index].name} добавлен в избранные"),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                          ));
                                                        },
                                                        icon: Icon(
                                                          getbundle
                                                                      .bundleDb[
                                                                          index]
                                                                      .izbrannoe ==
                                                                  0
                                                              ? Icons
                                                                  .star_border_outlined
                                                              : Icons.star,
                                                          size: 30,
                                                        )),
                                                    // IconButton(
                                                    //     onPressed: () {
                                                    //       setState(() {
                                                    //         DbIceCreamHelper.tableIsEmpty(getProducts.products[index]);
                                                    //
                                                    //         DbIceCreamHelper
                                                    //             .setIfNotExistsIzbrannie(
                                                    //                 getProducts
                                                    //                     .products[index]);
                                                    //
                                                    //         ScaffoldMessenger.of(context)
                                                    //             .showSnackBar(SnackBar(
                                                    //           content: Text(getProducts
                                                    //               .products[index]
                                                    //               .productName),
                                                    //           duration: Duration(seconds: 1),
                                                    //         ));
                                                    //         print(getProducts.products[index].checked);
                                                    //       });
                                                    //     },
                                                    //     icon: const Icon(
                                                    //       Icons.add_circle_outlined,
                                                    //       size: 30,
                                                    //     ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )),
                    ],
                  ),
                  //priceListWidget
                  const PricelistWidget()
                ]))));
//         FutureBuilder<List<Pricelist>>(
//             future: DbIceCreamHelper.getProductsDb(),
//             builder: (context, snap) {
//               final bool checkNull =
//                   snap.connectionState == ConnectionState.done;
//               if (!checkNull) {
//                 return const Center(child: Text("Идёт загрузка товаров..."));
//                 // const CircularProgressIndicator();
//               } else if (snap.hasError) {
//                 return Text(snap.error.toString());
//               } else {
//                 return Column(
//                   children: [
//                     ...?snap.data?.map((e) {
//                       return InkWell(
//                         onTap: () {
//                           // Navigator.of(context).push(MaterialPageRoute(
//                           //     builder: (context) => AboutPage(product: e)));
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               top: 30, left: 10, bottom: 20),
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: Wrap(
//                               // crossAxisAlignment: CrossAxisAlignment.start,
//                               // mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   width: 100,
//                                   height: 100,
//                                   decoration: const BoxDecoration(boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.grey,
//                                         spreadRadius: 4,
//                                         blurRadius: 10,
//                                         offset: Offset(0, 3))
//                                   ]),
//                                   child: Image.asset(
//                                     "assets/priceListImages/${e.image}",
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(top: 10, left: 10),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         e.name,
//                                         style: const TextStyle(
//                                             color: Colors.black, fontSize: 15),
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         e.description,
//                                         style: const TextStyle(fontSize: 10),
//                                       ),
//
  }
}
