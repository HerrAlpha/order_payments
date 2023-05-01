import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_payments/model/user.dart';
import 'package:order_payments/ui/main_menu/investor/history/history_investor.dart';
import 'package:order_payments/ui/main_menu/investor/home/home_investor.dart';
import 'package:order_payments/ui/main_menu/investor/profile/profile_investor.dart';
import 'package:order_payments/ui/main_menu/resto/history/history.dart';
import 'package:order_payments/ui/main_menu/resto/home/home.dart';
import 'package:order_payments/ui/main_menu/resto/profile/profile.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  User? user;
  var isLoading = false;
  static const List<Widget> _widgetOptionsVendor = <Widget>[
    Home(),
    History(),
    Profile(),
  ];
  static const List<Widget> _widgetOptionsInvestor = <Widget>[
    HomeInvestor(),
    HistoryInvestmen(),
    ProfileInvestor(),
  ];
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      isLoading = true;
      await _getDataUser();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('user_data');
    if (data != null) {
      final user_data = jsonDecode(data);
      user = await User.fromJson(user_data);
      if (user?.role == "INVESTOR") {
        _widgetOptions = _widgetOptionsInvestor;
      } else {
        _widgetOptions = _widgetOptionsVendor;
      }
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator()
          : Container(
              child: user!.role == "INVESTOR"
                  ? _widgetOptionsInvestor.elementAt(_selectedIndex)
                  : _widgetOptionsVendor.elementAt(_selectedIndex),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF1F2430),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Color(0xffD3D3D3),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
