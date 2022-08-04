import 'package:flutter/material.dart';

class PostBox extends StatelessWidget {
  const PostBox({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length:4,
        child:Scaffold(
            appBar:AppBar(
              backgroundColor:Colors.white,
              title:const Text(
                  '우체통',
                  style:TextStyle(
                      color:Colors.black,
                      fontWeight:FontWeight.w500,
                      fontFamily:"NotoSansCJKKR",
                      fontSize:25.0
                  )
              ),
              bottom:const TabBar(
                  tabs:<Widget>[
                    Tab(
                      child:Text(
                          '받은편지함',
                          style:TextStyle(
                              color:Colors.black,
                              fontSize:13.0
                          )
                      ),
                    ),
                    Tab(
                      child:Text(
                          '보낸편지함',
                          style:TextStyle(
                              color:Colors.black,
                              fontSize:13.0
                          )
                      ),
                    ),
                    Tab(
                      child:Text(
                          '내게 쓴 편지',
                          style:TextStyle(
                              color:Colors.black,
                              fontSize:11.0
                          )
                      ),
                    ),
                    Tab(
                      child:Text(
                          '즐겨찾기',
                          style:TextStyle(
                              color:Colors.black,
                              fontSize:13.0
                          )
                      ),
                    )
                  ]
              ),
            ),
            body:TabBarView(
                children:<Widget>[
                  _buildLetterList1(),
                  _buildLetterList2(),
                  _buildLetterList3(),
                  _buildLetterList4()
                ]
            )
        )
    );
  }
}




//기존에 텍스트랑 이미지랑 중구난방하게 되어 있던 부분들 Container안에다가 위젯들 다 넣어서 재배치 했음 .
//하나만 바꾼게 아니라 전부다 바꿔서 하나하나 굳이 표시는 안함.


Widget _buildLetterList1(){ //받은 편지함 리스트 위젯
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          padding:const EdgeInsets.all(20),
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '열린 편지',
                        style: TextStyle(
                            color:  Color(0xff191919),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKKR",
                            fontStyle:  FontStyle.normal,
                            fontSize:20.0
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextButton(
                        onPressed:(){
                          //Navigator.push(
                          // context, MaterialPageRoute(
                          //   builder:(_) => (PostBox())
                          // )
                          //);
                        },
                        child:const Text(
                          '전체보기',
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
                    ]
                ),
                Column(
                    children:[
                      Container(
                          margin:const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:Border.all(color:Colors.black12, width:1)
                          ),
                          child:Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child:Column(
                                    children: const [
                                      Text(
                                          "From.채원(@chaerycoc)",
                                          style:TextStyle(
                                              color:Color(0xff000000),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SeoulNamsanC-M",
                                              fontStyle: FontStyle.normal
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //     width:40
                                // ),
                                // Container(
                                //     child:Column(
                                //       crossAxisAlignment:CrossAxisAlignment.end,
                                //       children: const [
                                //         Text(
                                //             '받은날: 21.01.01',
                                //             style:TextStyle(
                                //                 color:Color(0xff767676),
                                //                 fontSize:8.0
                                //             )
                                //         ),
                                //         Text(
                                //             '개봉일: 22.02.25',
                                //             style:TextStyle(
                                //                 color:Color(0xff767676),
                                //                 fontSize:8.0
                                //             )
                                //         )
                                //       ],
                                //     )
                                // )
                              ]
                          )
                      ),
                    ]
                )
              ]
          )
      ),
      const SizedBox(height:10,)
    ],
  );
}

Widget _buildLetterList2(){ //받은 편지 리스트 위젯
  return Column();
}



Widget _buildLetterList3(){ //받은 편지 리스트 위젯
  return Column(

  );
}


Widget _buildLetterList4(){ //받은 편지 리스트 위젯
  return Column(

  );
}