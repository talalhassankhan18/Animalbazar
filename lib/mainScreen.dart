import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pet_store/widgets/Drawer.dart';

import 'Screens/BuyerScreen.dart';
import 'Screens/ProfileScreen.dart';
import 'Screens/SellerScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;
  bool isConnected = true;
  ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  StreamSubscription? _internetConnectionStreamSub;

     final List<Widget> _screens = [
    SellerScreen(),
    BuyerScreen(),
    Profilescreen(),
  ];

     final List<String> _titles = [
    "Seller",
    "Buyer",
    "Profile",
  ];

  @override
  void initState() {
    super.initState();
    _internetConnectionStreamSub =
        InternetConnection().onStatusChange.listen((event) {
          if (event == InternetStatus.disconnected) {
            setState(() {
              isConnected = false;
            });
          } else {
            setState(() {
              isConnected = true;
            });
          }
        });
  }

  @override
  void dispose() {
    _internetConnectionStreamSub?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isConnected
        ? Scaffold(
      body: ZoomDrawer(
        controller: zoomDrawerController,
        style: DrawerStyle.defaultStyle,
        menuScreen: DrawerMenu(
          onItemSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
            zoomDrawerController.close!();            },
        ),
        mainScreen: Scaffold(
          body: IndexedStack(
            index: _currentIndex,              children: _screens,
          ),
        ),
        borderRadius: 24.0,
        slideWidth: MediaQuery.of(context).size.width * 0.75,
        showShadow: true,
        shadowLayer1Color: Colors.teal.withOpacity(0.2),
        shadowLayer2Color: Colors.teal.withOpacity(0.1),
        angle: -10.0,
      ),
    )
        : Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi,
              size: 100,
              color: Colors.teal,
            ),
            SizedBox(height: 20),
            Text(
              'Check your Connection',
              style: TextStyle(
                fontSize: 20,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Trying to reconnect...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
