import 'package:flutter/material.dart';
import 'package:fluttergooglesignin/screens/profile_page.dart';
import 'package:provider/provider.dart';
import '../allConstants/color_constants.dart';
import '../allConstants/size_constants.dart';
import '../providers/auth_provider.dart';
import 'LetterBottle.dart';
import 'Setting.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyBottomNavigationBar()));
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "잠긴편지",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Sizes.dimen_18),
            ),
            Image.asset(
              'assets/images/before_login.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              color: AppColors.lightGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;
  final List<Widget> _children = <Widget>[
    const HomePage(),
    const LetterBottle(),
    const ProfilePage(),
    const Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _children.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type:BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled,
                size: 25,
                color: Colors.black),
            activeIcon: Icon(Icons.home_filled,
                size: 25,
                color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty,
                size: 25, color: Colors.black),
            activeIcon: Icon(Icons.hourglass_empty,
                size: 25,
                color: Colors.blue),
            label: 'Case',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined,
                size: 25,
                color: Colors.black),
            activeIcon: Icon(Icons.person_outlined,
                size: 25,
                color: Colors.blue),
            label: 'Person',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz,
                size: 25,
                color: Colors.black),
            activeIcon: Icon(Icons.more_horiz,
                size: 25,
                color: Colors.blue),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
