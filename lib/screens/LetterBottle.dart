import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../utilities/debouncer.dart';
import 'SelectPerson_showMail.dart';
import 'chat_page2.dart';

class LetterBottle extends StatelessWidget {
  const LetterBottle({Key? key}) : super(key: key);

  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // final ScrollController scrollController = ScrollController();
  //
  // int _limit = 20;
  // final int _limitIncrement = 20;
  // String _textSearch = "";
  // bool isLoading = false;
  //
  // late AuthProvider authProvider;
  // late String currentUserId;
  // late HomeProvider homeProvider;
  //
  // Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  // StreamController<bool> buttonClearController = StreamController<bool>();
  // TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation:0.0,
            centerTitle: false,
            title: const Text(
              '   나에게 쓰는 편지',
              style: TextStyle(
                fontSize: 19,
                color:  Colors.black,
                fontFamily: "NotoSansKR_Medium",
              ),
            ),
            // leading: IconButton( // 로그아웃하는 버튼 누르면 login_page로 돌아감
            //     onPressed: () {
            //       Navigator.push(
            //           context, MaterialPageRoute(
            //           builder:(_) => SelectPerson_showMail())
            //       );
            //     },
            //     color: Colors.black,
            //     icon: const Icon(Icons.local_post_office_outlined)),
            // // leading: IconButton( // 로그아웃하는 버튼 누르면 login_page로 돌아감
            // //       onPressed: () => googleSignOut(),
            // //       color: Colors.black,
            // //       icon: const Icon(Icons.logout)),
            actions: [
              IconButton(
                  onPressed: (){},
                  color: Colors.black,
                  icon: const Icon(Icons.local_post_office_outlined)),
              // IconButton(
              //     onPressed: (){},
              //     color: Colors.black,
              //     icon: const Icon(Icons.calendar_today_outlined)),
            ]
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
            child: Column(children: <Widget>[
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(
                      //     builder: (BuildContext context){
                      //       return ChatPage2(
                      //         peerId: userChat.id,
                      //         peerNickname: userChat.displayName,
                      //       );
                      //     }
                      // ));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xffffffff),
                        side: const BorderSide(color: Color(0xffb5c7ce)),
                        minimumSize: const Size(120, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    child: const Text(
                      '편지쓰기',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Kyobo_Handwriting_2019'),
                    )),
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                child: Image(
                  image: AssetImage('assets/images/letter_bottle.png'),
                  width: 400,
                  height: 400,
                ),
              )

            ]))
    );
  }
}
