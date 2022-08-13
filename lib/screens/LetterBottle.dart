import 'package:flutter/material.dart';
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
              '나에게 쓰는 편지',
              style: TextStyle(color:Colors.black),
            ),
        ),
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
                          fontFamily: 'AppleSDGothicNeo'),
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
