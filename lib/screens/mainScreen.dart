import 'dart:convert';

import 'package:final64125842/constants/config.dart';
import 'package:final64125842/screens/bookingScreen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import './aboutScreen.dart';
import './catalogsScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? username;

  String? uID;

  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      uID = args;
      _pages = <Widget>[
        CatalogsScreen(
          uID: uID!,
        ),
        BookingScreen(
          uID: uID!,
        ),
        AboutScreen(),
      ];
      var url = baseUrl + "/profile.php?uID=$uID";
      var response = await http.get(
        Uri.parse(url),
      );
      String uname = json.decode(response.body);
      setState(() {
        username = uname;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: const Text('Main'),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Hi, $username'),
                const SizedBox(
                  width: 24,
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Confirm'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/signIn');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16), child: _pages[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Catalogs'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booking'),
            BottomNavigationBarItem(icon: Icon(Icons.woman), label: 'About'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
