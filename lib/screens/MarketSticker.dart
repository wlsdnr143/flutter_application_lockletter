import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final imageList=[
  Image.asset('assets/images/sticker.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/sticker1.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/sticker2.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/sticker3.jpeg',fit:BoxFit.cover),
];

class MarketSticker extends StatelessWidget {
  const MarketSticker({ Key? key }) : super(key: key);

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
        ]//action icon 변경
      ),
      body:ListView(
        children:<Widget>[
          _buildSliderBar(),
          _buildCutie(context),
          _buildDeco(context),
        ],
      ),
    );
  }
}

Widget _buildSliderBar(){ // 맨 위 슬라이드 위젯
  return Container(
      height:250,
      child:Stack(
          children:[
            Positioned(
                child: CarouselSlider(
                    options:CarouselOptions(
                        height:500,
                        autoPlay:true
                    ),
                    items: imageList.map((image){
                      return Builder(
                          builder:(BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:EdgeInsets.symmetric(horizontal:5.0),
                              child:ClipRRect(
                                borderRadius:BorderRadius.circular(0.0) ,
                                child: image,
                              ),
                            );
                          }
                      );
                    }).toList()
                )
            ),
          ]
      )
  );
} // 맨 위 슬라이드 위젯

Widget _buildCutie(context){ // 오늘의 마켓 위젯
  return Container(
    padding:const EdgeInsets.all(32),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '귀엽다 귀여워',
              style: TextStyle(
                color:  Color(0xff191919),
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
                //     builder:(_) => ()
                //   )
                // );
              },
              child:const Text(
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
               Ink(
                  width:90 ,
                  height:110,
                  decoration: BoxDecoration(
                    //shape:BoxShape.circle,
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: InkWell(
                    onTap:(){
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //     builder:(_) => ()
                      //   )
                      // );
                    },
                    child:Ink.image(
                      image: AssetImage('assets/images/sticker4.jpeg'),
                      
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Ink(
                  width:90 ,
                  height:110,
                  decoration: BoxDecoration(
                    shape:BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap:(){
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //     builder:(_) => ()
                      //   )
                      // );
                    },
                    child:Ink.image(
                      image: AssetImage('assets/images/sticker5.jpeg'),
                      
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Ink(
                  width:90 ,
                  height:110,
                  decoration: BoxDecoration(
                    shape:BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap:(){
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //     builder:(_) => ()
                      //   )
                      // );
                    },
                    child:Ink.image(
                      image: AssetImage('assets/images/sticker6.jpeg'),
                      
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    )
  );
}  


Widget _buildDeco(context){ // 이런 라이터는 어때요? 위젯
  return Container(
    padding:const EdgeInsets.all(32),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '깜찍뽀짝 데코 스티커',
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
                    width: 130,
                    height:150,
                    color:Colors.grey, 
                    
                ),
                Text(
                    "곰돌곰돌이",
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
                    "사랑스러운 곰돌이 스티커 모음",
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
                    width: 130,
                    height:150,
                    color:Colors.grey
                ),
                Text(
                    "토끼토땡이",
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
                    "사실 난 곰이 아니라 토끼 ",
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
                    width: 130,
                    height:150,
                    color:Colors.grey, 
                    
                ),
                Text(
                    "곰돌곰돌이",
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
                    "70년간 꼼꼼히 작성했던 가계부가 아",
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
                    width: 130,
                    height:150,
                    color:Colors.grey
                ),
                Text(
                    "토끼토깽이",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
                    ),
                    textAlign: TextAlign.left
                ),
                const Text(
                    "제가 대학생이었을 때, 연애편지를 써준 친구들 중 잘 안된 ",
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