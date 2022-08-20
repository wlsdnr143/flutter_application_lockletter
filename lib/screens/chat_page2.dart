//나에게 쓰는 편지 전송창

import 'dart:io';
import 'package:fluttergooglesignin/screens/sendComplete.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../allConstants/firestore_constants.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'login_page.dart';

class ChatPage2 extends StatefulWidget {
  final String peerId;
  final String peerNickname;
  // final String peerAvatar;
  // final String userAvatar;

  const ChatPage2(
      {Key? key,
        required this.peerNickname,
        required this.peerId,
        //required this.peerAvatar,
        //required this.userAvatar
      })
      : super(key: key);

  @override
  State<ChatPage2> createState() => _ChatPage2State();
}

class _ChatPage2State extends State<ChatPage2> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (authProvider
        .getFirebaseUserId()
        ?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(widget.peerId) > 0) {
      groupChatId = '$currentUserId - ${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId} - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: widget.peerId});
  }

  // Future getImage() async { // 채팅 보낼때 기기에서 이미지 선택할 수 있게해주는 함수
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? pickedFile;
  //   pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     imageFile = File(pickedFile.path);
  //     if (imageFile != null) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       uploadImageFile();
  //     }
  //   }
  // }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "10글자 이상 입력해주세요",
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void onSendMessage(String content, int type) {
    // create a method to send chat messages and execute our sendChatMessage function from our ChatProvider class
    if (content
        .trim()
        .isNotEmpty) {
      textEditingController.clear();
      // chatProvider.sendChatMessage(
      //     content, type, groupChatId, currentUserId, widget.peerId);
      chatProvider.sendMail(content, type, currentUserId,
          widget.peerId); // change end point to the firebase
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
        listMessages[index - 1].get(FirestoreConstants.idFrom) ==
            currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
        listMessages[index - 1].get(FirestoreConstants.idFrom) !=
            currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            color: Colors.black,
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('${widget.peerNickname}에게 보내는 편지'.trim(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontFamily: "NotoSansKR_Medium",
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       ProfileProvider profileProvider;
        //       profileProvider = context.read<ProfileProvider>();
        //       String callPhoneNumber =
        //           profileProvider.getPrefs(FirestoreConstants.phoneNumber) ??
        //               "";
        //       _callPhoneNumber(callPhoneNumber);
        //     },
        //     icon: const Icon(Icons.phone),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // buildListMessage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '온라인 잠긴편지',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'NotoSansKR_Bold'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (textEditingController.text.length < 10) {
                          FlutterDialog();
                        }
                        else {
                          onSendMessage(
                              textEditingController.text, MessageType.text);
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (_) => const SendComplete()
                          )
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff6bb9ff),
                          minimumSize: Size(50, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text(
                          '보내기',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'KyoboHandwriting2019'),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 10),
              buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildMessageInput() {
    late ScrollController _scrollController;

    void initState() {
      super.initState();
      _scrollController = ScrollController();
    }

    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }
    // 사용자가 문자 메시지를 입력하고 보내기 버튼을 클릭하여 메시지를 보낼 입력 필드를 만들어야 합니다 .
    // 또한 이미지 선택기 버튼을 사용하여 사용자가 클릭하면 장치의 파일 선택기가 열리고 이미지를 선택하여 사용자에게 보냅니다.
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: Column(
        children: [
          Flexible(
              child: SingleChildScrollView(
                //controller: _scrollController,
                child: TextFormField(
                  onTap: () {
                    //120만큼 500milSec 동안 뷰를 올려줌
                    _scrollController.animateTo(120.0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  focusNode: focusNode,
                  textInputAction: TextInputAction.newline,
                  // TextInputAction.send 로 하면 보내기버튼 TextInputAction.go로 하면 엔터
                  keyboardType: TextInputType.multiline,
                  maxLines: 30,
                  maxLength: 900,
                  textCapitalization: TextCapitalization.sentences,
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff1f1f5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
              )),
          //SizedBox(height:300),
        ],
      ),
    );
  }

// Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
//   // 프로필 사진과 함께 주고받은 문자 메시지에 대한 채팅 풍선을 생성합니다.
//   if (documentSnapshot != null) {
//     ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
//     if (chatMessages.idFrom == currentUserId) {
//       // right side (my message)
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               chatMessages.type == MessageType.text
//                   ? messageBubble(
//                       chatContent: chatMessages.content,
//                       color: AppColors.spaceLight,
//                       textColor: AppColors.white,
//                       margin: const EdgeInsets.only(right: Sizes.dimen_10),
//                     )
//                   : chatMessages.type == MessageType.image
//                       ? Container(
//                           margin: const EdgeInsets.only(
//                               right: Sizes.dimen_10, top: Sizes.dimen_10),
//                           child: chatImage(
//                               imageSrc: chatMessages.content, onTap: () {}),
//                         )
//                       : const SizedBox.shrink(),
//               isMessageSent(index)
//                   ? Container(
//                       clipBehavior: Clip.hardEdge,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(Sizes.dimen_20),
//                       ),
//                       child: Image.network(
//                         widget.userAvatar,
//                         width: Sizes.dimen_40,
//                         height: Sizes.dimen_40,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (BuildContext ctx, Widget child,
//                             ImageChunkEvent? loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Center(
//                             child: CircularProgressIndicator(
//                               color: AppColors.burgundy,
//                               value: loadingProgress.expectedTotalBytes !=
//                                           null &&
//                                       loadingProgress.expectedTotalBytes !=
//                                           null
//                                   ? loadingProgress.cumulativeBytesLoaded /
//                                       loadingProgress.expectedTotalBytes!
//                                   : null,
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, object, stackTrace) {
//                           return const Icon(
//                             Icons.account_circle,
//                             size: 35,
//                             color: AppColors.greyColor,
//                           );
//                         },
//                       ),
//                     )
//                   : Container(
//                       width: 35,
//                     ),
//             ],
//           ),
//           isMessageSent(index)
//               ? Container(
//                   margin: const EdgeInsets.only(
//                       right: Sizes.dimen_50,
//                       top: Sizes.dimen_6,
//                       bottom: Sizes.dimen_8),
//                   child: Text(
//                     DateFormat('dd MMM yyyy, hh:mm a').format(
//                       DateTime.fromMillisecondsSinceEpoch(
//                         int.parse(chatMessages.timestamp),
//                       ),
//                     ),
//                     style: const TextStyle(
//                         color: AppColors.lightGrey,
//                         fontSize: Sizes.dimen_12,
//                         fontStyle: FontStyle.italic),
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       );
//     } else {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               isMessageReceived(index)
//                   // left side (received message)
//                   ? Container(
//                       clipBehavior: Clip.hardEdge,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(Sizes.dimen_20),
//                       ),
//                       child: Image.network(
//                         widget.peerAvatar,
//                         width: Sizes.dimen_40,
//                         height: Sizes.dimen_40,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (BuildContext ctx, Widget child,
//                             ImageChunkEvent? loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Center(
//                             child: CircularProgressIndicator(
//                               color: AppColors.burgundy,
//                               value: loadingProgress.expectedTotalBytes !=
//                                           null &&
//                                       loadingProgress.expectedTotalBytes !=
//                                           null
//                                   ? loadingProgress.cumulativeBytesLoaded /
//                                       loadingProgress.expectedTotalBytes!
//                                   : null,
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, object, stackTrace) {
//                           return const Icon(
//                             Icons.account_circle,
//                             size: 35,
//                             color: AppColors.greyColor,
//                           );
//                         },
//                       ),
//                     )
//                   : Container(
//                       width: 35,
//                     ),
//               chatMessages.type == MessageType.text
//                   ? messageBubble(
//                       color: AppColors.burgundy,
//                       textColor: AppColors.white,
//                       chatContent: chatMessages.content,
//                       margin: const EdgeInsets.only(left: Sizes.dimen_10),
//                     )
//                   : chatMessages.type == MessageType.image
//                       ? Container(
//                           margin: const EdgeInsets.only(
//                               left: Sizes.dimen_10, top: Sizes.dimen_10),
//                           child: chatImage(
//                               imageSrc: chatMessages.content, onTap: () {}),
//                         )
//                       : const SizedBox.shrink(),
//             ],
//           ),
//           isMessageReceived(index)
//               ? Container(
//                   margin: const EdgeInsets.only(
//                       left: Sizes.dimen_50,
//                       top: Sizes.dimen_6,
//                       bottom: Sizes.dimen_8),
//                   child: Text(
//                     DateFormat('dd MMM yyyy, hh:mm a').format(
//                       DateTime.fromMillisecondsSinceEpoch(
//                         int.parse(chatMessages.timestamp),
//                       ),
//                     ),
//                     style: const TextStyle(
//                         color: AppColors.lightGrey,
//                         fontSize: Sizes.dimen_12,
//                         fontStyle: FontStyle.italic),
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       );
//     }
//   } else {
//     return const SizedBox.shrink();
//   }
// }

//   Widget buildListMessage() { // 모든 문자 메시지와 이미지가 보낸 사람과 받는 사람에 대해 별도로 표시되는 보기를 만드는 코드
//     return Flexible(
//       child: groupChatId.isNotEmpty
//           ? StreamBuilder<QuerySnapshot>(
//               stream: chatProvider.getChatMessage(groupChatId, _limit),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasData) {
//                   listMessages = snapshot.data!.docs;
//                   if (listMessages.isNotEmpty) {
//                     return ListView.builder(
//                         padding: const EdgeInsets.all(10),
//                         itemCount: snapshot.data?.docs.length,
//                         reverse: true,
//                         controller: scrollController,
//                         itemBuilder: (context, index) =>
//                             buildItem(index, snapshot.data?.docs[index]));
//                   } else {
//                     return const Center(
//                       child: Text('No messages...'),
//                     );
//                   }
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: AppColors.burgundy,
//                     ),
//                   );
//                 }
//               })
//           : const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.burgundy,
//               ),
//             ),
//     );
//   }
// }
}