//ignore_for_file:prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttergooglesignin/providers/profile_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../allConstants/color_constants.dart';
import '../allConstants/size_constants.dart';
import '../allConstants/text_field_constants.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../utilities/debouncer.dart';
import 'MarketLetter.dart';
import 'MarketSticker.dart';
import 'SelectLetter.dart';
import 'SelectPerson_showMail.dart';
import 'login_page.dart';
import 'MarketWriter.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

final imageList=[
  Image.asset('assets/images/banner1.jpeg',fit:BoxFit.cover),
  Image.asset('assets/images/banner2.png',fit:BoxFit.cover),
  Image.asset('assets/images/banner3.jpg',fit:BoxFit.cover),
  Image.asset('assets/images/banner4.png',fit:BoxFit.cover),
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController scrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = ""; // Dart 언어에서는 식별자 이름 앞에 _(underbar)를 붙이면 Private으로 자동적용
  bool isLoading = false;

  late AuthProvider authProvider;
  late String currentUserId;
  late HomeProvider homeProvider;
  late ProfileProvider profileProvider;

  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchTextEditingController = TextEditingController();

  Future<void> googleSignOut() async {
    authProvider.googleSignOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SimpleDialog(
            backgroundColor: AppColors.burgundy,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Exit Application',
                  style: TextStyle(color: AppColors.white),
                ),
                Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.dimen_10),
            ),
            children: [
              vertical10,
              const Text(
                'Are you sure?',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: AppColors.white, fontSize: Sizes.dimen_16),
              ),
              vertical15,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 0);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Sizes.dimen_8),
                      ),
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: AppColors.spaceCadet),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    buttonClearController.close();
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    homeProvider = context.read<HomeProvider>();
    profileProvider = context.read<ProfileProvider>();
    profileProvider.init();
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }

    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation:0.0,
            centerTitle: true,
            title: const Text(
              '잠긴편지',
              style: TextStyle(
                fontSize: 18,
                  color:  Colors.black,
                  fontWeight: FontWeight.normal,
                  fontFamily: "SANGJU",
              ),
            ),
            // leading: IconButton( // 로그아웃하는 버튼 누르면 login_page로 돌아감
            //     onPressed: () {
            //       Navigator.push(
            //           context, MaterialPageRoute(
            //           builder:(_) => SelectPerson_test())
            //       );
            //     },
            //     color: Colors.black,
            //     icon: const Icon(Icons.local_post_office_outlined)),
            leading: IconButton( // 로그아웃하는 버튼 누르면 login_page로 돌아감
                  onPressed: () => googleSignOut(),
                  color: Colors.black,
                  icon: const Icon(Icons.logout)),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder:(_) => SelectPerson_showMail())
                    );
                  },
                  color: Colors.black,
                  icon: const Icon(Icons.local_post_office_outlined)),
              IconButton(
                  onPressed: (){},
                  color: Colors.black,
                  icon: const Icon(Icons.add_reaction_outlined)),

            ]),
      body:Container(
        child: ListView(
          children:<Widget>[
            _buildSliderBar(),
            _buildSendLetter(context),
            _buildMarket(context),
            _buildLetterList(context),
            _buildWriter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderBar(){ // 맨 위 슬라이드 위젯
    return Container(
        height:250,
        child:Stack(
            children:[
              Positioned(
                  child: CarouselSlider(
                      options:CarouselOptions(
                          height:200,
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
              Positioned(
                  top:180,
                  child: Column(
                    children: const [
                      Text(
                        "        깊이 잠긴 마음 담아.",
                        style: TextStyle(
                            color:  Color(0xff191919),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Ghana',
                            fontStyle:  FontStyle.normal,
                            fontSize: 30.0
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                          "당신께 천천히 눌러쓴 추억을 보내요",
                          style: TextStyle(
                              color:  Color(0xff191919),
                              fontWeight: FontWeight.w400,
                              fontFamily: "AppleSDGothicNeo",
                              fontStyle:  FontStyle.normal,
                              fontSize: 15.0
                          ),
                          textAlign: TextAlign.left
                      )
                    ],
                  )
              )
            ]
        )
    );
  } // 맨 위 슬라이드 위젯

  Widget _buildSendLetter(context){ // 편지 보내기 버튼
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
      child: Container(
        width:150,
        height:80,
        child:Card(
          child: Column(
            children: [
              ListTile(
                dense:false,
                title: Row(
                  children: const [
                    Text(
                      '특별한 글씨체로 ',
                      style: TextStyle(
                          fontFamily:"AppleSDGothicNeo",
                          fontSize:17,
                          fontWeight:FontWeight.w600,
                          fontStyle: FontStyle.normal
                      ),
                    ),
                    Text(
                      '잠긴편지 ',
                      style: TextStyle(
                          fontFamily:"BMO",
                          fontSize:15,
                          fontWeight:FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Colors.blue
                      ),
                    ),
                    Text(
                      '작성하기',
                      style: TextStyle(
                          fontFamily:"AppleSDGothicNeo",
                          fontSize:17,
                          fontWeight:FontWeight.w600,
                          fontStyle: FontStyle.normal
                      ),
                    ),
                  ],
                ),
                subtitle:Text(
                  '미래로 보내는 정성 가득 손편지',
                  style: TextStyle(
                      fontFamily:"AppleSDGothicNeo",
                      fontSize:11,
                      fontWeight:FontWeight.w600,
                      fontStyle: FontStyle.normal
                  ),
                ),
                onTap: (){
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder:(_) => SelectLetter()
                  )
                  );
                },
                trailing: Icon(Icons.arrow_forward,color:Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  } // 편지 보내기 버튼

  Widget _buildMarket(context){ // 오늘의 마켓 위젯
    return Container(
        padding:const EdgeInsets.all(10),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '오늘의 마켓',
                  style: TextStyle(
                      color:  const Color(0xff191919),
                      fontWeight: FontWeight.w600,
                      fontFamily: "NotoSansKR_Regular",
                      fontStyle:  FontStyle.normal,
                      fontSize: 22.0
                  ),
                  textAlign: TextAlign.left,
                ),
                TextButton(
                  onPressed:(){
                    // Navigator.push(
                    //     context, MaterialPageRoute(
                    //     builder:(_) => (Market())
                    // )
                    // );
                  },
                  child:Text(
                    '더보기',
                    style: TextStyle(
                        color: Color(0xff7b7b7b),
                        fontWeight: FontWeight.w400,
                        fontFamily:"AppleSDGothicNeo",
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder:(_) => (MarketWriter())
                          )
                          );
                        },
                        child:Ink.image(
                          image: AssetImage('assets/images/handwrite.jpeg'),
                          width:110,
                          height:90,
                        )
                    ),

                    Text(
                        "감성필체            ",
                        style: TextStyle(
                            color:Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "SCDream3",
                            fontStyle:  FontStyle.normal,
                            fontSize: 15.0
                        ),
                        textAlign: TextAlign.left
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder:(_) => (MarketLetter())
                          )
                          );
                        },
                        child:Ink.image(
                          image: AssetImage('assets/images/letter1.jpg'),
                          width:110,
                          height:90,
                        )
                    ),
                    Text(
                        "깜찍편지지          ",
                        style: TextStyle(
                            color:Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "SCDream3",
                            fontStyle:  FontStyle.normal,
                            fontSize: 15.0
                        ),
                        textAlign: TextAlign.left
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder:(_) => (MarketSticker())
                          )
                          );
                        },
                        child:Ink.image(
                          image: AssetImage('assets/images/sticker1.jpeg'),
                          width:110,
                          height:90,
                        )
                    ),
                    Text(
                        "스티커            ",
                        style: TextStyle(
                            color:Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "SCDream3",
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
  } // 오늘의 마켓 위젯

  Widget _buildLetterList(context){ //받은 편지 리스트 위젯
    return Container(
        padding:const EdgeInsets.all(10),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'D-Day',
                      style: TextStyle(
                          color:  const Color(0xff191919),
                          fontWeight: FontWeight.w600,
                          fontFamily: "NotoSansKR_Regular",
                          fontStyle:  FontStyle.normal,
                          fontSize: 22.0
                      ),
                      textAlign: TextAlign.left,
                    ),
                    TextButton(
                      onPressed:(){
                        Navigator.push(
                            context, MaterialPageRoute(
                            //builder:(_) => (SelectPerson_showMail())
                            builder:(_) => (SelectPerson_showMail())
                        )
                        );
                      },
                      child:Text(
                        '우체통 전체보기',
                        style: TextStyle(
                            color: Color(0xff7b7b7b),
                            fontWeight: FontWeight.w400,
                            fontFamily:"AppleSDGothicNeo",
                            fontStyle: FontStyle.normal,
                            fontSize: 13.0
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ]
              ),
              Column(
                  children: [
                    Container(
                        margin:const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(5),
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                            color: Color(0xfff1f1f5),
                            //color: Color(0xfff1f1f5),
                        ),
                        child:Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height:50,
                                  width:50,
                                  decoration:BoxDecoration(
                                      image:DecorationImage(
                                          image:AssetImage('assets/images/invalid_name.png')
                                      )
                                  )
                              ),
                              Container(
                                child:Column(
                                  children: const [
                                    Text(
                                        "2021.01.01",
                                        textAlign: TextAlign.left,
                                        style:TextStyle(
                                            color:Color(0xff000000),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "SeoulNamsanEB",
                                            fontStyle: FontStyle.normal
                                        )
                                    ),
                                    Text(
                                        "From. 채원  ",
                                        style:TextStyle(
                                            color:Color(0xff000000),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "SeoulNamsanM",
                                            fontStyle: FontStyle.normal
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  '너는 이 편지를 1년 뒤에 읽겠지?',
                                  style:TextStyle(
                                      color:Colors.black45,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SeoulNamsanM",
                                      fontStyle: FontStyle.normal
                                  )

                              ),
                              Text(
                                  'D-365     ',
                                  style:TextStyle(
                                      color:Color(0xff767676),
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SeoulNamsanM",
                                      fontStyle: FontStyle.normal
                                  )
                              ),
                            ]
                        )
                    ),
                    Container(
                        margin:const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(5),
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: Color(0xfff1f1f5),
                          //color: Color(0xfff1f1f5),
                        ),
                        child:Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height:50,
                                  width:50,
                                  decoration:BoxDecoration(
                                      image:DecorationImage(
                                          image:AssetImage('assets/images/invalid_name.png')
                                      )
                                  )
                              ),
                              Container(
                                child:Column(
                                  children: const [
                                    Text(
                                        "2021.01.01",
                                        textAlign: TextAlign.left,
                                        style:TextStyle(
                                            color:Color(0xff000000),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "SeoulNamsanEB",
                                            fontStyle: FontStyle.normal
                                        )
                                    ),
                                    Text(
                                        "From. 도진  ",
                                        style:TextStyle(
                                            color:Color(0xff000000),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "SeoulNamsanM",
                                            fontStyle: FontStyle.normal
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  '너는 이 편지를 1년 뒤에 읽겠지?',
                                  style:TextStyle(
                                      color:Colors.black45,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SeoulNamsanM",
                                      fontStyle: FontStyle.normal
                                  )

                              ),
                              Text(
                                  'D-365     ',
                                  style:TextStyle(
                                      color:Color(0xff767676),
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SeoulNamsanM",
                                      fontStyle: FontStyle.normal
                                  )
                              ),
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
                    Container(
                        margin:const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(5),
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: Color(0xfff1f1f5),
                          //color: Color(0xfff1f1f5),
                        ),
                        child:Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height:50,
                                  width:50,
                                  decoration:BoxDecoration(
                                      image:DecorationImage(
                                          image:AssetImage('assets/images/invalid_name.png')
                                      )
                                  )
                              ),
                              Container(
                                child:Column(
                                  children: const [
                                    Text(
                                        "2021.01.01",
                                        textAlign: TextAlign.left,
                                        style:TextStyle(
                                            color:Color(0xff000000),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "SeoulNamsanEB",
                                            fontStyle: FontStyle.normal
                                        )
                                    ),
                                    Text(
                                        "From. 혜린  ",
                                        style:TextStyle(
                                            color:Color(0xff000000),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "SeoulNamsanM",
                                            fontStyle: FontStyle.normal
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  '너는 이 편지를 1년 뒤에 읽겠지?',
                                  style:TextStyle(
                                      color:Colors.black45,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SeoulNamsanM",
                                      fontStyle: FontStyle.normal
                                  )

                              ),
                              Text(
                                  'D-365     ',
                                  style:TextStyle(
                                      color:Color(0xff767676),
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SeoulNamsanM",
                                      fontStyle: FontStyle.normal
                                  )
                              ),
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
    );
  } //받은 편지 리스트 위젯

  Widget _buildWriter(context) { // 이런 라이터는 어때요 위젯

    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '이런 라이터는 어때요',
                  style: TextStyle(
                      color: Color(0xff191919),
                      fontWeight: FontWeight.w600,
                      fontFamily: "NotoSansKR_Regular",
                      fontStyle: FontStyle.normal,
                      fontSize: 22.0
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width:170,
                      height: 120,
                      child: Image.asset('assets/images/handwrite.jpeg', fit: BoxFit.fitWidth),
                    ),
                    SizedBox(height:5),
                    Text(
                        "유범체                       ",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "SCDream4",
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    SizedBox(height:5),
                    Text(
                        "70년간 꼼꼼히 작성했던 가계부가 아이들   \n사이에서 화제가 된적이 있었죠",
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
                      width:170,
                      height: 120,
                      child: Image.asset('assets/images/handwrite.jpeg', fit: BoxFit.fitWidth),
                    ),
                    SizedBox(height:5),
                    Text(
                        "미리내체                    ",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w500,
                            fontFamily: "SCDream4",
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    SizedBox(height:5),
                    Text(
                        "70년간 꼼꼼히 작성했던 가계부가 아이들   \n사이에서 화제가 된적이 있었죠",
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width:170,
                      height: 120,
                      child: Image.asset('assets/images/handwrite.jpeg', fit: BoxFit.fitWidth),
                    ),
                    SizedBox(height:5),
                    Text(
                        "승은체                       ",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "SCDream4",
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    SizedBox(height:5),
                    Text(
                        "70년간 꼼꼼히 작성했던 가계부가 아이들   \n사이에서 화제가 된적이 있었죠",
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
                    InkWell(
                        // onTap:(){
                        //   Navigator.push(
                        //       context, MaterialPageRoute(
                        //       builder:(_) => (MarketLetter())
                        //   )
                        //   );
                        // },
                        child:Ink.image(
                          image: AssetImage('assets/images/'),
                          width:170,
                          height:120,
                        )
                    ),
                    Text(
                        "",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "AppleSDGothicNeo",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        "",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "AppleSDGothicNeo",
                            fontStyle: FontStyle.normal,
                            fontSize: 6.0
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
  }  // 이런 라이터는 어때요? 위젯
}
