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
    padding:const EdgeInsets.all(32),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '오늘의 글씨체',
              style: TextStyle(
                color:  Color(0xff191919),
                fontWeight: FontWeight.w400,
                fontFamily: "AppleSDGothicNeo",
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
                    image: AssetImage('assets/images/hand5.jpeg'),
                    width:90,
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
                    image: AssetImage('assets/images/hand6.jpeg'),
                    width:90,
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
                    image: AssetImage('assets/images/hand7.jpeg'),
                    width:90,
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
          children: const [
            Text(
              '감성가득 필체 여기 다 있다',
              style: TextStyle(
                color:  Color(0xff191919),
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
                const Text(
                    "유범체",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
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
                const Text(
                    "미리내체",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
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
                    width: 130,
                    height:150,
                    color:Colors.grey, 
                    
                ),
                const Text(
                    "승은체",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
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
                const Text(
                    "",
                    style: TextStyle(
                        color:Color(0xff191919),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 15.0
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