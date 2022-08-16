import 'package:flutter/material.dart';
// import 'SelectRelease.dart';
import 'SelectRelease.dart';
import 'findFriend_TosendLetter.dart';

class SelectLetter extends StatelessWidget {
  const SelectLetter({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.black,
              icon: Icon(Icons.arrow_back)),
            backgroundColor: Colors.transparent,
            elevation:0.0,
            centerTitle: true,
            title: const Text(
              '잠긴편지',
              style: TextStyle(color:Colors.black),
            ),
        ),
        body:Padding(
          padding: const EdgeInsets.fromLTRB(10.0,30.0,10.0,0.0),
          child: ListView(
            children:<Widget>[
              Card(
                  child:Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title:Row(
                        children: const [
                          Text('정성스런 필체로 ',style: TextStyle(
                              color:Color(0xff191919),
                              fontWeight: FontWeight.w300,
                              fontFamily: "AppleSDGothicNeo",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),),
                          Text('필사 손편지 ',style: TextStyle(
                              color:Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontFamily: "AppleSDGothicNeo",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),),
                          Text('작성하기',style: TextStyle(
                              color:Color(0xff191919),
                              fontWeight: FontWeight.w300,
                              fontFamily: "AppleSDGothicNeo",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),),
                        ],
                      ),
                      subtitle:const Text('예쁜 편지지에 꾹꾹 눌러 쓴 손글씨로 실물편지를 보내드려요 \n5,500₩/장 (약 nnnn자)',style: TextStyle(
                          fontFamily: "AppleSDGothicNeo",
                          fontSize: 12.0
                      ),),
                      onTap: (){
                        print('손편지 작성하기');
                      },
                      trailing: Icon(Icons.arrow_forward,color:Colors.blue),
                    ),
                  )
              ),
              Card(
                  child:Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title:Row(
                        children: const [
                          Text('앱으로 온라인',style: TextStyle(
                              color:Color(0xff191919),
                              fontWeight: FontWeight.w300,
                              fontFamily: "AppleSDGothicNeo",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),),
                          Text(' 잠긴 편지 ',style: TextStyle(
                              color:Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontFamily: "AppleSDGothicNeo",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),),
                          Text('작성하기',style: TextStyle(
                              color:Color(0xff191919),
                              fontWeight: FontWeight.w300,
                              fontFamily: "AppleSDGothicNeo",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),),
                        ],
                      ),
                      subtitle:const Text('애플리케이션으로 가볍게 편지를 적어 보내요\n(최대 nnnnn자)',style: TextStyle(
                          fontFamily: "AppleSDGothicNeo",
                          fontSize: 12.0
                      ),),
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder:(_) => const FindFriend_TosendLetter()
                        )
                        );
                        print('잠긴 편지 작성하기');
                      },
                      trailing: Icon(Icons.arrow_forward,color:Colors.blue),
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }
}














