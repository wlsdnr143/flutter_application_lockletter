import 'package:flutter/material.dart';
import 'package:fluttergooglesignin/screens/splash_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../allConstants/color_constants.dart';
import '../allConstants/size_constants.dart';
import '../allConstants/text_field_constants.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: 'Sign in failed');
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: 'Sign in cancelled');
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: 'Sign in successful');
        break;
      default:
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.dimen_30,
              horizontal: Sizes.dimen_20,
            ),
            children: [
              SizedBox(height: 100),
              Center(child: Image.asset('assets/images/before_login.png')),
              SizedBox(height: 20),
              const Text(
                '잠긴편지에 오신 것을 환영합니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Sizes.dimen_20,
                ),
              ),
              SizedBox(height: 250),
              GestureDetector(
                onTap: () async {
                  bool isSuccess = await authProvider.handleGoogleSignIn();
                  if (isSuccess) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyBottomNavigationBar()));
                  }
                },
                child: Image.asset('assets/images/google_login.png'),
              ),
            ],
          ),
          Center(
            child: authProvider.status == Status.authenticating
                ? const CircularProgressIndicator(
                    color: AppColors.lightGrey,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
