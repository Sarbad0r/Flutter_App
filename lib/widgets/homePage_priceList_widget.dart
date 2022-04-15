import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../db/ice_creame_db_provider.dart';
import '../pages/about_page.dart';
import '../provider/provider.dart';

class PricelistWidget extends StatelessWidget {
  const PricelistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getPricelist = Provider.of<ProviderProduct>(context, listen: true);
    return AnimationLimiter(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: getPricelist.pricelistDb.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutPage(
                                pricelist: getPricelist.pricelistDb[index])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 10, bottom: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: Offset(0, 3))
                                    ]),
                                    child: Hero(
                                      tag: getPricelist.pricelistDb[index].name,
                                      child: Image.asset(
                                        "assets/priceListImages/${getPricelist.pricelistDb[index].image}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(
                                            getPricelist
                                                .pricelistDb[index].name,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(
                                            getPricelist
                                                .pricelistDb[index].description,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: getPricelist
                                                      .pricelistDb[index]
                                                      .quantity ==
                                                  0
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  await DbIceCreamHelper
                                                      .updatePriceList(
                                                          getPricelist
                                                                  .pricelistDb[
                                                              index]);

                                                  ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(getPricelist
                                                        .pricelistDb[index]
                                                        .name),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                  ));
                                                  getPricelist.notify();
                                                },
                                                child:
                                                    getPricelist
                                                                .pricelistDb[
                                                                    index]
                                                                .quantity! ==
                                                            0
                                                        ? const Text(
                                                            "Добавить в корзину")
                                                        : Row(
                                                            children: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await DbIceCreamHelper.minusItemPriceList(
                                                                        getPricelist
                                                                            .pricelistDb[index]);

                                                                    getPricelist
                                                                        .notify();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "-")),
                                                              Text(getPricelist
                                                                  .pricelistDb[
                                                                      index]
                                                                  .quantity
                                                                  .toString()),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    getPricelist
                                                                        .notify();
                                                                    await DbIceCreamHelper.plusItemPriceList(
                                                                        getPricelist
                                                                            .pricelistDb[index]);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "+"))
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
                                padding: const EdgeInsets.only(top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Нажмите чтобы увидеть информацию",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
