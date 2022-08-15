import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final imageList=[
  Image.asset('assets/images/hand1.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/hand2.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/hand3.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/hand4.jpeg',fit:BoxFit.cover),
];

class MarketWriter extends StatelessWidget {
  const MarketWriter({ Key? key }) : super(key: key);

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
              '오늘의 라이터',
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
              child: Image.asset('assets/images/hand5.jpeg', fit: BoxFit.fitHeight),
            ),
            Container(
              width:105,
              height: 90,
              child: Image.asset('assets/images/hand6.jpeg', fit: BoxFit.fitHeight),
            ),
            Container(
              width:105,
              height: 90,
              child: Image.asset('assets/images/hand7.jpeg', fit: BoxFit.fitHeight),
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
              '감성가득 필체 여기 다 있다',
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
                    width: 160,
                    height:130,
                    color:Colors.grey, 
                    
                ),
                SizedBox(height:5),
                const Text(
                    "유범체                                 ",
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
                    "70년간 꼼꼼히 작성했던 가계부가 아이들\n사이에서 화제가 된적이 있었죠",
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
                    width: 160,
                    height:130,
                    color:Colors.grey
                ),
                SizedBox(height:5),
                const Text(
                    "미리내체                             ",
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
                    "70년간 꼼꼼히 작성했던 가계부가 아이들\n사이에서 화제가 된적이 있었죠",
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
                  width: 160,
                  height:130,
                    color:Colors.grey, 
                    
                ),
                SizedBox(height:5),
                const Text(
                    "승은체                                 ",
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
                const Text(
                    "70년간 꼼꼼히 작성했던 가계부가 아이들\n사이에서 화제가 된적이 있었죠",
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

            // Column( //4번째 사진 위젯
            //   children: <Widget>[
            //     Container(
            //         width: 160,
            //         height:130,
            //         color:Colors.grey
            //     ),
            //     const Text(
            //         "",
            //         style: TextStyle(
            //             color:Color(0xff191919),
            //             fontWeight: FontWeight.w300,
            //             fontFamily: "S-CoreDream-3",
            //             fontStyle:  FontStyle.normal,
            //             fontSize: 15.0
            //         ),
            //         textAlign: TextAlign.left
            //     ),
            //     Text(
            //         "",
            //         style: TextStyle(
            //             color: Color(0xff656565),
            //             fontWeight: FontWeight.w300,
            //             fontFamily: "SCDream4",
            //             fontStyle: FontStyle.normal,
            //             fontSize: 9.0
            //         ),
            //         textAlign: TextAlign.left
            //     ),
            //   ],
            // ),
          ],
        ),
      ],
    )
  );
}  