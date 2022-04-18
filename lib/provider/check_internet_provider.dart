import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CheckInternetProvider extends ChangeNotifier {
  bool _checkInternet = false;

  void aFuncThatCheckIntrnet() async {
    _checkInternet = await InternetConnectionChecker().hasConnection;
    print(_checkInternet);
    notifyListeners();
  }

  CheckInternetProvider()
  {
    aFuncThatCheckIntrnet();
  }

  bool get checkInternet => _checkInternet;
}
