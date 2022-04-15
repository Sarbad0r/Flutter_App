import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/pages/cart.dart';
import 'package:sqlfllite/pages/contact.dart';
import 'package:sqlfllite/provider/provider.dart';
import 'package:sqlfllite/screens/bottom_nav_bar.dart';
import 'package:sqlfllite/screens/homepage_screen.dart';
import 'package:sqlfllite/screens/side_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const HomePageScreen(),
      const Center(child: Text("Here will be store")),
      const Contacts(),
      const Cartt(),
    ];

    var getProvider = Provider.of<ProviderProduct>(context);
    return Scaffold(
      drawer: const SideBar(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber,
      body: _pages[getProvider.index],
      bottomNavigationBar: BottomNavigationBar(
        // selectedFontSize: 20,
        selectedIconTheme: const IconThemeData(color: Colors.amberAccent),
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.amberAccent,
        currentIndex: getProvider.index,
        onTap: (index) {
          getProvider.bottomNavBarIndex(index);
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.amber,
              icon: Icon(
                Icons.menu_outlined,
                color: getProvider.index == 0 ? Colors.white : Colors.grey,
              ),
              label: "Меню"),
          BottomNavigationBarItem(
              backgroundColor: Colors.amber,
              icon: Icon(
                Icons.store,
                color: getProvider.index > 0 && getProvider.index < 2
                    ? Colors.white
                    : Colors.grey,
              ),
              label: "Меню"),
          BottomNavigationBarItem(
              backgroundColor: Colors.amber,
              icon: Icon(
                Icons.contacts_outlined,
                color: getProvider.index > 1 && getProvider.index < 3
                    ? Colors.white
                    : Colors.grey,
              ),
              label: "Контакты"),
          BottomNavigationBarItem(
              backgroundColor: Colors.amber,
              icon: getProvider.getQuantity() == 0
                  ? Icon(
                      Icons.shopping_cart,
                      color: getProvider.index > 2 && getProvider.index < 4
                          ? Colors.white
                          : Colors.grey,
                    )
                  : Badge(
                      badgeColor: Colors.redAccent,
                      badgeContent: Text(
                        getProvider.getQuantity().toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: getProvider.index > 2 && getProvider.index < 4
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
              label: "Корзина"),
        ],
      ),
    );
  }
}
