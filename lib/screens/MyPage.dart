import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          backgroundColor:Colors.white,
          title:const Text(
              "마이페이지",
              style: TextStyle(
                  color: Color(0xff191919),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansCJKKR",
                  fontStyle:  FontStyle.normal,
                  fontSize: 20.0
              ),
              textAlign: TextAlign.left
          ),
          elevation:0.0,
          actions: <Widget>[
            IconButton(
              icon:const Icon(Icons.money),
              color: Colors.black,
              onPressed: (){
                print('???');
              },
            ),
          ],
        ),
        body:Column(
          children:<Widget>[
            SizedBox(height:20),
            _buildTop(),
            _buildMiddle(),
            _buildBottom(),
            _buildFourth()
          ],
        )
    );
  }

  Widget _buildTop(){
    return Container(
        child:Row(
            children:[
              const SizedBox(width: 10),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage:AssetImage(''),
                radius:20.0,
              ),
              const SizedBox(width:10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:const [
                    Text(
                      '@slowbe',
                      style: TextStyle(
                          color:  Color(0xff433e50),
                          fontWeight: FontWeight.w700,
                          fontFamily: "NotoSansCJKKR",
                          fontStyle:  FontStyle.normal,
                          fontSize: 25.0
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '잠긴 글자: 1,365자',
                      style: TextStyle(
                          color:Color(0xff999999),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansCJKKR",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '보낸 편지 수: 88장',
                      style: TextStyle(
                          color:Color(0xff999999),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansCJKKR",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left,
                    )
                  ]
              )
            ]
        )
    );
  }
}
Widget _buildMiddle(){
  return ListView(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    padding:EdgeInsets.zero,
    children: <Widget>[
      Card(
        child:ListTile(
          title: const Text(
              '잠긴편지 보내기',
              style: TextStyle(
                  color:Color(0xff433e50),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansCJKKR",
                  fontStyle:FontStyle.normal,
                  fontSize: 20.0
              ),
              textAlign: TextAlign.left
          ),
          onTap: (){
            print('잠긴편지보내기');
          },
          trailing: const Icon(Icons.add,color:Colors.blue),
        ),
      ),
      Card(
        child:ListTile(
          title: Text(
              '친구 목록 관리',
              style: TextStyle(
                  color:Color(0xff433e50),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansCJKKR",
                  fontStyle:FontStyle.normal,
                  fontSize: 20.0
              ),
              textAlign: TextAlign.left
          ),
          onTap: (){
            print('친구 목록 관리');
          },
          trailing: Icon(Icons.add,color:Colors.blue),
        ),
      ),
      Card(
        child:ListTile(
          title: const Text(
              '구매 목록 관리',
              style: TextStyle(
                  color:Color(0xff433e50),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansCJKKR",
                  fontStyle:FontStyle.normal,
                  fontSize: 20.0
              ),
              textAlign: TextAlign.left
          ),
          onTap: (){
            print('구매 목록 관리');
          },
          trailing: Icon(Icons.add,color:Colors.blue),
        ),
      ),
      SizedBox(height:10),
    ],
  );
}
Widget _buildBottom(){
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:<Widget>[
        Text(
          '즐겨찾는 필체',
          style: TextStyle(
              color:  const Color(0xff000000),
              fontWeight: FontWeight.w400,
              fontFamily: "",
              fontStyle:  FontStyle.normal,
              fontSize: 20.0
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: 70,
                    height:70,
                    child:Image(
                      image:AssetImage('assets/images/before_login.png'),
                    )
                ),
                Text(
                    "김채원체",
                    style: TextStyle(
                        color:Color(0xff000000),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 18.0
                    ),
                    textAlign: TextAlign.left
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    width: 70,
                    height:70,
                    child:Image(
                      image:AssetImage('assets/images/before_login.png'),
                    )
                ),
                const Text(
                    "방진욱체",
                    style: TextStyle(
                        color:Color(0xff000000),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 18.0
                    ),
                    textAlign: TextAlign.left
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    width: 70,
                    height:70,
                    child:const Image(
                      image:AssetImage('assets/images/before_login.png'),
                    )
                ),
                const Text(
                    "장도진체",
                    style: TextStyle(
                        color:Color(0xff000000),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 18.0
                    ),
                    textAlign: TextAlign.left
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    width: 70,
                    height:70,
                    child:const Image(
                      image:AssetImage('assets/images/before_login.png'),
                    )
                ),
                const Text(
                    "유혜린체",
                    style: TextStyle(
                        color:Color(0xff000000),
                        fontWeight: FontWeight.w300,
                        fontFamily: "S-CoreDream-3",
                        fontStyle:  FontStyle.normal,
                        fontSize: 18.0
                    ),
                    textAlign: TextAlign.left
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        const VerticalDivider(
            color: Color.fromARGB(255, 211, 211, 211),
            thickness: 1.0),
      ]
  );

}

Widget _buildFourth(){
  return Column(
      children:const <Widget>[
        ListTile(
            title: Text(
                'FAQ',
                style: TextStyle(
                    color: Color(0xff767676),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSansCJKKR",
                    fontStyle:  FontStyle.normal,
                    fontSize: 20.0
                ),
                textAlign:TextAlign.left
            )
        ),
        ListTile(
            title: Text(
                '개인정보수집안내',
                style: TextStyle(
                    color: Color(0xff767676),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSansCJKKR",
                    fontStyle:  FontStyle.normal,
                    fontSize: 20.0
                ),
                textAlign:TextAlign.left
            ),
        ),

      ]
  );
}


