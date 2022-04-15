import 'package:flutter/material.dart';
import 'package:sqlfllite/models/pricelist.dart';

class BundleProductPage extends StatefulWidget {
  List<Pricelist> priceList;
  BundleProductPage({Key? key, required this.priceList}) : super(key: key);

  @override
  State<BundleProductPage> createState() => _BundleProductPageState();
}

class _BundleProductPageState extends State<BundleProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

      ),

      body: ListView.builder(
          itemCount: widget.priceList.length,
          itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, bottom: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
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
                  child: Image.asset(
                    "assets/priceListImages/${widget.priceList[index].image}",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.priceList[index].name,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.priceList[index].description,
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        widget.priceList[index].id.toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
