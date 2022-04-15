import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/home_page.dart';
import 'package:sqlfllite/provider/bundleProvider.dart';
import 'package:sqlfllite/provider/provider.dart';
import 'package:sqlfllite/screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.black, // navigation bar color
  //   statusBarColor: Colors.amber, // status bar color
  // ));
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [  
        ChangeNotifierProvider<ProviderProduct>(
            create: (_) => ProviderProduct()),
        ChangeNotifierProvider<BundleProvider>(
          create: (_) => BundleProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: Colors.amber),
        home: const LoadingScreen(),
      ),
    ),
  );
}
