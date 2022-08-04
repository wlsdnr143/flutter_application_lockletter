import 'package:flutter/material.dart';

class WriteLetter extends StatelessWidget {
  const WriteLetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0,100.0,20.0,0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment:  MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed:(){
                      Navigator.pop(context);
                    },
                    child: const Text ('뒤로가기',style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'KyoboHandwriting2019')),
                    style: ElevatedButton.styleFrom(
                          primary: const Color(0xffffffff),
                          side: const BorderSide(color: Color(0xffb5c7ce)),
                          minimumSize: const Size(50, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),

                    ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(context: context, builder: (context){
                          return const AlertDialog(
                            content: Text("전송이 완료되었습니다."),
                          );
                        })
                        ;},
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xffffffff),
                          side: const BorderSide(color: Color(0xffb5c7ce)),
                          minimumSize: Size(50, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      child: const Text(
                        '보내기',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'KyoboHandwriting2019'),
                      )),
                ],
              ),
              const SizedBox(height:10),
              TextFormField(
                maxLines: 25,
                decoration: InputDecoration(
                  hintText: "편지 내용을 작성해주세요",
                  fillColor: Colors.grey[300],
                  filled: true,
                ),
              )
          ]),
        ),
      )
      );
  }
}
