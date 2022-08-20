import 'package:flutter/material.dart';
import 'package:fluttergooglesignin/screens/splash_page.dart';

class SendComplete extends StatelessWidget {
  const SendComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            color: Colors.black,
            icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.white,
          elevation:0.0,
          centerTitle: true,
          title: const Text(
            '잠긴편지',
            style: TextStyle(
              fontSize: 18,
              color:  Colors.black,
              fontWeight: FontWeight.normal,
              fontFamily: "SANGJU",
            ),
          ),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:150),
            Container(
                width: 220,
                height:110,
                child: Image.asset('assets/images/sendLetter.png', fit: BoxFit.fitWidth)
            ),
            SizedBox(height:10),
            const Text(
                "전송 완료",
                style: TextStyle(
                    color:Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SCDream4",
                    fontStyle:  FontStyle.normal,
                    fontSize: 20.0
                ),
                textAlign: TextAlign.left
            ),
            SizedBox(height:20),
            const Text(
                "잠금이 풀리는 날 만나요",
                style: TextStyle(
                    color:Color(0xff767676),
                    fontWeight: FontWeight.w400,
                    fontFamily: "SCDream4",
                    fontStyle:  FontStyle.normal,
                    fontSize: 14.0
                ),
                textAlign: TextAlign.left
            ),
            SizedBox(height:200),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.red,),
              onPressed: () {
                Navigator.push(
                  context,MaterialPageRoute(
                  builder: (context) => SplashPage(),
                ),);
              },
              child: const Text('홈화면 돌아가기',
                style: TextStyle(
                    color:Color(0xff767676),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SCDream4",
                    fontStyle:  FontStyle.normal,
                    fontSize: 14.0
                ),),
            )
          ],
        ),
      )
    );
  }
}
