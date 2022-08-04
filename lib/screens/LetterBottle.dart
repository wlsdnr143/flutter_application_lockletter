import 'package:flutter/material.dart';
import 'WriteLetter.dart';

class LetterBottle extends StatelessWidget {
  const LetterBottle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
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
                          fontSize: 20,
                          fontFamily: 'KyoboHandwriting2019'),
                    )),
              ),
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Image(
                  image: AssetImage('assets/images/before_login.png'),
                  width: 400,
                  height: 400,
                ),
              )

            ]))
    );
  }
}
