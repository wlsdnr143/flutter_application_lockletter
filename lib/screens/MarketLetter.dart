import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final imageList=[
  Image.asset('assets/images/letter2.jpg',fit:BoxFit.cover),
  Image.asset('assets/images/letter3.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/letter4.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/letter5.jpeg',fit:BoxFit.cover),
];

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

Widget _buildFamily(context){ // 오늘의 마켓 위젯
  return Container(
      padding:const EdgeInsets.all(15),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '가정의 달엔 편지 한 통',
                style: TextStyle(
                    color:  Color(0xff191919),
                    fontWeight: FontWeight.w600,
                    fontFamily: "NotoSansKR_Regular",
                    fontStyle:  FontStyle.normal,
                    fontSize: 20.0
                ),
                textAlign: TextAlign.left,
              ),
              TextButton(
                onPressed:(){
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
              Container(
                width:105,
                height: 90,
                child: Image.asset('assets/images/letter6.jpeg', fit: BoxFit.fitHeight),
              ),
              Container(
                width:105,
                height: 90,
                child: Image.asset('assets/images/letter9.jpeg', fit: BoxFit.fitHeight),
              ),
              Container(
                width:105,
                height: 90,
                child: Image.asset('assets/images/letter8.jpeg', fit: BoxFit.fitHeight),
              ),
            ],
          ),
        ],
      )
  );
}  


Widget _buildWant(context){ // 이런 라이터는 어때요? 위젯
  return Container(
      padding:const EdgeInsets.all(15),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                '소장욕구 자극하는 편지지',
                style: TextStyle(
                    color:  Color(0xff191919),
                    fontWeight: FontWeight.w600,
                    fontFamily: "NotoSansKR_Regular",
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
                    width: 155,
                    height:180,
                    color:Colors.grey,

                  ),
                  SizedBox(height:5),
                  const Text(
                      "꽃무늬 편지지                    ",
                      style: TextStyle(
                          color:Color(0xff191919),
                          fontWeight: FontWeight.w300,
                          fontFamily: "S-CoreDream-3",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left
                  ),
                  SizedBox(height:3),
                  Text(
                      "꽃무늬도 세련될 수 있다구요                \n진짜루",
                      style: TextStyle(
                          color: Color(0xff656565),
                          fontWeight: FontWeight.w300,
                          fontFamily: "SCDream4",
                          fontStyle: FontStyle.normal,
                          fontSize: 9.0
                      ),
                      textAlign: TextAlign.left
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                      width: 155,
                      height:180,
                      color:Colors.grey
                  ),
                  SizedBox(height:5),
                  const Text(
                      "땡땡이 편지지                     ",
                      style: TextStyle(
                          color:Color(0xff191919),
                          fontWeight: FontWeight.w300,
                          fontFamily: "S-CoreDream-3",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left
                  ),
                  SizedBox(height:3),
                  Text(
                      "물방울 무늬를 말하는 게 아닙니다          \n제가 땡땡이를 치고 싶다는 뜻입니다...",
                      style: TextStyle(
                          color: Color(0xff656565),
                          fontWeight: FontWeight.w300,
                          fontFamily: "SCDream4",
                          fontStyle: FontStyle.normal,
                          fontSize: 9.0
                      ),
                      textAlign: TextAlign.left
                  ),
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
                    width: 155,
                    height:180,
                    color:Colors.grey,

                  ),
                  SizedBox(height:5),
                  const Text(
                      "꽃무늬 편지지                    ",
                      style: TextStyle(
                          color:Color(0xff191919),
                          fontWeight: FontWeight.w300,
                          fontFamily: "S-CoreDream-3",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left
                  ),
                  SizedBox(height:3),
                  Text(
                      "꽃무늬도 세련될 수 있다구요                \n진짜루",
                      style: TextStyle(
                          color: Color(0xff656565),
                          fontWeight: FontWeight.w300,
                          fontFamily: "SCDream4",
                          fontStyle: FontStyle.normal,
                          fontSize: 9.0
                      ),
                      textAlign: TextAlign.left
                  ),
                ],
              ),

              Column( //4번째 사진 위젯
                children: <Widget>[
                  Container(
                      width: 155,
                      height:180,
                      color:Colors.grey
                  ),
                  SizedBox(height:5),
                  const Text(
                      "땡땡이 편지지                     ",
                      style: TextStyle(
                          color:Color(0xff191919),
                          fontWeight: FontWeight.w300,
                          fontFamily: "S-CoreDream-3",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left
                  ),
                  SizedBox(height:3),
                  Text(
                      "물방울 무늬를 말하는 게 아닙니다          \n제가 땡땡이를 치고 싶다는 뜻입니다...",
                      style: TextStyle(
                          color: Color(0xff656565),
                          fontWeight: FontWeight.w300,
                          fontFamily: "SCDream4",
                          fontStyle: FontStyle.normal,
                          fontSize: 9.0
                      ),
                      textAlign: TextAlign.left
                  ),
                ],
              ),
            ],
          ),
        ],
      )
  );
}  