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
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 0.0),
              child: Column(
                  children: <Widget>[
                    Text(
                      '고객센터                                                                           ',
                      style: TextStyle(color:Colors.black54),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title : Text('FAQ'),
                      onTap: (){}
                        ),
                    ListTile(
                        title : Text('개인정보수집 안내'),
                        onTap: (){}
                    ),
                    ListTile(
                        title : Text('앱 문의'),
                        onTap: (){}
                    ),
                    ListTile(
                        title : Text('문의 내역'),
                        onTap: (){}
                    ),
                    SizedBox(height:50),
                    Text(
                      '설정                                                                                 ',
                      style: TextStyle(color:Colors.black54),
                    ),
                    SizedBox(height:10),
                    ListTile(
                        title : Text('설정'),
                        onTap: (){}
                    ),
                    ListTile(
                        title : Text('앱 버전'),
                        onTap: (){}
                    ),
              ])
          ),
        )
    );
  }
}
