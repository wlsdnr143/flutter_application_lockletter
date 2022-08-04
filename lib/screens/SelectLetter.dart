import 'package:flutter/material.dart';
// import 'SelectRelease.dart';
import 'PostBox.dart';
import 'SelectRelease.dart';
import 'home_page_sub.dart';

class SelectLetter extends StatelessWidget {
  const SelectLetter({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              '잠긴편지',
              style: TextStyle(color:Colors.black),
            ),
            actions:const <Widget>[
              // IconButton(
              //   icon:Icon(Icons.person, size:20),
              //   color:Colors.black,
              //   onPressed: (){
              //     showDialog(context:context,builder:(context){
              //       return AlertDialog(
              //           content: Text("개발중")
              //       );
              //     });
              //   },
              // ),
              // IconButton(
              //   icon:Icon(Icons.local_post_office_outlined, size:20),
              //   color:Colors.black,
              //   onPressed: (){
              //     showDialog(context: context, builder:(context){
              //       return AlertDialog(
              //         content: Text("슬로비짱"),
              //       );
              //     });
              //     Navigator.push(
              //         context, MaterialPageRoute(
              //         builder:(_) => PostBox()
              //     )
              //     );
              //   },
              // ),
            ]
        ),
        body:ListView(
          children:<Widget>[
            Card(
                child:ListTile(
                  title:Text('정성스런 필체로 필사 손편지 작성하기'),
                  subtitle:Text('예쁜 편지지에 꾹꾹 눌러 쓴 손글씨로 실물편지를 보내드려요'),
                  onTap: (){
                    print('손편지 작성하기');
                  },
                  trailing: Icon(Icons.arrow_right,color:Colors.blue),
                )
            ),
            Card(
                child:ListTile(
                  title:Text('앱으로 온라인 잠긴 편지 작성하기'),
                  subtitle:Text('애플리케이션으로 가볍게 편지를 적어 보내요'),
                  onTap: (){
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder:(_) => HomePage_Sub()
                    )
                    );
                    print('잠긴 편지 작성하기');
                  },
                  trailing: Icon(Icons.arrow_right,color:Colors.blue),
                )
            ),
          ],
        )
    );
  }
}














