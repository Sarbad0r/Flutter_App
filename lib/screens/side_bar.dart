// ignore_for_file: unrelated_type_equality_checks

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/pages/izbranie.dart';
import 'package:sqlfllite/provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getProvider = Provider.of<ProviderProduct>(context);
    //this function will do two line of code in one return tapping
    // tap to see where is it
    void doTwoTask() {
      Navigator.pop(context);
      getProvider.bottomNavBarIndex(3);
    }

    //inside homepagescreen into Scaffold you need to add :
    //drawer : WidgetName();
    return Drawer(
      child: ListView(
        //for not showing top screen white line
        //remove for see and for remember
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Avaz',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: const Text('avaz.gmail.com',
                style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/icons/instagram_icon.png'),
              ),
            ),
            decoration: const BoxDecoration(
                //when the image is not load the color of background will be amber color
                color: Colors.amber,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/background.jpg'))),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text("Избранные"),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Izbrannoe())),
          ),
          ListTile(
              leading: getProvider.getQuantity == 0
                  ? const Icon(Icons.shopping_cart)
                  : Badge(
                      badgeColor: Colors.redAccent,
                      badgeContent: getProvider.getQuantity() == 0
                          ? Text("")
                          : Text(
                              getProvider.getQuantity().toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                      child: const Icon(Icons.shopping_cart)),
              title: const Text("Корзина"),
              onTap: () {
                return doTwoTask();
              }),
        ],
      ),
    );
  }
}
