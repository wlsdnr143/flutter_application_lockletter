import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Column(children: <Widget>[
                Center(
                  child: Image.asset('assets/images/before_login.png', fit:BoxFit.fill),
                ),
                SizedBox(height: 200),
                Image.asset('assets/images/before_login.png'),
                //Image.asset('assets/letter2.PNG'),
              ])
          ),
        )
    );
  }
}
