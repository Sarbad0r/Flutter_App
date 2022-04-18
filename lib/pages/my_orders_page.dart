import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MyOrdersPage extends StatefulWidget {
  MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  late bool internetCheker = false;

  @override
  void initState() {
    // TODO: implement initState
    InternetConnectionChecker().onStatusChange.listen((event) {
      final checker = event == InternetConnectionStatus.connected;
      setState(() {
        internetCheker = checker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _textsStyle = const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("orders").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
            if (!snap.hasData) {
              return Text(
                "Loading....",
                style: _textsStyle,
              );
            }
            if (snap.data!.docs.isEmpty) {
              return Text(
                "Empty",
                style: _textsStyle,
              );
            }
            return Scrollbar(
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 20,
                          endIndent: 10),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Адресс: ${snap.data?.docs[index].get('address')}",
                          style: _textsStyle,
                        ),
                        Text(
                          "Общая количество товаров: ${snap.data?.docs[index].get('all_quantity_of_products')}",
                          style: _textsStyle,
                        ),
                        Text(
                          "Общая сумма: ${snap.data?.docs[index].get('total_price')}",
                          style: _textsStyle,
                        )
                      ],
                    );
                  }),
            );
          }),
    );
  }
}
