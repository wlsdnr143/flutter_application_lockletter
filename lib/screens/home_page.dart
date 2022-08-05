//ignore_for_file:prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergooglesignin/screens/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../allConstants/color_constants.dart';
import '../allConstants/firestore_constants.dart';
import '../allConstants/size_constants.dart';
import '../allConstants/text_field_constants.dart';
import '../allWidgets/loading_view.dart';
import '../models/chat_user.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../utilities/debouncer.dart';
import '../utilities/keyboard_utils.dart';
import 'Market.dart';
import 'MarketLetter.dart';
import 'MarketSticker.dart';
import 'PostBox.dart';
import 'SelectLetter.dart';
import 'SelectPerson_test.dart';
import 'chat_page.dart';
import 'login_page.dart';

final imageList=[
  Image.asset('assets/images/before_login.png',fit:BoxFit.cover),
  Image.asset('assets/images/letter.jpg',fit:BoxFit.cover)
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
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation:0.0,
            centerTitle: true,
            title: const Text(
              '잠긴편지',
              style: TextStyle(color:Colors.black),
            ),
            leading: IconButton( // 로그아웃하는 버튼 누르면 login_page로 돌아감
                  onPressed: () => googleSignOut(),
                  color: Colors.black,
                  icon: const Icon(Icons.logout)),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder:(_) => SelectPerson_test())
                    );
                  },
                  color: Colors.black,
                  icon: const Icon(Icons.local_post_office_outlined)),
            ]),

        // body: WillPopScope( // 취소키를 눌러도 뒤로가지 못하게 하기 위함
        //   onWillPop: ()  {
        //     return Future(() => false); //뒤로가기 막음
        //   },
        //   child: Stack(
        //     children: [
        //       Column(
        //         children: const [
        //
        //           // buildSearchBar(),
        //           // Expanded(
        //           //   child: StreamBuilder<QuerySnapshot>(
        //           //     stream: homeProvider.getFirestoreData(
        //           //         FirestoreConstants.pathUserCollection,
        //           //         _limit,
        //           //         _textSearch),
        //           //     builder: (BuildContext context,
        //           //         AsyncSnapshot<QuerySnapshot> snapshot) {
        //           //       if (snapshot.hasData) {
        //           //         if ((snapshot.data?.docs.length ?? 0) > 0) {
        //           //           return ListView.separated(
        //           //             shrinkWrap: true,
        //           //             itemCount: snapshot.data!.docs.length,
        //           //             itemBuilder: (context, index) => buildItem(
        //           //                 context, snapshot.data?.docs[index]),
        //           //             controller: scrollController,
        //           //             separatorBuilder:
        //           //                 (BuildContext context, int index) =>
        //           //                     const Divider(),
        //           //           );
        //           //         } else {
        //           //           return const Center(
        //           //             child: Text('No user found...'),
        //           //           );
        //           //         }
        //           //       } else {
        //           //         return const Center(
        //           //           child: CircularProgressIndicator(),
        //           //         );
        //           //       }
        //           //     },
        //           //   ),
        //           // ),
        //         ],
        //       ),
        //       Positioned(
        //         child:
        //             isLoading ? const LoadingView() : const SizedBox.shrink(),
        //       ),
        //     ],
        //   ),
        // )
      body:ListView(
        children:<Widget>[
          _buildSliderBar(),
          _buildSendLetter(context),
          _buildMarket(context),
          _buildLetterList(context),
          _buildWriter(context),
        ],
      ),
    );
  }

  Widget _buildSliderBar(){ // 맨 위 슬라이드 위젯
    return Container(
        height:300,
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
                                  borderRadius:BorderRadius.circular(10.0) ,
                                  child: image,
                                ),
                              );
                            }
                        );
                      }).toList()
                  )
              ),
              Positioned(
                  top:200,
                  child: Column(
                    children: const [
                      Text(
                        "깊이 잠긴 마음 담아.",
                        style: TextStyle(
                            color:  Color(0xff191919),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Ghanachocolate',
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
  }

//글자 크기 정도만 바꿈
  Widget _buildSendLetter(context){
    return Container(
      width:350,
      height:100,
      child:Card(
        child: Column(
          children: [
            ListTile(
              dense:false,
              title: Text(
                '특별한 글씨체로 잠긴편지 작성하기',
                style: TextStyle(
                    fontFamily:"NotoSansCJKKR",
                    fontSize:18,
                    fontWeight:FontWeight.w400,
                    fontStyle: FontStyle.normal
                ),
              ),
              subtitle:Text(
                '미래로 보내는 정성 가득 손편지',
                style: TextStyle(
                    fontFamily:"NotoSansCJKKR",
                    fontSize:10,
                    fontWeight:FontWeight.w400,
                    fontStyle: FontStyle.normal
                ),
              ),
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(
                    builder:(_) => SelectLetter()
                )
                );
                print('잠긴편지 작성하기');
              },
              trailing: Icon(Icons.arrow_right,color:Colors.blue),
            ),
          ],
        ),
      ),
    );
  }



//기존에 컨테이너 박스로 설정되어 있던 것에 Ink활용해서 이미지 버튼으로 만듦.
//그래서 그리고 각각 이미지 누르면 페이지 넘어가게 만들어 놓았음
  Widget _buildMarket(context){ // 오늘의 마켓 위젯
    return Container(
        padding:const EdgeInsets.all(32),
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
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansKR",
                      fontStyle:  FontStyle.normal,
                      fontSize: 20.0
                  ),
                  textAlign: TextAlign.left,
                ),
                TextButton(
                  onPressed:(){
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder:(_) => (Market())
                    )
                    );
                  },
                  child:Text(
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
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder:(_) => (MarketLetter())
                          )
                          );
                        },
                        child:Ink.image(
                          image: AssetImage('assets/images/before_login.png'),
                          width:80,
                          height:110,
                        )
                    ),

                    Text(
                        "감성필체",
                        style: TextStyle(
                            color:Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle:  FontStyle.normal,
                            fontSize: 20.0
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
                          image: AssetImage('assets/images/before_login.png'),
                          width:80,
                          height:110,
                        )
                    ),
                    Text(
                        "깜찍편지지",
                        style: TextStyle(
                            color:Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle:  FontStyle.normal,
                            fontSize: 20.0
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
                          image: AssetImage('assets/images/before_login.png'),
                          width:80,
                          height:110,
                        )
                    ),
                    Text(
                        "스티커",
                        style: TextStyle(
                            color:Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle:  FontStyle.normal,
                            fontSize: 20.0
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


//우체통 페이지랑 똑같음. 이전의 페이지랑 아에 바꿔놨다고 생각하면 됨
  Widget _buildLetterList(context){ //받은 편지 리스트 위젯
    return Container(
        padding:const EdgeInsets.all(32),
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
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansKR",
                          fontStyle:  FontStyle.normal,
                          fontSize: 20.0
                      ),
                      textAlign: TextAlign.left,
                    ),
                    TextButton(
                      onPressed:(){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder:(_) => (SelectPerson_test())
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
                            fontSize: 10.0
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ]
              ),
              SizedBox(
                  height:20
              ),
              Column(
                  children:const [
                    // Container(
                    //     margin:const EdgeInsets.all(5),
                    //     padding: const EdgeInsets.all(5),
                    //     decoration:BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         border:Border.all(color:Colors.black12, width:1)
                    //     ),
                    //     child:Row(
                    //         mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Container(
                    //               height:30,
                    //               width:20,
                    //               decoration:BoxDecoration(
                    //                   image:DecorationImage(
                    //                       image:AssetImage('assets/letter.jpg')
                    //                   )
                    //               )
                    //           ),
                    //           Container(
                    //             child:Column(
                    //               children: const [
                    //                 Text(
                    //                     "From.채원(@chaerycoc)",
                    //                     style:TextStyle(
                    //                         color:Color(0xff000000),
                    //                         fontSize: 15.0,
                    //                         fontWeight: FontWeight.w400,
                    //                         fontFamily: "SeoulNamsanC-M",
                    //                         fontStyle: FontStyle.normal
                    //                     )
                    //                 ),
                    //                 Text(
                    //                     "너는 이 편지를 1년 뒤에 읽겠지?ㅎㅎ",
                    //                     style:TextStyle(
                    //                         color:Color(0xff767676),
                    //                         fontSize:10.0
                    //                     )
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Text(
                    //               'D-365'
                    //           ),
                    //           Container(
                    //               child:Column(
                    //                 crossAxisAlignment:CrossAxisAlignment.end,
                    //                 children: [
                    //                   Text(
                    //                       '받은날: 21.01.01',
                    //                       style:TextStyle(
                    //                           color:Color(0xff767676),
                    //                           fontSize:8.0
                    //                       )
                    //                   ),
                    //                   Text(
                    //                       '개봉일: 22.02.25',
                    //                       style:TextStyle(
                    //                           color:Color(0xff767676),
                    //                           fontSize:8.0
                    //                       )
                    //                   )
                    //                 ],
                    //               )
                    //           )
                    //         ]
                    //     )
                    // ),
                    // Container(
                    //     margin:const EdgeInsets.all(5),
                    //     padding: const EdgeInsets.all(5),
                    //     decoration:BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         border:Border.all(color:Colors.black12, width:1)
                    //     ),
                    //     child:Row(
                    //         mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Container(
                    //               height:30,
                    //               width:20,
                    //               decoration:BoxDecoration(
                    //                   image:DecorationImage(
                    //                       image:AssetImage('assets/letter.jpg')
                    //                   )
                    //               )
                    //           ),
                    //           Container(
                    //             child:Column(
                    //               children: [
                    //                 Text(
                    //                     "From.채원(@chaerycoc)",
                    //                     style:TextStyle(
                    //                         color:Color(0xff000000),
                    //                         fontSize: 15.0,
                    //                         fontWeight: FontWeight.w400,
                    //                         fontFamily: "SeoulNamsanM",
                    //                         fontStyle: FontStyle.normal
                    //                     )
                    //                 ),
                    //                 Text(
                    //                     "너는 이 편지를 1년 뒤에 읽겠지?ㅎㅎ",
                    //                     style:TextStyle(
                    //                         color:Color(0xff767676),
                    //                         fontSize:10.0
                    //                     )
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Text(
                    //               'D-365'
                    //           ),
                    //           Container(
                    //               child:Column(
                    //                 crossAxisAlignment:CrossAxisAlignment.end,
                    //                 children: const [
                    //                   Text(
                    //                       '받은날: 21.01.01',
                    //                       style:TextStyle(
                    //                           color:Color(0xff767676),
                    //                           fontSize:8.0
                    //                       )
                    //                   ),
                    //                   Text(
                    //                       '개봉일: 22.02.25',
                    //                       style:TextStyle(
                    //                           color:Color(0xff767676),
                    //                           fontSize:8.0
                    //                       )
                    //                   )
                    //                 ],
                    //               )
                    //           )
                    //         ]
                    //     )
                    // ),
                    // Container(
                    //     margin:const EdgeInsets.all(5),
                    //     padding: const EdgeInsets.all(5),
                    //     decoration:BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         border:Border.all(color:Colors.black12, width:1)
                    //     ),
                    //     child:Row(
                    //         mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Container(
                    //               height:30,
                    //               width:20,
                    //               decoration:const BoxDecoration(
                    //                   image:DecorationImage(
                    //                       image:AssetImage('assets/images/letter.jpg')
                    //                   )
                    //               )
                    //           ),
                    //           Container(
                    //             child:Column(
                    //               children: const [
                    //                 Text(
                    //                     "From.채원(@chaerycoc)",
                    //                     style:TextStyle(
                    //                         color:Color(0xff000000),
                    //                         fontSize: 15.0,
                    //                         fontWeight: FontWeight.w400,
                    //                         fontFamily: "SeoulNamsanM",
                    //                         fontStyle: FontStyle.normal
                    //                     )
                    //                 ),
                    //                 Text(
                    //                     "너는 이 편지를 1년 뒤에 읽겠지?ㅎㅎ",
                    //                     style:TextStyle(
                    //                         color:Color(0xff767676),
                    //                         fontSize:10.0
                    //                     )
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           const Text(
                    //               'D-365'
                    //           ),
                    //           Container(
                    //               child:Column(
                    //                 crossAxisAlignment:CrossAxisAlignment.end,
                    //                 children: const [
                    //                   Text(
                    //                       '받은날: 21.01.01',
                    //                       style:TextStyle(
                    //                           color:Color(0xff767676),
                    //                           fontSize:8.0
                    //                       )
                    //                   ),
                    //                   Text(
                    //                       '개봉일: 22.02.25',
                    //                       style:TextStyle(
                    //                           color:Color(0xff767676),
                    //                           fontSize:8.0
                    //                       )
                    //                   )
                    //                 ],
                    //               )
                    //           )
                    //         ]
                    //     )
                    // ),
                    // Container(
                    //     margin:const EdgeInsets.all(5),
                    //     padding: const EdgeInsets.all(5),
                    //     decoration:BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         border:Border.all(color:Colors.black12, width:1)
                    //     ),
                    //     child:Row(
                    //         mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Container(
                    //               height:30,
                    //               width:20,
                    //               decoration:const BoxDecoration(
                    //                   image:DecorationImage(
                    //                       image:AssetImage('assets/letter.jpg')
                    //                   )
                    //               )
                    //           ),
                    //           Container(
                    //             child:Column(
                    //               children: const [
                    //                 Text(
                    //                     "From.채원(@chaerycoc)",
                    //                     style:TextStyle(
                    //                         color:Color(0xff000000),
                    //                         fontSize: 15.0,
                    //                         fontWeight: FontWeight.w400,
                    //                         fontFamily: "SeoulNamsanM",
                    //                         fontStyle: FontStyle.normal
                    //                     )
                    //                 ),
                    //                 Text(
                    //                     "너는 이 편지를 1년 뒤에 읽겠지?ㅎㅎ",
                    //                     style:TextStyle(
                    //                         color:Color(0xff767676),
                    //                         fontSize:10.0
                    //                     )
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Text(
                    //               'D-365'
                    //           ),
                    //           Container(
                    //               child:Column(
                    //                 crossAxisAlignment:CrossAxisAlignment.end,
                    //                 children: const [
                    //                   Text(
                    //                       '받은날: 21.01.01',
                    //                       style:TextStyle(
                    //                         color:Color(0xff767676),
                    //                         fontSize:8.0,
                    //
                    //                       )
                    //                   ),
                    //                   Text(
                    //                       '개봉일: 22.02.25',
                    //                       style:TextStyle(
                    //                           color:Color(0xff767676),
                    //                           fontSize:8.0
                    //                       )
                    //                   )
                    //                 ],
                    //               )
                    //           )
                    //         ]
                    //     )
                    // )
                  ]
              )
            ]
        )
    );
  }

  Widget _buildWriter(context) {
    // 이런 라이터는 어때요? 위젯추가
    return Container(
        padding: const EdgeInsets.all(32),
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
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansKR",
                      fontStyle: FontStyle.normal,
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
                      width: 100,
                      height: 100,
                      color: Colors.grey,

                    ),
                    Text(
                        "장도진",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        "70년간 꼼꼼히 작성했던 가계부가 아이들 사이에서 화제가 된적이 있었죠",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 5.0
                        ),
                        textAlign: TextAlign.left
                    ),

                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey
                    ),
                    Text(
                        "방진욱",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        "제가 대학생이었을 때, 연애편지를 써준 친구들 중 잘 안된 사람이 없었어요 ",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 5.0
                        ),
                        textAlign: TextAlign.left
                    )
                  ],
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
                      width: 100,
                      height: 100,
                      color: Colors.grey,

                    ),
                    Text(
                        "김채원",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        "70년간 꼼꼼히 작성했던 가계부가 아이들 사이에서 화제가 된적이 있었죠",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 5.0
                        ),
                        textAlign: TextAlign.left
                    ),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey
                    ),
                    Text(
                        "유혜린",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        "제가 대학생이었을 때, 연애편지를 써준 친구들 중 잘 안된 사람이 없었어요 ",
                        style: TextStyle(
                            color: Color(0xff191919),
                            fontWeight: FontWeight.w300,
                            fontFamily: "S-CoreDream-3",
                            fontStyle: FontStyle.normal,
                            fontSize: 5.0
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
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(Sizes.dimen_10),
      height: Sizes.dimen_50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: Sizes.dimen_10,
          ),
          const Icon(
            Icons.person_search,
            color: AppColors.white,
            size: Sizes.dimen_24,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchTextEditingController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  buttonClearController.add(true);
                  setState(() {
                    _textSearch = value;
                  });
                } else {
                  buttonClearController.add(false);
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search here...',
                hintStyle: TextStyle(color: AppColors.white),
              ),
            ),
          ),
          StreamBuilder(
              stream: buttonClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchTextEditingController.clear();
                          buttonClearController.add(false);
                          setState(() {
                            _textSearch = '';
                          });
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.greyColor,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              })
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.dimen_30),
        color: AppColors.spaceLight,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    final firebaseAuth = FirebaseAuth.instance;
    if (documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
      if (userChat.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          peerId: userChat.id,
                          peerAvatar: userChat.photoUrl,
                          peerNickname: userChat.displayName,
                          userAvatar: firebaseAuth.currentUser!.photoURL!,
                        )));
          },
          child: ListTile(
            leading: userChat.photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.dimen_30),
                    child: Image.network(
                      userChat.photoUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
            title: Text(
              userChat.displayName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
