import 'package:flutter/material.dart';
import 'WriteLetter.dart';

class SelectRelease extends StatefulWidget {
  const SelectRelease({ Key? key }) : super(key: key);

  @override
  State<SelectRelease> createState() => _SelectReleaseState();
}

class _SelectReleaseState extends State<SelectRelease> {
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
      ),
      body:Column(
        children: [
          const SizedBox(height: 50),
          TextFormField(
            cursorColor: Theme.of(context).cursorColor,
            maxLength: 20,
            decoration: const InputDecoration(
              icon:Icon(Icons.person),
              labelText:'받는사람',
              // helperText: '@태정태세비욘세',
              suffixIcon: Icon(Icons.check_circle
              )
            )
          ),
          TextFormField(
            cursorColor: Theme.of(context).cursorColor,
            initialValue: 'Input text',
            maxLength: 20,
            decoration: const InputDecoration(
              icon:Icon(Icons.calendar_view_month),
              labelText:'잠금해제날짜',
              helperText: '편지의 잠금이 풀릴 날짜를 선택해주세요.',
              suffixIcon: Icon(Icons.check_circle
              )
            )
          ),
          SizedBox(height:50),
          Container(
            height: 200,
            padding: EdgeInsets.all(20),
            child:ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(
                    builder:(_) => WriteLetter()
                  )
                );
              },
              style: ElevatedButton.styleFrom(
                primary:Colors.blue,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                elevation: 10.0,
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  '잠긴편지 설정 완료'
                )
              ),   
            )
          )
        ],
      )
    ); 
  }
}
      
    