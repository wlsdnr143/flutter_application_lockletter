//여기다가 Setting 페이지 제작

import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0.0,
          centerTitle: false,
          title: const Text(
            '    설정',
            style: TextStyle(color:Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
              child: Column(
                  children: <Widget>[
                    ListTile(
                        title : Text('고객센터', style: TextStyle(color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontFamily: "NotoSansKR_Regular",),),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      title : Text('FAQ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "NotoSansKR_Regular",
                        ),),
                      onTap: (){}
                        ),
                    ListTile(
                        title : Text('개인정보수집 안내',style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "NotoSansKR_Regular",
                        ),
                        ),
                        onTap: (){}
                    ),
                    ListTile(
                        title : Text('앱 문의',style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "NotoSansKR_Regular",
                        ),),
                        onTap: (){}
                    ),
                    ListTile(
                        title : Text('문의 내역',style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "NotoSansKR_Regular",
                        ),),
                        onTap: (){}
                    ),
                    SizedBox(height:30),
                    ListTile(
                      title: Text('설정',
                      style: TextStyle(color:Colors.black54,fontWeight: FontWeight.normal,
                        fontFamily: "NotoSansKR_Regular",),
                      ),
                    ),
                    SizedBox(height:5),
                    ListTile(
                        title : Text('설정',style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "NotoSansKR_Regular",
                        ),),
                        onTap: (){}
                    ),
                    ListTile(
                        title : Text('앱 버전',style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "NotoSansKR_Regular",
                        ),),
                        onTap: (){}
                    ),
              ])
          ),
        )
    );
  }
}
