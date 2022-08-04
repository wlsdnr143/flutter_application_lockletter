import 'package:flutter/material.dart';

class MarketLetter extends StatelessWidget {
  const MarketLetter({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        
        centerTitle: true,
        title: Text(
          '잠긴편지',
          style: TextStyle(color:Colors.black),
        ),
        leading:
        IconButton(
          color:Colors.black,
          icon:Icon(Icons.mood),
          iconSize:20,
          onPressed:()=>print('')
        ),//appbar에 leading icon 추가
        actions:<Widget>[
          IconButton(
            icon:Icon(Icons.work, size:20),
            color:Colors.black,
            onPressed: (){
              showDialog(context:context,builder:(context){
                return AlertDialog(
                  content: Text("개발중")
                );
              });
            },
          ),
          // IconButton(
          //   icon:Icon(Icons.insert_invitation,size:20),
          //   color:Colors.black,
          //   onPressed: (){
          //     showDialog(context: context, builder:(context){
          //       return AlertDialog(
          //         content: Text("슬로비짱"),
          //       );
          //     });
          //     Navigator.push(
          //       context, MaterialPageRoute(
          //         builder:(_) => Calendar()
          //       )
          //     );
          //   },
          // ),
        ]//action icon 변경
      ),
      body:ListView(
        children:<Widget>[
          _buildSliderBar(),
          _buildFamily(context),
          _buildWant(context),
        ],
      ),
    );
  }
}

Widget _buildSliderBar(){
  return Container(
    height:400,
    color:Colors.grey
  );
}

Widget _buildFamily(context){ // 오늘의 마켓 위젯
  return Container(
    padding:const EdgeInsets.all(32),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '가정의 달엔 편지 한 통',
              style: TextStyle(
                color:  const Color(0xff191919),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansCJKKR",
                fontStyle:  FontStyle.normal,
                fontSize: 20.0
              ),
              textAlign: TextAlign.left,
            ),
            TextButton(
              onPressed:(){
                // Navigator.push(
                //   context, MaterialPageRoute(
                //     builder:(_) => (Market())
                //   )
                // );
              },
              child:Text(
                '더보기',
                style: TextStyle(
                  color: Color(0xff7b7b7b),
                  fontWeight: FontWeight.w400,
                  fontFamily:"AppleSDGothicNeo",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0
                ),
                textAlign: TextAlign.left,
              ),
            )  
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap:(){
                    // Navigator.push(
                    //   context, MaterialPageRoute(
                    //     builder:(_) => (Market())
                    //   )
                    // );
                  },
                  child:Ink.image(
                    image: AssetImage(''),
                    width:130,
                    height:110,
                  )
                )
              ],
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap:(){
                    // Navigator.push(
                    //   context, MaterialPageRoute(
                    //     builder:(_) => (Market())
                    //   )
                    //);
                  },
                  child:Ink.image(
                    image: AssetImage(''),
                    width:130,
                    height:110,
                  )
                ),
              ],
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap:(){
                    // Navigator.push(
                    //   context, MaterialPageRoute(
                    //     builder:(_) => (Market())
                    //   )
                    // );
                  },
                  child:Ink.image(
                    image: AssetImage(''),
                    width:130,
                    height:110,
                  )
                ),
              ],
            ),
          ],
        ),
      ],
    )
  );
}  


Widget _buildWant(context){ // 이런 라이터는 어때요? 위젯
  return Container(
    padding:const EdgeInsets.all(32),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '소장욕구 자극하는 편지지',
              style: TextStyle(
                color:  const Color(0xff191919),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansCJKKR",
                fontStyle:  FontStyle.normal,
                fontSize: 20.0
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: 200,
                    height:200,
                    color:Colors.grey, 
                    
                ),
                Text(
                    "꽃무늬 편지지",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
                    ),
                    textAlign: TextAlign.left
                ),
                Text(
                    "70년간 꼼꼼히 작성했던 가계부가 아이들 사이에서 화제가 된적이 있었죠",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 5.0
                    ),
                    textAlign: TextAlign.left
                ),

              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    width: 200,
                    height:200,
                    color:Colors.grey
                ),
                Text(
                    "땡땡이편지지",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
                    ),
                    textAlign: TextAlign.left
                ),
                Text(
                    "제가 대학생이었을 때, 연애편지를 써준 친구들 중 잘 안된 사람이 없었어요 ",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 5.0
                    ),
                    textAlign: TextAlign.left
                )
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: 200,
                    height:200,
                    color:Colors.grey, 
                    
                ),
                Text(
                    "꽃무늬편지지",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
                    ),
                    textAlign: TextAlign.left
                ),
                Text(
                    "70년간 꼼꼼히 작성했던 가계부가 아이들 사이에서 화제가 된적이 있었죠",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 5.0
                    ),
                    textAlign: TextAlign.left
                ),
              ],
            ),

            Column(
              children: <Widget>[
                Container(
                    width: 200,
                    height:200,
                    color:Colors.grey
                ),
                Text(
                    "땡떙이편지지",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
                    ),
                    textAlign: TextAlign.left
                ),
                Text(
                    "제가 대학생이었을 때, 연애편지를 써준 친구들 중 잘 안된 사람이 없었어요 ",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 5.0
                    ),
                    textAlign: TextAlign.left
                )
              ],
            ), 
          ],
        ),
      ],
    )
  );
}  