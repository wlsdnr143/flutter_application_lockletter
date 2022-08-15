import 'package:flutter/material.dart';
import 'SelectPerson_test.dart';
import 'WriteLetter.dart';

class LetterBottle extends StatelessWidget {
  const LetterBottle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation:0.0,
            centerTitle: true,
            title: const Text(
              '잠긴편지',
              style: TextStyle(color:Colors.black),
            ),
            leading: IconButton( // 로그아웃하는 버튼 누르면 login_page로 돌아감
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder:(_) => SelectPerson_test())
                  );
                },
                color: Colors.black,
                icon: const Icon(Icons.local_post_office_outlined)),
            // leading: IconButton( // 로그아웃하는 버튼 누르면 login_page로 돌아감
            //       onPressed: () => googleSignOut(),
            //       color: Colors.black,
            //       icon: const Icon(Icons.logout)),
            actions: [
              IconButton(
                  onPressed: (){},
                  color: Colors.black,
                  icon: const Icon(Icons.add_reaction_outlined)),
              // IconButton(
              //     onPressed: (){},
              //     color: Colors.black,
              //     icon: const Icon(Icons.calendar_today_outlined)),
            ]),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
            child: Column(children: <Widget>[
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context){
                            return WriteLetter();
                          }
                      ));
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
