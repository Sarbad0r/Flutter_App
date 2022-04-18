import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatelessWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String number = "+992111111111";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Связаться с поддержкой",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async{
                          launch('tel://$number');
                        },
                        child: const Text("Позвонить"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: const BorderSide(
                                        color: Colors.green)))),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Написать в чат"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: const BorderSide(
                                        color: Colors.green)))),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () async {
                          launch('https://www.facebook.com/avera.tj/');
                        },
                        icon: Image.asset('assets/icons/facebook_icon.png')),
                    IconButton(
                        onPressed: () async {
                          launch('https://www.instagram.com/avera.tj/');
                        },
                        icon: Image.asset('assets/icons/instagram_icon.png')),
                  ],
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
