import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sqlfllite/home_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    checkInternet();
  }

  //checking internet connection

  late var hasInterner = false;
  void checkInternet() async {
    hasInterner = await InternetConnectionChecker().hasConnection;
    if (hasInterner == true) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage())));
    } else {
      print("No Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: hasInterner == true ? Colors.white : Colors.red,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            'assets/images/avera.jpg',
                          )),
                      if (hasInterner == true)
                        const SizedBox(
                          height: 30,
                        ),
                      if (hasInterner == true)
                        const Center(
                            child: CircularProgressIndicator(
                          color: Colors.amber,
                        )),
                      const SizedBox(
                        height: 140,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Avera",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 40),
                            ),
                            Text("Company",
                                style: TextStyle(
                                    color: Colors.amber, fontSize: 40)),
                            Text(
                              "проект Avera || Company",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 10),
                            ),
                            // TextButton(onPressed: () {}, child: const Text(""))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasInterner == false) get(hasInterner)
              ],
            ),
          ),
        ));
  }

  Widget get(bool check) {
    if (check == false) {
      return Expanded(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Нет подключение к интернету",
                  style: TextStyle(color: Colors.white),
                ),
                Text("проверьте соединение",
                    style: TextStyle(color: Colors.white)),
                Text("и повторите попытку",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            const Expanded(child: Text("")),
            TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text(
                  "ВЫХОД",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ],
        ),
      ));
    } else {
      return Text("");
    }
  }
}
