import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttergooglesignin/allConstants/all_constants.dart';
import 'package:fluttergooglesignin/providers/chat_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../allConstants/color_constants.dart';
import '../allConstants/size_constants.dart';
import '../allConstants/text_field_constants.dart';
import '../allWidgets/loading_view.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../providers/profile_provider.dart';
import '../utilities/debouncer.dart';
import 'login_page.dart';

class SelectPerson_showMail extends StatefulWidget {
  const SelectPerson_showMail({Key? key}) : super(key: key);

  @override
  State<SelectPerson_showMail> createState() => _SelectPerson_showMailState();
}

class _SelectPerson_showMailState extends State<SelectPerson_showMail> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController scrollController = ScrollController();

  bool fromTo = true;
  String from = '';
  String to = '';

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;

  late AuthProvider authProvider;
  late String currentUserId;
  late HomeProvider homeProvider;
  late ChatProvider chatProvier;
  late ProfileProvider profileProvier;


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
    chatProvier = context.read<ChatProvider>();
    profileProvier = context.read<ProfileProvider>();
    profileProvier.init();

    if (authProvider
        .getFirebaseUserId()
        ?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false);
    }

    scrollController.addListener(scrollListener);
  }

  void FlutterDialog() {
    // 알림창 함수
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text("사용자 코드"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(currentUserId),
              ],
            ),
            actions: <Widget>[
              CupertinoButton( // currentUserId 복사 버튼
                child: const Text(
                    "복사", style: TextStyle(color: Colors.blue, fontSize: 15)),
                color: Colors.white,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: currentUserId));
                },
              ),
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
                leading:  IconButton(
                    onPressed: () {
                      Navigator.pop(context); //뒤로가기
                    },
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back)),
                title: const Text(
                  '우체통',
                  style: TextStyle(
                    fontSize: 18,
                    color:  Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: "NotoSansKR_Medium",
                  ),
                ),
                centerTitle: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                bottom: const TabBar(
                  indicatorColor: Colors.blue,
                  labelColor: Colors.black,
                  unselectedLabelColor: Color(0xff767676),
                  unselectedLabelStyle: TextStyle(color:  Color(0xff767676), fontSize: 10),
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                            '받은편지함',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'NotoSansKR_Regular',
                                fontSize: 12.0
                            )
                        ),
                      ),
                      Tab(
                        child: Text(
                            '보낸편지함',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'NotoSansKR_Regular',
                                fontSize: 12.0
                            )
                        ),
                      ),
                      Tab(
                        child: Text(
                            '내게 쓴 편지',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.0,
                                fontFamily: 'NotoSansKR_Regular',
                            )
                        ),
                      ),
                      Tab(
                        child: Text(
                            '즐겨찾기',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'NotoSansKR_Regular',
                                fontSize: 12.0
                            )
                        ),
                      )
                    ],
                )
            ),
            body: WillPopScope(
              onWillPop: null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child: Stack(
                  children: [
                    const SizedBox(height: 500),
                    TabBarView(
                      children:[
                        Column(
                        children: [
                          //const SizedBox(height: 30),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: chatProvier.getMailStream(
                                  authProvider.firebaseAuth.currentUser!.uid, 100),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  fromTo = false;
                                  final allData = snapshot.data!.docs.map((doc) =>
                                      doc.data()).toList();
                                  if ((snapshot.data?.docs.length ?? 0) > 0) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) =>
                                          buildItem(
                                              context, snapshot.data?.docs[index],false),
                                      controller: scrollController,
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                      const Divider(),
                                    );
                                  } else {
                                    return const Center(
                                      child: Text('받은 편지가 없습니다'),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height:10),
                        ],
                      ),
                    Column( // 보낸 편지함
                      children: [
                        //const SizedBox(height: 30),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: chatProvier.getSendMailStream(authProvider.firebaseAuth.currentUser!.uid, 100),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                fromTo = true;
                                final allData = snapshot.data!.docs.map((doc) =>
                                    doc.data()).toList();
                                if ((snapshot.data?.docs.length ?? 0) > 0) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) =>
                                        buildItem(
                                            context, snapshot.data?.docs[index],true),
                                    controller: scrollController,
                                    separatorBuilder:
                                        (BuildContext context, int index) => const Divider(),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('보낸 편지가 없습니다'),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height:10),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height:210),
                        Center(
                          child: Container(
                            child: Text(
                              '개발중',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'SeoulNamsanM'),
                            ),
                          ),
                        ),
                      ],
                    ),
                        Column(
                          children: [
                            SizedBox(height:210),
                            Center(
                              child: Container(
                                child: Text(
                                  '개발중',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'SeoulNamsanM'),
                                ),
                              ),
                            ),
                          ],
                        ),],)]
                ),
              ),
            )));
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

  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot,bool self) {
    String senderId = self?documentSnapshot!.get('idTo'):documentSnapshot!.get('idFrom');
    String timestamp = documentSnapshot!.get('timestamp');
    String content = documentSnapshot!.get('content');

    String stringFromto = '';
    String who = profileProvier.profileMap[senderId]['displayName'];

    if(fromTo == false){
      stringFromto = 'From. ' + profileProvier.profileMap[senderId]['displayName'];
    }
    else{
      stringFromto = 'To. ' + profileProvier.profileMap[senderId]['displayName'];
    }

    if (documentSnapshot != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0,0.0,0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: (){
                Navigator.push(
                  context,MaterialPageRoute(
                  builder: (context) => LetterViewer(text:content,
                      //who:senderId
                    id : who,
                  ),
                ),);},
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color : Color.fromRGBO(112, 112, 112, 0.5), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                    maxWidth: 40,
                    maxHeight: 40,
                  ),
                    child: Image.asset('assets/images/invalid_name.png', fit: BoxFit.cover),
                  // child: Image.network(
                  //   profileProvier.profileMap[senderId]['photoUrl'],
                  //   fit: BoxFit.cover,
                  //   width: 50,
                  //   height: 50,
                  //   loadingBuilder: (BuildContext ctx, Widget child,
                  //       ImageChunkEvent? loadingProgress) {
                  //     if (loadingProgress == null) {
                  //       return child;
                  //     } else {
                  //       return SizedBox(
                  //         width: 50,
                  //         height: 50,
                  //         child: CircularProgressIndicator(
                  //             color: Colors.grey,
                  //             value: loadingProgress.expectedTotalBytes !=
                  //                 null
                  //                 ? loadingProgress.cumulativeBytesLoaded /
                  //                 loadingProgress.expectedTotalBytes!
                  //                 : null),
                  //       );
                  //     }
                  //   },
                  //   errorBuilder: (context, object, stackTrace) {
                  //     return const Icon(Icons.account_circle, size: 50);
                  //   },
                  // ),
                ),

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stringFromto,
                            style: const TextStyle(color: Colors.black,
                                fontSize: 13),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            content[0]+content[1] + content[2] + content[3] + content[4] + content[5] +
                                content[6] +content[7] + content[8] +'..',
                            style: const TextStyle(color: Colors.black38,
                                fontSize: 13),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat('\n\n받은날: yyyy.MM.dd').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(timestamp),
                            ),
                          ),
                          style: const TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: 10,
                              fontStyle: FontStyle.italic),
                        ),
                        const Text(
                          '개봉일: 20xx.xx.xx   ',
                          style: TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: 10,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Text('');
  }
}


class LetterViewer extends StatelessWidget {
   LetterViewer({key,
    required this.text, required this.id,
    // required this.who
  }) : super(key: key);

  final String text;
  final String id;
  var textLength = 0;
  // final String who;

  @override
  Widget build(BuildContext context) { // 편지가 보여지는 창
    if(text.length<500){
      textLength = 500;
    }
    else {
      textLength = text.length;
    }

    return Scaffold(
      appBar:AppBar(
        leading:  IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            color: Colors.black,
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.transparent,
        elevation:0.0,
        centerTitle: false,
        title: const Text(
          '열린편지',
          style: TextStyle(color:Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:20),
              const Text('보낸사람',
                style: TextStyle(
                    color:Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "SCDream4",
                    fontStyle:  FontStyle.normal,
                    fontSize: 15.0
                ),),
              SizedBox(height:7),
              Text(id,
                style: const TextStyle(
                    color:Color(0xff767676),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansKR_Regular",
                    fontStyle:  FontStyle.normal,
                    fontSize: 13.0
                ),),
              SizedBox(height:20),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f5),
                  border: Border.all(
                    width: 1,
                    color: Colors.transparent,
                  ),
                ), //  POINT: BoxDecoration
                width: 300,
                height: textLength+10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(text,
                    style: const TextStyle(
                        color:Color(0xff433e50),
                        fontWeight: FontWeight.w300,
                        fontFamily: "SCDream4",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    ),),
                ),
              ),
              SizedBox(height:30),
            ],
          ),
        ),
      ),
    );
  }
}

