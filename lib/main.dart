import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttergooglesignin/providers/auth_provider.dart';
import 'package:fluttergooglesignin/providers/chat_provider.dart';
import 'package:fluttergooglesignin/providers/home_provider.dart';
import 'package:fluttergooglesignin/providers/profile_provider.dart';
import 'package:fluttergooglesignin/screens/splash_page.dart';
import 'package:fluttergooglesignin/utilities/theme.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: '<fluttergooglesignin>', // 이름을 추가해줌으로써 아래 오류 해결
      // E/flutter (18937): [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: [core/duplicate-app] A Firebase App named "[DEFAULT]" already exists
      options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(
                firebaseFirestore: firebaseFirestore,
                prefs: prefs,
                googleSignIn: GoogleSignIn(),
                firebaseAuth: FirebaseAuth.instance)),
        Provider<ProfileProvider>(
            create: (_) => ProfileProvider(
                prefs: prefs,
                firebaseFirestore: firebaseFirestore,
                firebaseStorage: firebaseStorage)),
        Provider<HomeProvider>(
            create: (_) => HomeProvider(firebaseFirestore: firebaseFirestore)),
        Provider<ChatProvider>(
            create: (_) => ChatProvider(
                prefs: prefs,
                firebaseStorage: firebaseStorage,
                firebaseFirestore: firebaseFirestore))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'slow-be',
        theme: appTheme,
        home: const SplashPage(),
      ),
    );
  }
}
